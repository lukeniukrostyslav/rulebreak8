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

func _init() -> void:
    var manager := ChallengeManagerScript.new()
    var view := ChallengeViewScript.new()
    root.add_child(view)
    await process_frame

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
    for id in trick_ids:
        view.show_challenge({"id":id, "kind_key":"KIND_TRICK", "correct":0})
        await process_frame
        assert(view.input_ready, "%s did not become answerable" % id)
        assert(view.visual_root != null, "%s produced no renderer root" % id)
        assert(not _visible_text(view).is_empty(), "%s produced empty renderer" % id)

    var mix_ids := ["mix_memory_switch", "mix_see_react", "mix_trick_react", "mix_switch_memory", "mix_full"]
    var expected_markers := ["REMEMBER_CHOOSE", "MIX_REACT", "MIX_REACT", "REMEMBER_CHOOSE", "MIX_REACT"]
    for i in mix_ids.size():
        view.show_challenge({"id":mix_ids[i], "kind_key":"KIND_MIX", "correct":2})
        await _wait(2.10)
        assert(view.input_ready, "%s did not reach final input" % mix_ids[i])
        assert(_visible_text(view).contains(expected_markers[i]), "%s final phase mismatch" % mix_ids[i])

    view.show_challenge({"id":"mixed", "kind_key":"KIND_MIX", "correct":2})
    await process_frame
    assert(view.input_ready)
    assert(view.visual_root != null)

    assert(manager.challenges.size() == 100)
    print("RULEBREAK family behavior contract: PASS — SWITCH/TRICK concrete coverage and all MIX composite flows")
    quit(0)
