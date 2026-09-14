extends SceneTree

const ChallengeManagerScript = preload("res://scripts/core/challenge_manager.gd")
const ChallengeViewScript = preload("res://scripts/core/challenge_view_v2.gd")

func _init() -> void:
    var manager := ChallengeManagerScript.new()
    var view := ChallengeViewScript.new()
    assert(manager.challenges.size() == 100)

    var seen_ids := {}
    var seen_families := {}
    var family_counts := {}
    for challenge in manager.challenges:
        var id := str(challenge.get("id", ""))
        var kind := str(challenge.get("kind_key", ""))
        var choices: Array = challenge.get("choices", [])
        var correct := int(challenge.get("correct", -1))
        assert(not id.is_empty())
        assert(not seen_ids.has(id))
        seen_ids[id] = true
        assert(not kind.is_empty())
        assert(view.supports_challenge(challenge))
        seen_families[kind] = true
        family_counts[kind] = int(family_counts.get(kind, 0)) + 1
        assert(choices.size() == 4)
        assert(correct >= 0 and correct < choices.size())
        var unique_choices := {}
        for choice in choices:
            var key := str(choice)
            assert(not key.is_empty())
            assert(not unique_choices.has(key))
            unique_choices[key] = true

    assert(seen_families.has("KIND_SEE"))
    assert(seen_families.has("KIND_REMEMBER"))
    assert(seen_families.has("KIND_REACT"))
    assert(seen_families.has("KIND_SWITCH"))
    assert(seen_families.has("KIND_TRICK"))
    assert(seen_families.has("KIND_MIX"))
    assert(int(family_counts["KIND_SEE"]) == 18)
    assert(int(family_counts["KIND_REMEMBER"]) == 20)
    assert(int(family_counts["KIND_REACT"]) == 18)
    assert(int(family_counts["KIND_SWITCH"]) == 19)
    assert(int(family_counts["KIND_TRICK"]) == 19)
    assert(int(family_counts["KIND_MIX"]) == 6)

    manager.reset()
    assert(manager.index == 0)
    assert(manager.check(0))
    assert(not manager.check(1))
    assert(not manager.check(-1))
    assert(not manager.check(4))
    var first_id := str(manager.current().get("id"))
    for _i in manager.challenges.size(): manager.next()
    assert(str(manager.current().get("id")) == first_id)
    assert(manager.index == 0)
    manager.index = 99
    assert(str(manager.current().get("id")) == "mix_full")
    manager.index = 1000
    assert(str(manager.current().get("id")) == "mix_full")
    assert(manager.index == 99)
    manager.index = -50
    assert(str(manager.current().get("id")) == first_id)
    assert(manager.index == 0)
    manager.next()
    assert(manager.index == 1)
    assert(str(manager.current().get("id")) == "remember_positions")
    manager.previous()
    assert(manager.index == 0)
    assert(str(manager.current().get("id")) == first_id)
    manager.previous()
    assert(manager.index == 99)
    assert(str(manager.current().get("id")) == "mix_full")
    manager.reset()
    assert(manager.index == 0)
    print("RULEBREAK ChallengeManager tests: PASS — 100 levels + unique choices + index invariants + next/previous/reset + view contract")
    quit(0)
