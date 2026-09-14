extends SceneTree

const ChallengeManagerScript = preload("res://scripts/core/challenge_manager.gd")

func _init() -> void:
    var manager := ChallengeManagerScript.new()
    var checked := 0

    for index in manager.challenges.size():
        manager.index = index
        var challenge: Dictionary = manager.current()
        var choices: Array = challenge.get("choices", [])
        var correct := int(challenge.get("correct", -1))
        assert(choices.size() == 4)
        assert(correct >= 0 and correct < choices.size())
        assert(manager.check(correct))
        for choice_index in choices.size():
            if choice_index != correct:
                assert(not manager.check(choice_index))
        checked += 1

    print("RULEBREAK catalog behavior: PASS — %d levels have exactly one accepted choice" % checked)
    quit(0)
