extends SceneTree

const ProgressionScript = preload("res://scripts/core/progression.gd")

func _init() -> void:
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

    progression.record(true)
    assert(progression.streak == 2)
    assert(progression.best_streak == 2)
    assert(progression.total_correct == 2)

    progression.record(false)
    assert(progression.streak == 0)
    assert(progression.best_streak == 2)
    assert(progression.total_correct == 2)
    assert(progression.total_wrong == 1)

    progression.set_current_level(57)
    assert(progression.current_level == 57)
    progression.set_current_level(-100)
    assert(progression.current_level == 0)
    progression.set_current_level(1000)
    assert(progression.current_level == 99)

    # A deliberately inconsistent legacy/corrupt state must not violate the
    # derived invariant when loaded.
    var save_path := "user://rulebreak_save.json"
    var file := FileAccess.open(save_path, FileAccess.WRITE)
    assert(file != null)
    file.store_string(JSON.stringify({
        "version": 1,
        "streak": 9,
        "best_streak": 2,
        "total_correct": 12,
        "total_wrong": 4,
        "current_level": 150
    }))
    file = null

    var restored = ProgressionScript.new()
    restored.load_state()
    assert(restored.streak == 9)
    assert(restored.best_streak == 9)
    assert(restored.total_correct == 12)
    assert(restored.total_wrong == 4)
    assert(restored.current_level == 99)

    DirAccess.remove_absolute(ProjectSettings.globalize_path(save_path))
    print("RULEBREAK Progression persistence/invariant tests: PASS")
    quit(0)
