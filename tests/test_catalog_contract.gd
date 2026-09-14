extends SceneTree

const ChallengeManagerScript = preload("res://scripts/core/challenge_manager.gd")

const EXPECTED_COUNTS := {
    "KIND_SEE": 18,
    "KIND_REMEMBER": 20,
    "KIND_REACT": 18,
    "KIND_SWITCH": 19,
    "KIND_TRICK": 19,
    "KIND_MIX": 6,
}

func _fail(message: String) -> void:
    push_error("RULEBREAK catalog contract: " + message)
    quit(1)

func _init() -> void:
    var manager = ChallengeManagerScript.new()
    var challenges: Array = manager.challenges

    if challenges.size() != 100:
        _fail("expected exactly 100 challenges, got %d" % challenges.size())
        return

    var ids := {}
    var counts := {}

    for index in challenges.size():
        var challenge: Dictionary = challenges[index]
        var id := str(challenge.get("id", "")).strip_edges()
        var kind := str(challenge.get("kind_key", "")).strip_edges()
        var rule_key := str(challenge.get("rule_key", "")).strip_edges()
        var description := str(challenge.get("description", "")).strip_edges()
        var choices: Array = challenge.get("choices", [])
        var correct := int(challenge.get("correct", -1))

        if id.is_empty():
            _fail("challenge %d has an empty id" % index)
            return
        if ids.has(id):
            _fail("duplicate challenge id: %s" % id)
            return
        ids[id] = true

        if not EXPECTED_COUNTS.has(kind):
            _fail("challenge %s has unknown family %s" % [id, kind])
            return
        counts[kind] = int(counts.get(kind, 0)) + 1

        if rule_key.is_empty() and description.is_empty():
            _fail("challenge %s has neither rule_key nor description" % id)
            return

        if choices.size() != 4:
            _fail("challenge %s must expose exactly 4 choices, got %d" % [id, choices.size()])
            return

        var seen_choices := {}
        for choice_index in choices.size():
            var choice := str(choices[choice_index]).strip_edges()
            if choice.is_empty():
                _fail("challenge %s has an empty choice at index %d" % [id, choice_index])
                return
            if seen_choices.has(choice):
                _fail("challenge %s repeats choice %s" % [id, choice])
                return
            seen_choices[choice] = true

        if correct < 0 or correct >= choices.size():
            _fail("challenge %s has invalid correct index %d" % [id, correct])
            return

    for kind in EXPECTED_COUNTS:
        var expected: int = EXPECTED_COUNTS[kind]
        var actual: int = int(counts.get(kind, 0))
        if actual != expected:
            _fail("family %s expected %d entries, got %d" % [kind, expected, actual])
            return

    print("RULEBREAK catalog contract: PASS — 100 unique entries, exact family distribution, four unique non-empty choices, valid answers")
    quit(0)
