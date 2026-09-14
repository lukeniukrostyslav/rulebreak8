extends SceneTree

const AudioFeedbackScript = preload("res://scripts/core/audio_feedback.gd")

func _init() -> void:
    var feedback := AudioFeedbackScript.new()
    root.add_child(feedback)
    await process_frame
    await process_frame

    assert(feedback.player != null)
    assert(feedback.generator != null)
    assert(feedback.playback != null)
    assert(feedback.player.playing)

    feedback.play_correct()
    feedback.play_wrong()
    feedback.play_timeout()
    await process_frame
    await process_frame

    assert(feedback.playback.get_frames_available() >= 0)
    print("RULEBREAK audio feedback smoke: PASS — correct, wrong and timeout tones accepted")
    quit(0)
