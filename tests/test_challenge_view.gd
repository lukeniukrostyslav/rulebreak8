extends SceneTree

const ChallengeViewScript = preload("res://scripts/core/challenge_view_v2.gd")
const ChallengeManagerScript = preload("res://scripts/core/challenge_manager.gd")

func _wait(seconds: float) -> void:
    await create_timer(seconds).timeout

func _assert_ready(view, expected_id: String, expected_ready: bool) -> void:
    assert(view.challenge_id == expected_id)
    assert(view.input_ready == expected_ready)

func _visible_text(view) -> String:
    var parts: Array[String] = []
    if view.visual_root:
        for child in view.visual_root.get_children():
            if child is Label:
                parts.append(str(child.text))
            elif child is PanelContainer and child.get_child_count() > 0 and child.get_child(0) is Label:
                parts.append(str(child.get_child(0).text))
    return " | ".join(parts)

func _init() -> void:
    var view = ChallengeViewScript.new()
    root.add_child(view)
    await process_frame

    var manager = ChallengeManagerScript.new()
    assert(manager.challenges.size() == 100)
    for challenge in manager.challenges:
        assert(view.supports_challenge(challenge), "renderer must support " + str(challenge.get("id", "")))
        assert(int(challenge.get("correct", -1)) >= 0)
        assert(int(challenge.get("correct", -1)) < 4)

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

    # MIX is a real family, not a single generic renderer. Verify every
    # catalogued MIX id reaches an answerable final state with visible content.
    var mix_ids := ["mix_memory_switch", "mix_see_react", "mix_trick_react", "mix_switch_memory", "mix_full"]
    for id in mix_ids:
        var mix := {"id":id, "kind_key":"KIND_MIX", "correct":2}
        view.show_challenge(mix)
        assert(not view.input_ready)
        await _wait(2.50)
        _assert_ready(view, id, true)
        assert(not _visible_text(view).is_empty(), "%s produced empty final presentation" % id)

    print("RULEBREAK ChallengeView timing/state/content tests: PASS — 100-level renderer support contract and all MIX composite flows")
    quit(0)
