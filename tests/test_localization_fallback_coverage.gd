extends SceneTree

const ChallengeManagerScript = preload("res://scripts/core/challenge_manager.gd")
const LocalizationScript = preload("res://scripts/core/localization.gd")

func _init() -> void:
    var localization := LocalizationScript.new()
    assert(localization.load_translations())

    var manager := ChallengeManagerScript.new()
    var fallback_count := 0

    TranslationServer.set_locale("en")
    for challenge in manager.challenges:
        var rule_key := str(challenge.get("rule_key", "")).strip_edges()
        var description := str(challenge.get("description", "")).strip_edges()
        assert(not rule_key.is_empty())

        var translated := tr(rule_key)
        if translated == rule_key:
            assert(not description.is_empty())
            fallback_count += 1

    print("RULEBREAK localization fallback coverage: PASS — %d levels use non-empty English descriptions when rule keys are untranslated" % fallback_count)
    quit(0)
