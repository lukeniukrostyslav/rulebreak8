extends SceneTree

const ChallengeViewScript = preload("res://scripts/core/challenge_view_v2.gd")
const ChallengeManagerScript = preload("res://scripts/core/challenge_manager.gd")

func _wait(seconds: float) -> void:
    await create_timer(seconds).timeout

func _assert_ready(view, expected_id: String, expected_ready: bool) -> void:
    assert(view.challenge_id == expected_id)
    assert(view.input_ready == expected_ready)

func _init() -> void:
    var view = ChallengeViewScript.new()
    root.add_child(view)
    await process_frame

    var manager = ChallengeManagerScript.new()
    assert(manager.challenges.size() == 100)
    for challenge in manager.challenges:
        var challenge_id := str(challenge.get("id", ""))
        var correct := int(challenge.get("correct", -1))
        var choices: Array = challenge.get("choices", [])
        assert(view.supports_challenge(challenge), "renderer must support " + challenge_id)
        assert(correct >= 0 and correct < 4, challenge_id + ": correct index out of range")
        assert(choices.size() == 4, challenge_id + ": every challenge must expose four answer choices")
        assert(choices[correct] != null and str(choices[correct]).strip_edges() != "", challenge_id + ": correct answer must be non-empty")
        var normalized: Array[String] = []
        for choice in choices:
            normalized.append(str(choice).strip_edges())
        assert(normalized[0] != normalized[1] and normalized[0] != normalized[2] and normalized[0] != normalized[3], challenge_id + ": duplicate choice")
        assert(normalized[1] != normalized[2] and normalized[1] != normalized[3], challenge_id + ": duplicate choice")
        assert(normalized[2] != normalized[3], challenge_id + ": duplicate choice")

    var see := {"id":"see_change", "kind_key":"KIND_SEE", "correct":0}
    view.show_challenge(see)
    await process_frame
    _assert_ready(view, "see_change", true)
    assert(view.correct_index == 0)

    var see_color := {"id":"see_color_change", "kind_key":"KIND_SEE", "correct":0}
    view.show_challenge(see_color)
    await process_frame
    _assert_ready(view, "see_color_change", true)

    var remember := {"id":"sequence", "kind_key":"KIND_REMEMBER", "correct":0}
    view.show_challenge(remember)
    assert(not view.input_ready)
    view.show_challenge(see)
    await _wait(0.05)
    _assert_ready(view, "see_change", true)
    assert(view.phase_token == 4)

    var remember_colors := {"id":"remember_colors", "kind_key":"KIND_REMEMBER", "correct":0}
    view.show_challenge(remember_colors)
    assert(not view.input_ready)
    await _wait(1.20)
    _assert_ready(view, "remember_colors", true)

    var react := {"id":"color_timer", "kind_key":"KIND_REACT", "correct":2}
    view.show_challenge(react)
    await _wait(1.00)
    _assert_ready(view, "color_timer", true)
    assert(view._react_target() == "GREEN")
    await _wait(1.50)
    assert(not view.input_ready)

    var react_late := {"id":"react_late", "kind_key":"KIND_REACT", "correct":1}
    view.show_challenge(react_late)
    await _wait(0.80)
    _assert_ready(view, "react_late", true)
    assert(view._react_target() == "LATE")

    var switch := {"id":"rule_switch", "kind_key":"KIND_SWITCH", "correct":1}
    view.show_challenge(switch)
    assert(not view.input_ready)
    await _wait(1.25)
    _assert_ready(view, "rule_switch", true)
    view.challenge_id = "switch_direction_two"
    assert(view._switch_choices_preview() == "UP   RIGHT   DOWN   LEFT")
    assert(view._switch_new() == "SWITCH DIRECTION")

    var trick := {"id":"word_color", "kind_key":"KIND_TRICK", "correct":0}
    view.show_challenge(trick)
    await process_frame
    _assert_ready(view, "word_color", true)

    var trick_smallest := {"id":"trick_smallest", "kind_key":"KIND_TRICK", "correct":0}
    view.show_challenge(trick_smallest)
    await process_frame
    _assert_ready(view, "trick_smallest", true)

    var mix := {"id":"mixed", "kind_key":"KIND_MIX", "correct":2}
    view.show_challenge(mix)
    assert(not view.input_ready)
    await _wait(1.45)
    _assert_ready(view, "mixed", true)
    print("RULEBREAK ChallengeView timing/state/content tests: PASS — 100-level renderer + semantic answer + specialized visual contracts")
    quit(0)
