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

func _load_catalog() -> Dictionary:
    var file := FileAccess.open("res://scripts/data/challenges.json", FileAccess.READ)
    if file == null:
        _fail("unable to open challenges.json")
        return {}
    var parsed: Variant = JSON.parse_string(file.get_as_text())
    if not parsed is Dictionary:
        _fail("challenges.json must contain a JSON object")
        return {}
    return parsed as Dictionary

func _init() -> void:
    var manager = ChallengeManagerScript.new()
    var challenges: Array = manager.challenges
    var catalog := _load_catalog()
    if catalog.is_empty():
        return

    if int(catalog.get("version", -1)) != 2:
        _fail("catalog version must be 2")
        return
    if int(catalog.get("total_levels", -1)) != 100:
        _fail("catalog total_levels must be 100")
        return
    if int(catalog.get("base_seed_levels", -1)) != 20:
        _fail("catalog base_seed_levels must be 20")
        return
    if int(catalog.get("generated_extension_levels", -1)) != 80:
        _fail("catalog generated_extension_levels must be 80")
        return

    var seed: Array = catalog.get("mvp_seed", [])
    if seed.size() != 20:
        _fail("catalog mvp_seed must contain 20 entries")
        return
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

        if index < seed.size():
            var seed_entry: Dictionary = seed[index]
            var seed_id := str(seed_entry.get("id", "")).strip_edges()
            var seed_family := str(seed_entry.get("family", "")).strip_edges()
            var expected_family := kind.trim_prefix("KIND_")
            if seed_id != id:
                _fail("seed catalog id mismatch at index %d: JSON=%s runtime=%s" % [index, seed_id, id])
                return
            if seed_family != expected_family:
                _fail("seed catalog family mismatch for %s: JSON=%s runtime=%s" % [id, seed_family, expected_family])
                return

    for kind in EXPECTED_COUNTS:
        var expected: int = EXPECTED_COUNTS[kind]
        var actual: int = int(counts.get(kind, 0))
        if actual != expected:
            _fail("family %s expected %d entries, got %d" % [kind, expected, actual])
            return

    print("RULEBREAK catalog contract: PASS — JSON/runtime seed alignment, 100 unique entries, exact family distribution, four unique non-empty choices, valid answers")
    quit(0)
