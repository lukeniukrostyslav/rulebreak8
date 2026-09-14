extends SceneTree

const GameScript = preload("res://scripts/game.gd")
const LocalizationScript = preload("res://scripts/core/localization.gd")

func _init() -> void:
    var localization = LocalizationScript.new()
    root.add_child(localization)
    assert(localization.load_translations())

    # Exercise the pure rule-rendering helper without entering the gameplay
    # scene lifecycle. This keeps the contract test independent from the
    # Localization autoload and from runtime UI construction.
    var game = GameScript.new()

    TranslationServer.set_locale("es")

    var base := {
        "id": "see_change",
        "rule_key": "RULE_SEE_CHANGE",
        "description": "unused base fallback",
    }
    assert(game._localized_rule_text(base) == "ENCUENTRA LA FORMA QUE CAMBIÓ")

    var extended := {
        "id": "see_shape_shift",
        "rule_key": "RULE_SEE_SHAPE_SHIFT",
        "description": "Find the shape that changed direction.",
    }
    assert(game._localized_rule_text(extended) == "Find the shape that changed direction.")

    # The final defensive branch must still produce a readable rule when a
    # challenge has neither a translated key nor a description.
    TranslationServer.set_locale("en")
    var switch_fallback := {
        "id": "rule_switch",
        "rule_key": "RULE_SWITCH_MISSING_FOR_TEST",
        "description": "",
    }
    assert(game._localized_rule_text(switch_fallback) == "Watch for the rule change.")

    assert(game._localized_rule_text(extended) == "Find the shape that changed direction.")

    print("RULEBREAK game rule fallback tests: PASS — translated base rules, English extended fallback and defensive rule-switch fallback")
    quit(0)
