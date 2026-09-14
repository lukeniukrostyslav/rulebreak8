class_name Progression
extends RefCounted

const SAVE_PATH := "user://rulebreak_save.json"
const TEMP_SAVE_PATH := "user://rulebreak_save.json.tmp"
const BACKUP_SAVE_PATH := "user://rulebreak_save.json.bak"

var streak := 0
var best_streak := 0
var total_correct := 0
var total_wrong := 0
var current_level := 0
var save_version := 1

func load_state() -> void:
    if not FileAccess.file_exists(SAVE_PATH):
        _try_restore_backup()
    if not FileAccess.file_exists(SAVE_PATH):
        return

    var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
    if file == null:
        _try_restore_backup()
        file = FileAccess.open(SAVE_PATH, FileAccess.READ)
    if file == null:
        return

    var parsed = JSON.parse_string(file.get_as_text())
    if parsed is Dictionary:
        streak = max(0, int(parsed.get("streak", 0)))
        best_streak = max(0, int(parsed.get("best_streak", 0)))
        total_correct = max(0, int(parsed.get("total_correct", 0)))
        total_wrong = max(0, int(parsed.get("total_wrong", 0)))
        current_level = clampi(int(parsed.get("current_level", 0)), 0, 99)

        # Keep the derived invariant valid even if an older/corrupt save
        # contains a best streak lower than the current streak.
        best_streak = max(best_streak, streak)
    elif FileAccess.file_exists(BACKUP_SAVE_PATH):
        # A truncated primary file must never silently erase valid progress.
        _restore_backup()
        load_state()

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

    # Keep the previous known-good save until the new file has been fully
    # written. This protects progress from interrupted/truncated writes.
    if FileAccess.file_exists(BACKUP_SAVE_PATH):
        DirAccess.remove_absolute(backup_abs)
    if FileAccess.file_exists(SAVE_PATH):
        if DirAccess.rename_absolute(save_abs, backup_abs) != OK:
            # If the backup cannot be created, keep the existing save rather
            # than replacing it with an unverified file.
            DirAccess.remove_absolute(temp_abs)
            return

    if DirAccess.rename_absolute(temp_abs, save_abs) != OK:
        if FileAccess.file_exists(BACKUP_SAVE_PATH):
            DirAccess.rename_absolute(backup_abs, save_abs)
        return

    if FileAccess.file_exists(BACKUP_SAVE_PATH):
        DirAccess.remove_absolute(backup_abs)

func _try_restore_backup() -> void:
    if FileAccess.file_exists(BACKUP_SAVE_PATH):
        _restore_backup()

func _restore_backup() -> void:
    var save_abs := ProjectSettings.globalize_path(SAVE_PATH)
    var backup_abs := ProjectSettings.globalize_path(BACKUP_SAVE_PATH)
    if FileAccess.file_exists(SAVE_PATH):
        DirAccess.remove_absolute(save_abs)
    DirAccess.rename_absolute(backup_abs, save_abs)
