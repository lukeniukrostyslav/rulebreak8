extends SceneTree

const ChallengeManagerScript = preload("res://scripts/core/challenge_manager.gd")

func _init() -> void:
    var manager := ChallengeManagerScript.new()
    var checked := 0

    for challenge in manager.challenges:
        var choices: Array = challenge.get("choices", [])
        var correct := int(challenge.get("correct", -1))
        assert(choices.size() == 4)
        assert(correct >= 0 and correct < choices.size())
        assert(manager._choice_matches(challenge, correct))
        for index in choices.size():
            if index != correct:
                assert(not manager._choice_matches(challenge, index))
        checked += 1

    print("RULEBREAK catalog behavior: PASS — %d levels have exactly one accepted choice" % checked)
    quit(0)
