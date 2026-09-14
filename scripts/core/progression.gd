class_name Progression
extends RefCounted

const SAVE_PATH := "user://rulebreak_save.json"
const TEMP_SAVE_PATH := "user://rulebreak_save.json.tmp"
const BACKUP_SAVE_PATH := "user://rulebreak_save.json.bak"
const BACKUP_TEMP_SAVE_PATH := "user://rulebreak_save.json.bak.tmp"

var streak := 0
var best_streak := 0
var total_correct := 0
var total_wrong := 0
var current_level := 0
var save_version := 1

func load_state() -> void:
    var primary := _read_valid_payload(SAVE_PATH)
    if primary != null:
        _apply_payload(primary)
        return

    var backup := _read_valid_payload(BACKUP_SAVE_PATH)
    if backup != null:
        _restore_backup()
        _apply_payload(backup)

func _read_valid_payload(path: String):
    if not FileAccess.file_exists(path):
        return null
    var file := FileAccess.open(path, FileAccess.READ)
    if file == null:
        return null
    var parsed = JSON.parse_string(file.get_as_text())
    if parsed is Dictionary and _is_valid_payload(parsed):
        return parsed
    return null

func _apply_payload(parsed: Dictionary) -> void:
    streak = max(0, int(parsed.get("streak", 0)))
    best_streak = max(0, int(parsed.get("best_streak", 0)))
    total_correct = max(0, int(parsed.get("total_correct", 0)))
    total_wrong = max(0, int(parsed.get("total_wrong", 0)))
    current_level = clampi(int(parsed.get("current_level", 0)), 0, 99)
    best_streak = max(best_streak, streak)

func _is_valid_payload(parsed: Dictionary) -> bool:
    var required_keys := [
        "version",
        "streak",
        "best_streak",
        "total_correct",
        "total_wrong",
        "current_level"
    ]
    for key in required_keys:
        if not parsed.has(key):
            return false

    if typeof(parsed.get("version")) != TYPE_INT:
        return false
    if int(parsed.get("version", -1)) != save_version:
        return false

    for key in ["streak", "best_streak", "total_correct", "total_wrong", "current_level"]:
        if typeof(parsed.get(key)) != TYPE_INT:
            return false
    return true

func record(correct: bool) -> void:
    if correct:
        streak += 1
        total_correct += 1
        best_streak = max(best_streak, streak)
    else:
        streak = 0
        total_wrong += 1
    save_state()

func set_current_level(level: int) -> void:
    current_level = clampi(level, 0, 99)
    save_state()

func save_state() -> void:
    var payload := JSON.stringify({
        "version": save_version,
        "streak": streak,
        "best_streak": best_streak,
        "total_correct": total_correct,
        "total_wrong": total_wrong,
        "current_level": current_level
    })

    var temp := FileAccess.open(TEMP_SAVE_PATH, FileAccess.WRITE)
    if temp == null:
        return
    temp.store_string(payload)
    temp.flush()
    temp = null

    var save_abs := ProjectSettings.globalize_path(SAVE_PATH)
    var temp_abs := ProjectSettings.globalize_path(TEMP_SAVE_PATH)
    var backup_abs := ProjectSettings.globalize_path(BACKUP_SAVE_PATH)
    var backup_temp_abs := ProjectSettings.globalize_path(BACKUP_TEMP_SAVE_PATH)

    # Keep the last known-good save as a recovery point. Rotate the current
    # save only after the replacement file is fully written.
    if FileAccess.file_exists(backup_temp_abs):
        DirAccess.remove_absolute(backup_temp_abs)

    var had_save := FileAccess.file_exists(SAVE_PATH)
    if had_save:
        if DirAccess.rename_absolute(save_abs, backup_temp_abs) != OK:
            DirAccess.remove_absolute(temp_abs)
            return

    if DirAccess.rename_absolute(temp_abs, save_abs) != OK:
        if had_save and FileAccess.file_exists(BACKUP_TEMP_SAVE_PATH):
            DirAccess.rename_absolute(backup_temp_abs, save_abs)
        return

    if had_save:
        # The old primary is now the newest recovery backup. Remove the older
        # backup only after the new primary is safely in place.
        if FileAccess.file_exists(BACKUP_SAVE_PATH):
            DirAccess.remove_absolute(backup_abs)
        if DirAccess.rename_absolute(backup_temp_abs, backup_abs) != OK:
            # The primary save is valid even if backup rotation fails. Do not
            # roll it back merely because the secondary recovery copy failed.
            if FileAccess.file_exists(BACKUP_TEMP_SAVE_PATH):
                DirAccess.remove_absolute(backup_temp_abs)

func _try_restore_backup() -> void:
    if _read_valid_payload(BACKUP_SAVE_PATH) != null:
        _restore_backup()

func _restore_backup() -> void:
    var save_abs := ProjectSettings.globalize_path(SAVE_PATH)
    var backup_abs := ProjectSettings.globalize_path(BACKUP_SAVE_PATH)
    if not _read_valid_payload(BACKUP_SAVE_PATH):
        return
    if FileAccess.file_exists(SAVE_PATH):
        DirAccess.remove_absolute(save_abs)
    DirAccess.rename_absolute(backup_abs, save_abs)
