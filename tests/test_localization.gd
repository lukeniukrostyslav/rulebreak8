extends SceneTree

const EXPECTED_LOCALES := [
    "en", "es", "pt_BR", "fr", "de", "it", "ru", "uk", "pl", "tr", "nl",
    "ar", "he", "hi", "id", "vi", "th", "ja", "ko", "zh", "zh_TW"
]

func _init() -> void:
    var locale_dir := DirAccess.open("res://locale")
    if locale_dir == null:
        push_error("RULEBREAK localization test: locale directory missing")
        quit(1)
        return

    var loaded_locales: Dictionary = {}
    var translation_files := 0

    for file_name in locale_dir.get_files():
        if not file_name.ends_with(".translation"):
            continue
        translation_files += 1
        var resource := ResourceLoader.load("res://locale/" + file_name)
        if not resource is Translation:
            push_error("RULEBREAK localization test: invalid translation resource: %s" % file_name)
            quit(1)
            return
        var translation := resource as Translation
        var locale := translation.get_locale()
        if locale.is_empty():
            push_error("RULEBREAK localization test: empty locale in %s" % file_name)
            quit(1)
            return
        loaded_locales[locale] = true
        TranslationServer.add_translation(translation)

    if translation_files < EXPECTED_LOCALES.size() * 4:
        push_error("RULEBREAK localization test: expected at least %d generated translation resources, found %d" % [EXPECTED_LOCALES.size() * 4, translation_files])
        quit(1)
        return

    for locale in EXPECTED_LOCALES:
        if not loaded_locales.has(locale):
            push_error("RULEBREAK localization test: missing locale %s" % locale)
            quit(1)
            return

    TranslationServer.set_locale("ru")
    if TranslationServer.translate("GAME_TITLE") != "RULEBREAK":
        push_error("RULEBREAK localization test: GAME_TITLE translation failed")
        quit(1)
        return

    TranslationServer.set_locale("en")
    if TranslationServer.translate("GAME_TITLE") != "RULEBREAK":
        push_error("RULEBREAK localization test: English fallback failed")
        quit(1)
        return

    print("RULEBREAK localization tests: PASS (%d translation resources, %d locales)" % [translation_files, loaded_locales.size()])
    quit(0)
