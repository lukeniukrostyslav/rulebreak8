extends SceneTree

const ChallengeManagerScript = preload("res://scripts/core/challenge_manager.gd")

func _fail(message: String) -> void:
    push_error("RULEBREAK manager contract: " + message)
    quit(1)

func _init() -> void:
    var manager = ChallengeManagerScript.new()

    if manager.challenges.size() != 100:
        _fail("expected 100 challenges, got %d" % manager.challenges.size())
        return

    manager.index = -999
    var first := manager.current()
    if manager.index != 0 or first.get("id", "") != manager.challenges[0].get("id", ""):
        _fail("negative index was not normalized to first challenge")
        return

    manager.index = 999
    var last := manager.current()
    if manager.index != 99 or last.get("id", "") != manager.challenges[99].get("id", ""):
        _fail("oversized index was not normalized to last challenge")
        return

    manager.reset()
    if manager.index != 0:
        _fail("reset did not restore index 0")
        return

    var first_id := str(manager.current().get("id", ""))
    var correct := int(manager.current().get("correct", -1))
    if not manager.check(correct):
        _fail("correct answer rejected for %s" % first_id)
        return
    if manager.check((correct + 1) % 4):
        _fail("wrong answer accepted for %s" % first_id)
        return

    manager.index = 99
    manager.next()
    var wrapped := manager.current()
    if manager.index != 0 or str(wrapped.get("id", "")) != str(manager.challenges[0].get("id", "")):
        _fail("next() did not wrap from final challenge to first")
        return

    manager.index = 0
    manager.previous()
    var previous := manager.current()
    if manager.index != 99 or str(previous.get("id", "")) != str(manager.challenges[99].get("id", "")):
        _fail("previous() did not wrap from first challenge to final")
        return

    print("RULEBREAK manager contract: PASS — normalization, reset, answer validation and cyclic navigation")
    quit(0)
