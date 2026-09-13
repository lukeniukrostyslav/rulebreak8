extends SceneTree

func _init() -> void:
    var manager := ChallengeManager.new()
    assert(manager.challenges.size() == 20)

    var seen_ids := {}
    var seen_families := {}
    for challenge in manager.challenges:
        var id := str(challenge.get("id", ""))
        var kind := str(challenge.get("kind_key", ""))
        var choices: Array = challenge.get("choices", [])
        var correct := int(challenge.get("correct", -1))

        assert(not id.is_empty())
        assert(not seen_ids.has(id))
        seen_ids[id] = true
        assert(not kind.is_empty())
        seen_families[kind] = true
        assert(choices.size() == 4)
        assert(correct >= 0 and correct < choices.size())

        assert(manager.current().get("id") == id or manager.index == 0)

    assert(seen_families.has("KIND_SEE"))
    assert(seen_families.has("KIND_REMEMBER"))
    assert(seen_families.has("KIND_REACT"))
    assert(seen_families.has("KIND_SWITCH"))
    assert(seen_families.has("KIND_TRICK"))
    assert(seen_families.has("KIND_MIX"))

    manager.reset()
    assert(manager.index == 0)
    assert(manager.check(0))
    assert(not manager.check(1))

    var first_id := str(manager.current().get("id"))
    for _i in manager.challenges.size():
        manager.next()
    assert(str(manager.current().get("id")) == first_id)
    assert(manager.index == 0)

    print("RULEBREAK ChallengeManager tests: PASS")
    quit(0)
