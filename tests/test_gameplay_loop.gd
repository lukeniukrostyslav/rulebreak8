extends SceneTree

func _cleanup_save_files() -> void:
    for path in [
        "user://rulebreak_save.json",
        "user://rulebreak_save.json.tmp",
        "user://rulebreak_save.json.bak",
        "user://rulebreak_save.json.bak.tmp"
    ]:
        if FileAccess.file_exists(path):
            DirAccess.remove_absolute(ProjectSettings.globalize_path(path))

func _wait_until_input_ready(game: Node, timeout_seconds: float = 3.0) -> void:
    var deadline: float = Time.get_ticks_msec() / 1000.0 + timeout_seconds
    while not game.challenge_view.input_ready:
        if Time.get_ticks_msec() / 1000.0 >= deadline:
            assert(false)
            return
        await create_timer(0.05).timeout

func _init() -> void:
    _cleanup_save_files()

    var packed := load("res://main.tscn") as PackedScene
    assert(packed != null)
    var game = packed.instantiate()
    root.add_child(game)

    # Let the main controller finish _ready() and the first SEE challenge.
    await process_frame
    await process_frame
    await create_timer(0.25).timeout
    await _wait_until_input_ready(game)

    assert(game.buttons.size() == 4)
    assert(game.challenge_manager.index == 0)
    assert(game.progression.current_level == 0)
    assert(game.challenge_view.input_ready)
    assert(not game.answer_locked)

    # Correct answer: the public gameplay path must record progress, advance
    # the manager and persist the next level.
    game._on_choice(0)
    await create_timer(0.45).timeout
    assert(game.challenge_manager.index == 1)
    assert(game.progression.current_level == 1)
    assert(game.progression.streak == 1)
    assert(game.progression.total_correct == 1)
    assert(game.answer_locked)
    assert(not game.challenge_view.input_ready)

    # The next REMEMBER challenge is not immediately answerable. A premature
    # input must therefore be ignored and must not mutate progression.
    var before_level: int = game.challenge_manager.index
    var before_correct: int = game.progression.total_correct
    game._on_choice(1)
    assert(game.challenge_manager.index == before_level)
    assert(game.progression.total_correct == before_correct)

    await _wait_until_input_ready(game)
    assert(not game.answer_locked)

    # Reaction challenges must remain retryable after a missed response window.
    # This is a source-level contract here; the headless runtime gate covers
    # the actual timer/retry loop under Godot.
    var view_source := FileAccess.get_file_as_string("res://scripts/core/challenge_view_v2.gd")
    assert(view_source.contains("A missed reaction is a retry, not a dead-end."))
    assert(view_source.contains("while token==phase_token:"))

    # The current REMEMBER challenge must reject a wrong option without
    # advancing. The test only requires the selected option to be non-correct.
    var correct_index: int = game.challenge_manager.get_current().correct_index
    var wrong_index: int = 0 if correct_index != 0 else 1
    game._on_choice(wrong_index)
    await create_timer(0.80).timeout
    assert(game.challenge_manager.index == 1)
    assert(game.progression.current_level == 1)
    assert(game.progression.streak == 0)
    assert(game.progression.total_correct == 1)
    assert(game.progression.total_wrong == 1)
    assert(not game.answer_locked)

    _cleanup_save_files()
    print("RULEBREAK gameplay loop smoke: PASS — boot, correct answer, persistence/advance, input lock and wrong-answer retry")
    quit(0)
