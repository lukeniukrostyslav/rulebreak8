extends Control

const ChallengeManagerScript = preload("res://scripts/core/challenge_manager.gd")
const ProgressionScript = preload("res://scripts/core/progression.gd")
const ChallengeViewV2Script = preload("res://scripts/core/challenge_view_v2.gd")
const AudioFeedbackScript = preload("res://scripts/core/audio_feedback.gd")

var challenge_manager := ChallengeManagerScript.new()
var progression := ProgressionScript.new()
var challenge_view := ChallengeViewV2Script.new()
var audio_feedback := AudioFeedbackScript.new()

var buttons: Array[Button] = []
var rule_label: Label
var streak_label: Label
var feedback_label: Label
var challenge_label: Label
var progress_bar: ProgressBar
var reaction_started_at_ms := -1
var reaction_duration_ms := 0
var answer_locked := false

func _ready() -> void:
    var localization := get_node_or_null("/root/Localization")
    if localization != null:
        if not localization.loaded:
            localization.load_translations()
        TranslationServer.set_locale(localization.select_system_locale())
    challenge_view.input_ready_changed.connect(_on_visual_input_ready)
    challenge_view.response_window_started.connect(_on_response_window_started)
    add_child(audio_feedback)
    progression.load_state()
    challenge_manager.index = progression.current_level
    _build_ui()
    _show_challenge()

func _build_ui() -> void:
    var bg := ColorRect.new()
    bg.color = Color("0B0E14")
    bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(bg)

    var viewport_size := get_viewport_rect().size
    var compact := viewport_size.y < 1700.0 or viewport_size.x < 900.0
    var outer_margin := 24 if compact else 42
    var section_gap := 8 if compact else 12
    var title_size := 34 if compact else 42
    var rule_height := 96 if compact else 116
    var rule_size := 32 if compact else 38
    var challenge_height := 190 if compact else 230
    var streak_size := 20 if compact else 22
    var grid_height := 205 if compact else 250
    var button_height := 92 if compact else 112
    var button_size := 24 if compact else 27
    var feedback_height := 48 if compact else 58
    var feedback_size := 22 if compact else 25

    var margin := MarginContainer.new()
    margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    margin.add_theme_constant_override("margin_left", outer_margin)
    margin.add_theme_constant_override("margin_right", outer_margin)
    margin.add_theme_constant_override("margin_top", outer_margin)
    margin.add_theme_constant_override("margin_bottom", outer_margin)
    add_child(margin)

    var root := VBoxContainer.new()
    root.add_theme_constant_override("separation", section_gap)
    root.size_flags_vertical = Control.SIZE_EXPAND_FILL
    margin.add_child(root)

    var title := Label.new()
    title.text = tr("GAME_TITLE")
    title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title.add_theme_font_size_override("font_size", title_size)
    title.add_theme_color_override("font_color", Color("F4F6FA"))
    root.add_child(title)

    progress_bar = ProgressBar.new()
    progress_bar.custom_minimum_size = Vector2(0, 10)
    progress_bar.show_percentage = false
    progress_bar.max_value = challenge_manager.challenges.size()
    _style_progress_bar(progress_bar)
    root.add_child(progress_bar)

    challenge_label = Label.new()
    challenge_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    challenge_label.add_theme_font_size_override("font_size", 18 if not compact else 16)
    challenge_label.add_theme_color_override("font_color", Color("AEB7C7"))
    challenge_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    root.add_child(challenge_label)

    var rule_panel := PanelContainer.new()
    rule_panel.custom_minimum_size = Vector2(0, rule_height)
    _style_rule_panel(rule_panel)
    root.add_child(rule_panel)

    rule_label = Label.new()
    rule_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    rule_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    rule_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    rule_label.add_theme_font_size_override("font_size", rule_size)
    rule_label.add_theme_color_override("font_color", Color("FFFFFF"))
    rule_label.add_theme_constant_override("outline_size", 2)
    rule_label.add_theme_color_override("font_outline_color", Color("11151D"))
    rule_panel.add_child(rule_label)

    challenge_view.custom_minimum_size = Vector2(0, challenge_height)
    challenge_view.size_flags_vertical = Control.SIZE_EXPAND_FILL
    challenge_view.pivot_offset = Vector2(540, challenge_height * 0.5)
    root.add_child(challenge_view)

    streak_label = Label.new()
    streak_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    streak_label.add_theme_font_size_override("font_size", streak_size)
    streak_label.add_theme_color_override("font_color", Color("D5DBE6"))
    root.add_child(streak_label)

    var grid := GridContainer.new()
    grid.columns = 2
    grid.custom_minimum_size.y = grid_height
    grid.add_theme_constant_override("h_separation", compact ? 10 : 14)
    grid.add_theme_constant_override("v_separation", compact ? 10 : 14)
    root.add_child(grid)

    for i in 4:
        var b := Button.new()
        b.add_theme_font_size_override("font_size", button_size)
        b.add_theme_color_override("font_color", Color("F4F6FA"))
        b.add_theme_color_override("font_hover_color", Color("FFFFFF"))
        b.add_theme_color_override("font_pressed_color", Color("FFFFFF"))
        b.add_theme_color_override("font_disabled_color", Color("7E8798"))
        b.custom_minimum_size = Vector2(0, 112)
        if compact:
            b.custom_minimum_size = Vector2(0, button_height)
            b.custom_minimum_size.y = button_height
        b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        b.focus_mode = Control.FOCUS_NONE
        b.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
        _style_choice_button(b)
        b.pressed.connect(_on_choice.bind(i))
        grid.add_child(b)
        buttons.append(b)

    feedback_label = Label.new()
    feedback_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    feedback_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    feedback_label.add_theme_font_size_override("font_size", feedback_size)
    feedback_label.add_theme_color_override("font_color", Color("C9D1DE"))
    feedback_label.add_theme_constant_override("outline_size", 2)
    feedback_label.add_theme_color_override("font_outline_color", Color("11151D"))
    feedback_label.custom_minimum_size.y = feedback_height
    root.add_child(feedback_label)

