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
    assert(not game.answer_locked)

    # The next REMEMBER challenge is not immediately answerable. A premature
    # input must therefore be ignored and must not mutate progression.
    var before_level: int = game.challenge_manager.index
    var before_correct: int = game.progression.total_correct
    game._on_choice(1)
    assert(game.challenge_manager.index == before_level)
    assert(game.progression.total_correct == before_correct)

    await create_timer(1.05).timeout
    assert(game.challenge_view.input_ready)
    assert(not game.answer_locked)

    # Sequence level 2 accepts index 0; selecting another option must keep the
    # player on the same level and reset the streak without advancing.
    game._on_choice(1)
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
