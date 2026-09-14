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

    for index in manager.challenges.size():
        var challenge: Dictionary = manager.challenges[index]
        view.show_challenge(challenge)
        await process_frame

        var family := str(challenge.get("kind_key", ""))
        if family == "KIND_MIX":
            await _wait(2.25)
        else:
            await _wait(0.05)

        assert(view.visual_root != null, "challenge %d (%s) has no visual root" % [index, challenge.get("id", "")])
        assert(not _visible_text(view).is_empty(), "challenge %d (%s) rendered no visible text" % [index, challenge.get("id", "")])
        assert(view.input_ready, "challenge %d (%s) never became answerable" % [index, challenge.get("id", "")])

    print("RULEBREAK all-challenge render contract: PASS — all 100 catalog entries rendered and became answerable")
    quit(0)