func _style_rule_panel(panel: PanelContainer) -> void:
    var style := StyleBoxFlat.new()
    style.bg_color = Color("141923")
    style.border_color = Color("303A4D")
    style.set_border_width_all(2)
    style.set_corner_radius_all(20)
    style.content_margin_left = 24
    style.content_margin_right = 24
    style.content_margin_top = 12
    style.content_margin_bottom = 12
    style.shadow_color = Color(0, 0, 0, 0.28)
    style.shadow_size = 8
    style.shadow_offset = Vector2(0, 4)
    panel.add_theme_stylebox_override("panel", style)

func _style_choice_button(button: Button) -> void:
    var normal := StyleBoxFlat.new()
    normal.bg_color = Color("171C25")
    normal.border_color = Color("2C3545")
    normal.set_border_width_all(2)
    normal.set_corner_radius_all(18)
    normal.content_margin_left = 18
    normal.content_margin_right = 18
    normal.content_margin_top = 14
    normal.content_margin_bottom = 14
    normal.shadow_color = Color(0, 0, 0, 0.24)
    normal.shadow_size = 6
    normal.shadow_offset = Vector2(0, 3)

    var hover := normal.duplicate()
    hover.bg_color = Color("202838")
    hover.border_color = Color("596A86")
    hover.shadow_size = 9

    var pressed := normal.duplicate()
    pressed.bg_color = Color("273348")
    pressed.border_color = Color("8A9AB5")
    pressed.shadow_size = 2
    pressed.shadow_offset = Vector2(0, 1)

    var disabled := normal.duplicate()
    disabled.bg_color = Color("11151C")
    disabled.border_color = Color("202632")
    disabled.shadow_size = 0

    button.add_theme_stylebox_override("normal", normal)
    button.add_theme_stylebox_override("hover", hover)
    button.add_theme_stylebox_override("pressed", pressed)
    button.add_theme_stylebox_override("disabled", disabled)

func _style_progress_bar(bar: ProgressBar) -> void:
    var background := StyleBoxFlat.new()
    background.bg_color = Color("171C25")
    background.set_corner_radius_all(5)
    var fill := StyleBoxFlat.new()
    fill.bg_color = Color("7C8FFF")
    fill.set_corner_radius_all(5)
    bar.add_theme_stylebox_override("background", background)
    bar.add_theme_stylebox_override("fill", fill)

