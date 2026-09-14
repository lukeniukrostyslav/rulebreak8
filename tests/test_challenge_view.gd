extends SceneTree

const ChallengeViewScript = preload("res://scripts/core/challenge_view_v2.gd")

func _wait(seconds: float) -> void:
    await create_timer(seconds).timeout

func _assert_ready(view, expected_id: String, expected_ready: bool) -> void:
    assert(view.challenge_id == expected_id)
    assert(view.input_ready == expected_ready)

func _init() -> void:
    var view = ChallengeViewScript.new()
    root.add_child(view)
    await process_frame
    var see := {"id":"see_change", "kind_key":"KIND_SEE", "correct":0}
    view.show_challenge(see)
    await process_frame
    _assert_ready(view, "see_change", true)
    assert(view.correct_index == 0)
    var remember := {"id":"sequence", "kind_key":"KIND_REMEMBER", "correct":0}
    view.show_challenge(remember)
    assert(not view.input_ready)
    view.show_challenge(see)
    await _wait(0.05)
    _assert_ready(view, "see_change", true)
    assert(view.phase_token == 3)
    var react := {"id":"color_timer", "kind_key":"KIND_REACT", "correct":2}
    view.show_challenge(react)
    await _wait(1.00)
    _assert_ready(view, "color_timer", true)
    await _wait(1.50)
    assert(not view.input_ready)
    var switch := {"id":"rule_switch", "kind_key":"KIND_SWITCH", "correct":1}
    view.show_challenge(switch)
    assert(not view.input_ready)
    await _wait(1.25)
    _assert_ready(view, "rule_switch", true)
    var trick := {"id":"word_color", "kind_key":"KIND_TRICK", "correct":0}
    view.show_challenge(trick)
    await process_frame
    _assert_ready(view, "word_color", true)
    var mix := {"id":"mixed", "kind_key":"KIND_MIX", "correct":2}
    view.show_challenge(mix)
    assert(not view.input_ready)
    await _wait(1.45)
    _assert_ready(view, "mixed", true)
    print("RULEBREAK ChallengeView timing/state tests: PASS")
    quit(0)
