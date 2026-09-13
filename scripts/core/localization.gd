extends Node

const LOCALES := [
    "en", "es", "pt_BR", "fr", "de", "it", "ru", "uk", "pl", "tr", "nl",
    "ar", "he", "hi", "id", "vi", "th", "ja", "ko", "zh", "zh_TW"
]

const SOURCES := [
    "challenges",
    "extra_a",
    "extra_b",
    "ui_translations"
]

var loaded_locales: Dictionary = {}
var loaded := false

func load_translations() -> bool:
    if loaded:
        return true

    for locale in LOCALES:
        var message_count := 0
        var locale_translations: Array[Translation] = []

        for source in SOURCES:
            var path := "res://locale/%s.%s.translation" % [source, locale]
            var translation := load(path) as Translation
            if translation == null:
                push_error("RULEBREAK localization: failed to load imported translation %s" % path)
                return false
            locale_translations.append(translation)
            message_count += translation.get_message_list().size()

        if message_count == 0:
            push_error("RULEBREAK localization: locale %s has no messages" % locale)
            return false

        for translation in locale_translations:
            TranslationServer.add_translation(translation)
        loaded_locales[locale] = message_count

    loaded = true
    return true

func select_system_locale() -> String:
    var system_locale := OS.get_locale()
    for locale in LOCALES:
        if system_locale == locale or system_locale.begins_with(locale + "_"):
            return locale
    var language := system_locale.split("_")[0].split("-")[0]
    for locale in LOCALES:
        if locale == language:
            return locale
    return "en"

func _ready() -> void:
    if not load_translations():
        return
    TranslationServer.set_locale(select_system_locale())