func _show_challenge() -> void:
    reaction_started_at_ms = -1
    reaction_duration_ms = 0
    answer_locked = false
    var challenge: Dictionary = challenge_manager.current()
    var total := challenge_manager.challenges.size()
    var position := challenge_manager.index + 1
    var kind_key := str(challenge.get("kind_key", ""))
    challenge_label.text = "%s  %d / %d   •   %s" % [tr("CHALLENGE"), position, total, tr(kind_key)]
    progress_bar.max_value = total
    progress_bar.value = position - 1
    rule_label.text = _localized_rule_text(challenge)
    streak_label.text = "%s  %d   •   %s  %d" % [tr("STREAK"), progression.streak, tr("BEST"), progression.best_streak]
    feedback_label.text = ""
    feedback_label.add_theme_color_override("font_color", Color("C9D1DE"))
    challenge_view.show_challenge(challenge)
    challenge_view.scale = Vector2(0.985, 0.985)
    challenge_view.modulate.a = 0.0
    var intro := create_tween().set_parallel(true)
    intro.tween_property(challenge_view, "scale", Vector2.ONE, 0.18).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
    intro.tween_property(challenge_view, "modulate:a", 1.0, 0.18)

    var choices: Array = challenge.get("choices", [])
    for i in buttons.size():
        buttons[i].text = tr(str(choices[i])) if i < choices.size() else "—"
        buttons[i].disabled = not challenge_view.input_ready
        buttons[i].scale = Vector2.ONE

func _localized_rule_text(challenge: Dictionary) -> String:
    var rule_key := str(challenge.get("rule_key", ""))
    var translated := tr(rule_key)
    if not rule_key.is_empty() and translated != rule_key:
        return translated

    var description := str(challenge.get("description", "")).strip_edges()
    if not description.is_empty():
        return description

    if str(challenge.get("id", "")) == "rule_switch":
        return tr("RULE_SWITCH_WATCH")
    return translated

func _on_visual_input_ready(ready: bool) -> void:
    if answer_locked:
        return
    if feedback_label:
        if ready:
            feedback_label.text = ""
        else:
            feedback_label.text = tr("WAIT")
    for b in buttons:
        b.disabled = not ready

func _on_response_window_started(started_at_ms: int, duration_ms: int) -> void:
    reaction_started_at_ms = started_at_ms
    reaction_duration_ms = duration_ms

func _animate_answer_button(choice: int) -> void:
    if choice < 0 or choice >= buttons.size():
        return
    var button := buttons[choice]
    var tween := create_tween()
    tween.tween_property(button, "scale", Vector2(0.96, 0.96), 0.05)
    tween.tween_property(button, "scale", Vector2.ONE, 0.10)

func _animate_feedback(correct: bool) -> void:
    if feedback_label == null:
        return
    feedback_label.scale = Vector2(0.94, 0.94)
    feedback_label.modulate.a = 0.55
    var tween := create_tween().set_parallel(true)
    tween.tween_property(feedback_label, "scale", Vector2.ONE, 0.16).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
    tween.tween_property(feedback_label, "modulate:a", 1.0, 0.12)

func _on_choice(choice: int) -> void:
    if answer_locked or not challenge_view.input_ready:
        return

    _animate_answer_button(choice)
    answer_locked = true
    challenge_view.input_ready = false
    var reaction_timed_out := false
    if reaction_started_at_ms >= 0:
        reaction_timed_out = Time.get_ticks_msec() - reaction_started_at_ms > reaction_duration_ms

    var correct := challenge_manager.check(choice) and not reaction_timed_out
    for b in buttons:
        b.disabled = true

    progression.record(correct)

    if correct:
        feedback_label.text = "%s  ✓" % tr("CORRECT")
        feedback_label.add_theme_color_override("font_color", Color("77E0A2"))
        _animate_feedback(true)
        Input.vibrate_handheld(35)
        audio_feedback.play_correct()
        challenge_manager.next()
        progression.set_current_level(challenge_manager.index)
        streak_label.text = "%s  %d   •   %s  %d" % [tr("STREAK"), progression.streak, tr("BEST"), progression.best_streak]
        await get_tree().create_timer(0.35).timeout
    else:
        feedback_label.text = "%s  •  %s" % [tr("WRONG"), tr("TRY_AGAIN")]
        feedback_label.add_theme_color_override("font_color", Color("FF8F8F"))
        _animate_feedback(false)
        Input.vibrate_handheld(55)
        audio_feedback.play_wrong()
        streak_label.text = "%s  %d   •   %s  %d" % [tr("STREAK"), progression.streak, tr("BEST"), progression.best_streak]
        await get_tree().create_timer(0.7).timeout

    _show_challenge()
