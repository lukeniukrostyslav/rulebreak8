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

    await process_frame
    await process_frame
    await create_timer(0.25).timeout
    await _wait_until_input_ready(game)

    assert(game.buttons.size() == 4)
    assert(game.challenge_manager.index == 0)
    assert(game.progression.current_level == 0)
    assert(game.challenge_view.input_ready)
    assert(not game.answer_locked)

    game._on_choice(0)
    assert(game.answer_locked)
    assert(not game.challenge_view.input_ready)
    await create_timer(0.45).timeout
    assert(game.challenge_manager.index == 1)
    assert(game.progression.current_level == 1)
    assert(game.progression.streak == 1)
    assert(game.progression.total_correct == 1)
    assert(not game.answer_locked)

    var before_level: int = game.challenge_manager.index
    var before_correct: int = game.progression.total_correct
    game._on_choice(1)
    assert(game.challenge_manager.index == before_level)
    assert(game.progression.total_correct == before_correct)

    await _wait_until_input_ready(game)
    assert(not game.answer_locked)

    var view_source := FileAccess.get_file_as_string("res://scripts/core/challenge_view_v2.gd")
    assert(view_source.contains("A missed reaction is a retry, not a dead-end."))
    assert(view_source.contains("while token==phase_token:"))

    # ChallengeManager exposes its catalog through `challenges`; keep the
    # gameplay smoke test aligned with that public contract rather than
    # depending on a nonexistent get_current() helper.
    var current_challenge: Dictionary = game.challenge_manager.challenges[game.challenge_manager.index]
    var correct_index: int = int(current_challenge.get("correct", -1))
    assert(correct_index >= 0 and correct_index < 4)
    var wrong_index: int = 0 if correct_index != 0 else 1
    game._on_choice(wrong_index)
    await create_timer(0.80).timeout
    assert(game.challenge_manager.index == 1)
    assert(game.progression.current_level == 1)
    assert(game.progression.streak == 0)
    assert(game.progression.total_correct == 1)
    assert(game.progression.total_wrong == 1)
    assert(not game.answer_locked)

    # A real missed reaction must be recorded as a timeout, not silently
    # remain in the renderer's retry loop. Start the first REACT challenge
    # directly and wait beyond its response window without answering.
    game.challenge_manager.index = 4
    game.progression.set_current_level(4)
    game._show_challenge()
    await _wait_until_input_ready(game, 2.0)
    assert(game.reaction_duration_ms == 1400)
    assert(not game.answer_locked)
    await create_timer(2.0).timeout
    assert(game.challenge_manager.index == 4)
    assert(game.progression.current_level == 4)
    assert(game.progression.total_wrong == 2)
    assert(game.progression.streak == 0)
    assert(not game.challenge_view.input_ready)

    game.queue_free()
    await process_frame
    _cleanup_save_files()
    print("RULEBREAK gameplay loop smoke: PASS — boot, correct answer, immediate input lock, wrong-answer retry and real reaction timeout")
    quit(0)
