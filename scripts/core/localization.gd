class_name Localization
extends Node

const LOCALES := [
    "en", "es", "pt_BR", "fr", "de", "it", "ru", "uk", "pl", "tr", "nl",
    "ar", "he", "hi", "id", "vi", "th", "ja", "ko", "zh", "zh_TW"
]

const SOURCES := [
    "res://locale/challenges.csv",
    "res://locale/extra_a.csv",
    "res://locale/extra_b.csv",
    "res://locale/ui_translations.csv"
]

var loaded_locales: Dictionary = {}
var loaded := false

func load_translations() -> bool:
    if loaded:
        return true

    var tables: Array = []
    for source in SOURCES:
        var table := _read_csv(source)
        if table.is_empty():
            push_error("RULEBREAK localization: failed to read %s" % source)
            return false
        tables.append(table)

    for locale in LOCALES:
        var translation := Translation.new()
        translation.set_locale(locale)
        var message_count := 0

        for table in tables:
            var header: Array = table[0]
            var locale_index := header.find(locale)
            if locale_index < 0:
                push_error("RULEBREAK localization: missing locale %s in CSV header" % locale)
                return false

            for row_index in range(1, table.size()):
                var row: Array = table[row_index]
                if row.size() <= locale_index or row.is_empty():
                    continue
                var key := str(row[0]).strip_edges()
                if key.is_empty():
                    continue
                translation.add_message(key, str(row[locale_index]))
                message_count += 1

        if message_count == 0:
            push_error("RULEBREAK localization: locale %s has no messages" % locale)
            return false
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
