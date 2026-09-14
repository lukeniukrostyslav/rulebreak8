extends SceneTree

const ProgressionScript = preload("res://scripts/core/progression.gd")

func _write_json(path: String, payload: Dictionary) -> void:
    var file := FileAccess.open(path, FileAccess.WRITE)
    assert(file != null)
    file.store_string(JSON.stringify(payload))
    file.flush()
    file = null

func _read_json(path: String) -> Dictionary:
    var file := FileAccess.open(path, FileAccess.READ)
    assert(file != null)
    var parsed: Variant = JSON.parse_string(file.get_as_text())
    assert(parsed is Dictionary)
    return parsed as Dictionary

func _cleanup_save_files() -> void:
    for path in [
        "user://rulebreak_save.json",
        "user://rulebreak_save.json.tmp",
        "user://rulebreak_save.json.bak",
        "user://rulebreak_save.json.bak.tmp",
        "user://rulebreak_save.json.bak.old.tmp"
    ]:
        if FileAccess.file_exists(path):
            DirAccess.remove_absolute(ProjectSettings.globalize_path(path))

func _init() -> void:
    _cleanup_save_files()
    var progression = ProgressionScript.new()

    assert(progression.streak == 0)
    assert(progression.best_streak == 0)
    assert(progression.total_correct == 0)
    assert(progression.total_wrong == 0)
    assert(progression.current_level == 0)

    progression.record(true)
    assert(progression.streak == 1)
    assert(progression.best_streak == 1)
    assert(progression.total_correct == 1)
    assert(progression.total_wrong == 0)
    assert(not FileAccess.file_exists("user://rulebreak_save.json.tmp"))
    assert(_read_json("user://rulebreak_save.json").get("current_level", -1) == 0)

    progression.record(true)
    assert(progression.streak == 2)
    assert(progression.best_streak == 2)
    assert(progression.total_correct == 2)
    assert(FileAccess.file_exists("user://rulebreak_save.json.bak"))
    var rotated_backup := _read_json("user://rulebreak_save.json.bak")
    assert(rotated_backup.get("streak", -1) == 1)
    assert(rotated_backup.get("total_correct", -1) == 1)

    progression.record(false)
    assert(progression.streak == 0)
    assert(progression.best_streak == 2)
    assert(progression.total_correct == 2)
    assert(progression.total_wrong == 1)
    var current_save := _read_json("user://rulebreak_save.json")
    assert(current_save.get("streak", -1) == 0)
    assert(current_save.get("best_streak", -1) == 2)
    assert(_read_json("user://rulebreak_save.json.bak").get("streak", -1) == 2)
    assert(not FileAccess.file_exists("user://rulebreak_save.json.bak.old.tmp"))

    progression.set_current_level(57)
    assert(progression.current_level == 57)
    progression.set_current_level(-100)
    assert(progression.current_level == 0)
    progression.set_current_level(1000)
    assert(progression.current_level == 99)
    assert(_read_json("user://rulebreak_save.json").get("current_level", -1) == 99)

    # A deliberately inconsistent legacy/corrupt state must not violate the
    # derived invariant when loaded.
    _write_json("user://rulebreak_save.json", {
        "version": 1,
        "streak": 9,
        "best_streak": 2,
        "total_correct": 12,
        "total_wrong": 4,
        "current_level": 150
    })

    var restored = ProgressionScript.new()
    restored.load_state()
    assert(restored.streak == 9)
    assert(restored.best_streak == 9)
    assert(restored.total_correct == 12)
    assert(restored.total_wrong == 4)
    assert(restored.current_level == 99)

    # If a primary save is truncated during a replacement, a known-good backup
    # must win instead of silently resetting progress to defaults.
    _write_json("user://rulebreak_save.json.bak", {
        "version": 1,
        "streak": 4,
        "best_streak": 7,
        "total_correct": 31,
        "total_wrong": 8,
        "current_level": 41
    })
    _write_json("user://rulebreak_save.json", {"truncated": true})

    var recovered = ProgressionScript.new()
    recovered.load_state()
    assert(recovered.streak == 4)
    assert(recovered.best_streak == 7)
    assert(recovered.total_correct == 31)
    assert(recovered.total_wrong == 8)
    assert(recovered.current_level == 41)
    assert(FileAccess.file_exists("user://rulebreak_save.json.bak"))
    assert(not FileAccess.file_exists("user://rulebreak_save.json.bak.tmp"))
    var restored_primary := _read_json("user://rulebreak_save.json")
    assert(restored_primary.get("streak", -1) == 4)
    assert(restored_primary.get("best_streak", -1) == 7)
    assert(restored_primary.get("total_correct", -1) == 31)
    assert(restored_primary.get("current_level", -1) == 41)

    # A malformed typed payload must be rejected rather than coerced into a
    # seemingly valid state.
    _write_json("user://rulebreak_save.json", {
        "version": 1,
        "streak": "not-an-int",
        "best_streak": 99,
        "total_correct": 99,
        "total_wrong": 0,
        "current_level": 12
    })
    _write_json("user://rulebreak_save.json.bak", {
        "version": 1,
        "streak": 6,
        "best_streak": 8,
        "total_correct": 40,
        "total_wrong": 10,
        "current_level": 12
    })
    var typed_recovered = ProgressionScript.new()
    typed_recovered.load_state()
    assert(typed_recovered.streak == 6)
    assert(typed_recovered.best_streak == 8)
    assert(typed_recovered.total_correct == 40)
    assert(typed_recovered.total_wrong == 10)
    assert(typed_recovered.current_level == 12)
    assert(FileAccess.file_exists("user://rulebreak_save.json.bak"))
    var typed_primary := _read_json("user://rulebreak_save.json")
    assert(typed_primary.get("streak", -1) == 6)
    assert(typed_primary.get("best_streak", -1) == 8)
    assert(typed_primary.get("total_correct", -1) == 40)

    _cleanup_save_files()
    print("RULEBREAK Progression persistence/recovery/invariant tests: PASS — primary save rotation, backup restoration, typed payload rejection and bounded level state")
    quit(0)
