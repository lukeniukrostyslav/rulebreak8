class_name Progression
extends RefCounted

const SAVE_PATH := "user://rulebreak_save.json"

var streak := 0
var best_streak := 0
var total_correct := 0
var total_wrong := 0

func load_state() -> void:
    if not FileAccess.file_exists(SAVE_PATH):
        return

    var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
    if file == null:
        return

    var parsed = JSON.parse_string(file.get_as_text())
    if parsed is Dictionary:
        streak = max(0, int(parsed.get("streak", 0)))
        best_streak = max(0, int(parsed.get("best_streak", 0)))
        total_correct = max(0, int(parsed.get("total_correct", 0)))
        total_wrong = max(0, int(parsed.get("total_wrong", 0)))

        # Keep the derived invariant valid even if an older/corrupt save
        # contains a best streak lower than the current streak.
        best_streak = max(best_streak, streak)

func record(correct: bool) -> void:
    if correct:
        streak += 1
        total_correct += 1
        best_streak = max(best_streak, streak)
    else:
        streak = 0
        total_wrong += 1
    save_state()

func save_state() -> void:
    var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
    if file == null:
        return

    file.store_string(JSON.stringify({
        "streak": streak,
        "best_streak": best_streak,
        "total_correct": total_correct,
        "total_wrong": total_wrong
    }))
