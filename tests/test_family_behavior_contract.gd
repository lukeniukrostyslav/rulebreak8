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

    # Every extended TRICK level must have four concrete choices, a valid answer,
    # and a description that is consistent with its intended trick mechanic.
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
    for i in trick_ids.size():
        var challenge := _find(manager, trick_ids[i])
        assert(not challenge.is_empty(), "%s missing from catalog" % trick_ids[i])
        var choices: Array = challenge.get("choices", [])
        var correct := int(challenge.get("correct", -1))
        assert(choices.size() == 4, "%s must expose exactly four choices" % trick_ids[i])
        assert(correct >= 0 and correct < choices.size(), "%s has invalid correct index" % trick_ids[i])
        assert(str(challenge.get("description", "")).to_lower().contains(trick_keywords[i]), "%s description no longer documents its trick" % trick_ids[i])
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
    print("RULEBREAK family behavior contract: PASS — SWITCH/TRICK catalog semantics and all MIX composite flows")
    quit(0)
