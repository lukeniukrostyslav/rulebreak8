extends Node

const LOCALES := [
    "en", "es", "pt_BR", "fr", "de", "it", "ru", "uk", "pl", "tr", "nl",
    "ar", "he", "hi", "id", "vi", "th", "ja", "ko", "zh", "zh_TW"
]

const SOURCES := [
    "challenges",
    "extra_a",
    "extra_b",
    "extra_c",
    "ui_translations"
]

var loaded_locales: Dictionary = {}
var loaded := false

func load_translations() -> bool:
    if loaded:
        return true

    for locale in LOCALES:
        var message_count := 0

        for source in SOURCES:
            var translation := _load_imported_translation(source, locale)
            if translation == null:
                translation = _build_translation_from_csv(source, locale)
            if translation == null:
                push_error("RULEBREAK localization: failed to load %s for locale %s" % [source, locale])
                return false
            TranslationServer.add_translation(translation)
            message_count += translation.get_message_list().size()

        if message_count == 0:
            push_error("RULEBREAK localization: locale %s has no messages" % locale)
            return false
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

func _load_imported_translation(source: String, locale: String) -> Translation:
    var path := "res://locale/%s.%s.translation" % [source, locale]
    if not ResourceLoader.exists(path):
        return null
    return load(path) as Translation

func _build_translation_from_csv(source: String, locale: String) -> Translation:
    var path := "res://locale/%s.csv" % source
    var table := _read_csv(path)
    if table.is_empty():
        return null

    var header: Array = table[0]
    var locale_index := header.find(locale)
    if locale_index < 0:
        return null

    var translation := Translation.new()
    translation.set_locale(locale)
    for row_index in range(1, table.size()):
        var row: Array = table[row_index]
        if row.size() <= locale_index or row.is_empty():
            continue
        var key := str(row[0]).strip_edges()
        if key.is_empty():
            continue
        translation.add_message(key, str(row[locale_index]))
    return translation

func _read_csv(path: String) -> Array:
    if not FileAccess.file_exists(path):
        return []
    var file := FileAccess.open(path, FileAccess.READ)
    if file == null:
        return []
    return _parse_csv(file.get_as_text())

func _parse_csv(text: String) -> Array:
    var rows: Array = []
    var row: Array = []
    var field := ""
    var quoted := false
    var i := 0

    while i < text.length():
        var ch := text[i]
        if quoted:
            if ch == '"':
                if i + 1 < text.length() and text[i + 1] == '"':
                    field += '"'
                    i += 1
                else:
                    quoted = false
            else:
                field += ch
        else:
            match ch:
                '"':
                    quoted = true
                ',':
                    row.append(field)
                    field = ""
                '\n':
                    row.append(field.trim_suffix("\r"))
                    rows.append(row)
                    row = []
                    field = ""
                '\r':
                    pass
                _:
                    field += ch
        i += 1

    if not row.is_empty() or not field.is_empty():
        row.append(field)
        rows.append(row)
    return rows

func _ready() -> void:
    if not load_translations():
        return
    TranslationServer.set_locale(select_system_locale())
