extends SceneTree

const GameScript = preload("res://scripts/game.gd")
const LocalizationScript = preload("res://scripts/core/localization.gd")

func _init() -> void:
    var localization = LocalizationScript.new()
    root.add_child(localization)
    assert(localization.load_translations())

    var game = GameScript.new()
    root.add_child(game)

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

    TranslationServer.set_locale("en")
    assert(game._localized_rule_text(extended) == "Find the shape that changed direction.")

    print("RULEBREAK game rule fallback tests: PASS — translated base rules + English extended fallback")
    quit(0)
