extends SceneTree

const GAME_PATH := "res://scripts/game.gd"
const VIEW_PATH := "res://scripts/core/challenge_view_v2.gd"
const AUDIO_PATH := "res://scripts/core/audio_feedback.gd"
const PROJECT_PATH := "res://project.godot"

func _fail(message: String) -> void:
    push_error("RULEBREAK UI contract: " + message)
    quit(1)

func _require(text: String, needle: String, label: String) -> bool:
    if not text.contains(needle):
        _fail("missing %s: %s" % [label, needle])
        return false
    return true

func _init() -> void:
    var game := FileAccess.get_file_as_string(GAME_PATH)
    var view := FileAccess.get_file_as_string(VIEW_PATH)
    var audio := FileAccess.get_file_as_string(AUDIO_PATH)
    var project := FileAccess.get_file_as_string(PROJECT_PATH)

    if game.is_empty() or view.is_empty() or audio.is_empty() or project.is_empty():
        _fail("required UI contract source is missing")
        return

    _require(game, "const ChallengeViewV2Script = preload", "canonical ChallengeViewV2 preload")
    _require(game, "challenge_view := ChallengeViewV2Script.new()", "canonical ChallengeViewV2 instantiation")
    _require(game, "var viewport_size := get_viewport_rect().size", "runtime viewport sizing")
    _require(game, "var compact := viewport_size.y < 1700.0 or viewport_size.x < 900.0", "compact portrait layout branch")
    _require(game, "var outer_margin := 24 if compact else 42", "responsive outer margins")
    _require(game, "var button_height := 92 if compact else 112", "responsive touch target height")
    _require(game, "grid.columns = 2", "four-choice two-column layout")
    _require(game, "for i in 4:", "four answer buttons")
    _require(game, "Input.vibrate_handheld(35)", "correct-answer haptic feedback")
    _require(game, "Input.vibrate_handheld(55)", "wrong-answer haptic feedback")
    _require(game, "audio_feedback.play_correct()", "correct-answer audio feedback")
    _require(game, "audio_feedback.play_wrong()", "wrong-answer audio feedback")
    _require(game, "answer_locked = true", "logical double-answer lock")
    _require(game, "if answer_locked or not challenge_view.input_ready:", "input-state guard")
    _require(game, "challenge_view.modulate.a = 0.0", "challenge entrance animation")
    _require(game, 'tween_property(challenge_view, "modulate:a"', "challenge fade-in animation")
    _require(game, "func _style_rule_panel", "rule hierarchy panel styling")
    _require(game, "style.shadow_size = 8", "rule panel depth styling")
    _require(game, "normal.shadow_size = 6", "answer button depth styling")
    _require(game, "func _animate_feedback", "answer feedback animation")
    _require(game, 'feedback_label, "scale"', "feedback scale animation")

    _require(view, "signal input_ready_changed", "challenge input readiness signal")
    _require(view, "signal response_window_started", "timed-response signal")
    _require(view, "func supports_challenge", "renderer support contract")
    _require(view, "func show_challenge", "renderer entry point")

    _require(audio, "class_name AudioFeedback", "audio feedback class")
    _require(audio, "func play_correct()", "correct audio method")
    _require(audio, "func play_wrong()", "wrong audio method")
    _require(audio, "playback.get_frames_available()", "audio generator buffer safety")

    _require(project, "window/size/viewport_width=1080", "portrait viewport width")
    _require(project, "window/size/viewport_height=1920", "portrait viewport height")
    _require(project, "window/stretch/mode=\"canvas_items\"", "mobile stretch mode")

    print("RULEBREAK UI contract: PASS — canonical renderer, responsive portrait layout, four-choice input, feedback, haptics, audio")
    quit(0)
