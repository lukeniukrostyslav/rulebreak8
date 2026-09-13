extends SceneTree

func _init() -> void:
    var view := ChallengeView.new()
    root.add_child(view)
    await process_frame

    var see := {
        "id": "see_change",
        "kind_key": "KIND_SEE",
        "correct": 0
    }
    view.show_challenge(see)
    await process_frame
    assert(view.input_ready)
    assert(view.challenge_id == "see_change")
    assert(view.correct_index == 0)

    var remember := {
        "id": "sequence",
        "kind_key": "KIND_REMEMBER",
        "correct": 0
    }
    view.show_challenge(remember)
    assert(not view.input_ready)
    view.show_challenge(see)
    await create_timer(0.05).timeout
    assert(view.input_ready)
    assert(view.challenge_id == "see_change")
    assert(view.phase_token == 3)

    var react := {
        "id": "color_timer",
        "kind_key": "KIND_REACT",
        "correct": 2
    }
    view.show_challenge(react)
    await create_timer(1.0).timeout
    assert(view.input_ready)
    await create_timer(0.55).timeout
    assert(not view.input_ready)

    print("RULEBREAK ChallengeView timing/state tests: PASS")
    quit(0)
