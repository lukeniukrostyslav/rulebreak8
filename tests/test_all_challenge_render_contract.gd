extends SceneTree

const ChallengeManagerScript = preload("res://scripts/core/challenge_manager.gd")
const ChallengeViewScript = preload("res://scripts/core/challenge_view_v2.gd")

func _wait(seconds: float) -> void:
    await create_timer(seconds).timeout

func _visible_text(view) -> String:
    var parts: Array[String] = []
    if view.visual_root:
        for node in view.visual_root.get_children():
            if node is Label:
                parts.append(str(node.text))
            elif node is PanelContainer and node.get_child_count() > 0 and node.get_child(0) is Label:
                parts.append(str(node.get_child(0).text))
    return " | ".join(parts)

func _init() -> void:
    var manager := ChallengeManagerScript.new()
    var view := ChallengeViewScript.new()
    root.add_child(view)
    await process_frame

    assert(manager.challenges.size() == 100, "catalog must contain 100 challenges")
    var seen := {}
    var family_counts := {}

    for index in manager.challenges.size():
        var challenge: Dictionary = manager.challenges[index]
        var id := str(challenge.get("id", ""))
        var family := str(challenge.get("kind_key", ""))
        var choices: Array = challenge.get("choices", [])
        assert(not id.is_empty(), "challenge %d has empty id" % index)
        assert(not seen.has(id), "duplicate challenge id: %s" % id)
        seen[id] = true
        assert(choices.size() == 4, "%s must have four choices" % id)
        var unique_choices := {}
        for choice in choices:
            var key := str(choice)
            assert(not key.is_empty(), "%s has an empty choice" % id)
            assert(not unique_choices.has(key), "%s contains duplicate answer choices: %s" % [id, key])
            unique_choices[key] = true
        var correct := int(challenge.get("correct", -1))
        assert(correct >= 0 and correct < 4, "%s has invalid correct index" % id)
        family_counts[family] = int(family_counts.get(family, 0)) + 1

        view.show_challenge(challenge)
        await process_frame
        if family == "KIND_MIX":
            await _wait(2.25)
        else:
            await _wait(0.05)

        assert(view.visual_root != null, "challenge %d (%s) has no visual root" % [index, id])
        assert(not _visible_text(view).is_empty(), "challenge %d (%s) rendered no visible text" % [index, id])
        assert(view.input_ready, "challenge %d (%s) never became answerable" % [index, id])

    assert(int(family_counts.get("KIND_SEE", 0)) == 18, "SEE distribution drifted")
    assert(int(family_counts.get("KIND_REMEMBER", 0)) == 20, "REMEMBER distribution drifted")
    assert(int(family_counts.get("KIND_REACT", 0)) == 18, "REACT distribution drifted")
    assert(int(family_counts.get("KIND_SWITCH", 0)) == 19, "SWITCH distribution drifted")
    assert(int(family_counts.get("KIND_TRICK", 0)) == 19, "TRICK distribution drifted")
    assert(int(family_counts.get("KIND_MIX", 0)) == 6, "MIX distribution drifted")

    print("RULEBREAK all-challenge render contract: PASS — 100 unique entries, unique four-choice sets, valid answers, exact family distribution, all renderable")
    quit(0)
