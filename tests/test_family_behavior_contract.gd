extends SceneTree

const ChallengeManagerScript = preload("res://scripts/core/challenge_manager.gd")
const ChallengeViewScript = preload("res://scripts/core/challenge_view_v2.gd")

func _wait(seconds: float) -> void:
    await create_timer(seconds).timeout

func _visible_text(view) -> String:
    var parts: Array[String] = []
    if view.visual_root:
        for child in view.visual_root.get_children():
            if child is Label:
                parts.append(str(child.text))
            elif child is PanelContainer and child.get_child_count() > 0 and child.get_child(0) is Label:
                parts.append(str(child.get_child(0).text))
    return " | ".join(parts)

func _find(manager, challenge_id: String) -> Dictionary:
    for challenge in manager.challenges:
        if str(challenge.get("id", "")) == challenge_id:
            return challenge
    return {}

func _init() -> void:
    var manager := ChallengeManagerScript.new()
    var view := ChallengeViewScript.new()
    root.add_child(view)
    await process_frame

    var react_targets := {
        "react_circle": "●", "react_triangle": "▲", "react_star": "★",
        "react_red": "RED", "react_blue": "BLUE", "react_yellow": "YELLOW"
    }
    for id in react_targets:
        var challenge := _find(manager, id)
        assert(not challenge.is_empty(), "%s missing from catalog" % id)
        var choices: Array = challenge.get("choices", [])
        var correct := int(challenge.get("correct", -1))
        assert(choices.size() == 4, "%s must expose four choices" % id)
        assert(correct >= 0 and correct < choices.size(), "%s has invalid correct index" % id)
        assert(str(choices[correct]) == str(react_targets[id]), "%s correct choice does not match declared target" % id)

    var switch_ids := [
        "switch_color", "switch_direction", "switch_after_two", "switch_after_signal",
        "switch_reverse", "switch_number", "switch_shape", "switch_instruction",
        "switch_timing", "switch_action", "switch_second_rule", "switch_after_three",
        "switch_direction_two", "switch_target", "switch_final"
    ]
    for id in switch_ids:
        view.challenge_id = id
        var choices := view._switch_choices_preview()
        var changed := view._switch_new()
        if id != "switch_color":
            assert(choices != "BLUE   RED   GREEN   YELLOW", "%s still uses SWITCH generic choices" % id)
        assert(changed != tr("SWITCH_RULE"), "%s still uses SWITCH generic rule" % id)

    var trick_ids := [
        "trick_smallest", "trick_second", "trick_hidden", "trick_word", "trick_color",
        "trick_reverse", "trick_forbidden", "trick_slowest", "trick_not_largest",
        "trick_decoy", "trick_mislead", "trick_exception", "trick_wrong_label",
        "trick_obvious_two", "trick_contradiction"
    ]
    var trick_keywords := [
        "smallest", "obvious", "hidden", "word", "color", "opposite", "forbidden",
        "slowest", "largest", "decoy", "mislead", "exception", "label", "second", "latest"
    ]
    var expected_correct := {
        "trick_smallest": 0, "trick_second": 1, "trick_hidden": 2, "trick_word": 0,
        "trick_color": 1, "trick_reverse": 1, "trick_forbidden": 0, "trick_slowest": 2,
        "trick_not_largest": 0, "trick_decoy": 1, "trick_mislead": 2, "trick_exception": 2,
        "trick_wrong_label": 1, "trick_obvious_two": 2, "trick_contradiction": 1
    }
    var expected_choices := {
        "trick_hidden": ["OBVIOUS", "DECOY", "EXCEPTION", "NONE"],
        "trick_forbidden": ["FORBIDDEN", "SAFE", "WAIT", "NONE"],
        "trick_slowest": ["FASTEST", "MIDDLE", "SLOWEST", "NONE"],
        "trick_decoy": ["DECOY", "TARGET", "BOTH", "NONE"],
        "trick_mislead": ["FOLLOW", "IGNORE", "REVERSE", "WAIT"],
        "trick_exception": ["OBVIOUS", "DECOY", "EXCEPTION", "NONE"],
        "trick_wrong_label": ["LABEL", "RULE", "BOTH", "NEITHER"],
        "trick_contradiction": ["OLD", "LATEST", "BOTH", "NONE"]
    }
    for i in trick_ids.size():
        challenge := _find(manager, trick_ids[i])
        assert(not challenge.is_empty(), "%s missing from catalog" % trick_ids[i])
        var choices: Array = challenge.get("choices", [])
        var correct := int(challenge.get("correct", -1))
        assert(choices.size() == 4, "%s must expose exactly four choices" % trick_ids[i])
        assert(correct == int(expected_correct[trick_ids[i]]), "%s correct answer drifted" % trick_ids[i])
        assert(correct >= 0 and correct < choices.size(), "%s has invalid correct index" % trick_ids[i])
        assert(str(challenge.get("description", "")).to_lower().contains(trick_keywords[i]), "%s description no longer documents its trick" % trick_ids[i])
        if expected_choices.has(trick_ids[i]):
            assert(choices == expected_choices[trick_ids[i]], "%s choices no longer match its documented trick" % trick_ids[i])
        view.show_challenge(challenge)
        await process_frame
        assert(view.input_ready, "%s did not become answerable" % trick_ids[i])
        assert(view.visual_root != null, "%s produced no renderer root" % trick_ids[i])
        assert(not _visible_text(view).is_empty(), "%s produced empty renderer" % trick_ids[i])

    var mix_ids := ["mix_memory_switch", "mix_see_react", "mix_trick_react", "mix_switch_memory", "mix_full"]
    for id in mix_ids:
        view.show_challenge({"id":id, "kind_key":"KIND_MIX", "correct":2})
        await _wait(2.50)
        assert(view.input_ready, "%s did not reach final input" % id)
        assert(not _visible_text(view).is_empty(), "%s final presentation is empty" % id)

    view.show_challenge({"id":"mixed", "kind_key":"KIND_MIX", "correct":2})
    await process_frame
    assert(view.input_ready)
    assert(view.visual_root != null)

    assert(manager.challenges.size() == 100)
    print("RULEBREAK family behavior contract: PASS — REACT target alignment, SWITCH/TRICK semantics and all MIX composite flows")
    quit(0)
