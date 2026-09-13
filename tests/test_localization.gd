extends SceneTree

const EXPECTED_LOCALES := [
    "en", "es", "pt_BR", "fr", "de", "it", "ru", "uk", "pl", "tr", "nl",
    "ar", "he", "hi", "id", "vi", "th", "ja", "ko", "zh", "zh_TW"
]
const LocalizationScript = preload("res://scripts/core/localization.gd")

func _init() -> void:
    var localization = LocalizationScript.new()
    root.add_child(localization)
    await process_frame

    if not localization.load_translations():
        push_error("RULEBREAK localization test: runtime CSV loader failed")
        quit(1)
        return

    for locale in EXPECTED_LOCALES:
        if not localization.loaded_locales.has(locale):
            push_error("RULEBREAK localization test: missing locale %s" % locale)
            quit(1)
            return
        if int(localization.loaded_locales[locale]) < 10:
            push_error("RULEBREAK localization test: too few messages for locale %s" % locale)
            quit(1)
            return

    TranslationServer.set_locale("ru")
    if TranslationServer.translate("GAME_TITLE") != "RULEBREAK":
        push_error("RULEBREAK localization test: Russian GAME_TITLE translation failed")
        quit(1)
        return
    if TranslationServer.translate("RULE_SEE_CHANGE") == "RULE_SEE_CHANGE":
        push_error("RULEBREAK localization test: Russian challenge translation missing")
        quit(1)
        return

    TranslationServer.set_locale("ja")
    if TranslationServer.translate("RULE_COLOR") == "RULE_COLOR":
        push_error("RULEBREAK localization test: Japanese challenge translation missing")
        quit(1)
        return

    TranslationServer.set_locale("en")
    if TranslationServer.translate("GAME_TITLE") != "RULEBREAK":
        push_error("RULEBREAK localization test: English fallback failed")
        quit(1)
        return

    print("RULEBREAK localization tests: PASS (%d locales, runtime CSV loading)" % EXPECTED_LOCALES.size())
    quit(0)
