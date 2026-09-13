class_name ChallengeViewV2
extends Control

signal input_ready_changed(ready: bool)
signal response_window_started(started_at_ms: int, duration_ms: int)

const SEE_SHAPES := ["●", "▲", "■", "◆"]
const SUPPORTED_FAMILIES := {"KIND_SEE": true, "KIND_REMEMBER": true, "KIND_REACT": true, "KIND_SWITCH": true, "KIND_TRICK": true, "KIND_MIX": true}

var challenge_id := ""
var correct_index := -1
var visual_root: Control
var input_ready := false
var phase_token := 0
var response_duration_ms := 1400

func _ready() -> void:
    mouse_filter = Control.MOUSE_FILTER_IGNORE

func show_challenge(challenge: Dictionary) -> void:
    phase_token += 1
    var token := phase_token
    _set_input_ready(false)
    clear_view()
    challenge_id = str(challenge.get("id", ""))
    correct_index = int(challenge.get("correct", -1))
    _new_root()
    match str(challenge.get("kind_key", "")):
        "KIND_SEE":
            if challenge_id == "speed_change": await _run_speed_change(token)
            else:
                _build_see()
                _set_input_ready(true)
        "KIND_REMEMBER": await _run_remember(token)
        "KIND_REACT": await _run_react(token)
        "KIND_SWITCH": await _run_switch(token)
        "KIND_TRICK":
            _build_trick()
            _set_input_ready(true)
        "KIND_MIX": await _run_mix(token)
        _:
            _build_generic()
            _set_input_ready(true)

func supports_challenge(challenge: Dictionary) -> bool:
    return SUPPORTED_FAMILIES.has(str(challenge.get("kind_key", ""))) and not str(challenge.get("id", "")).is_empty()

func _new_root() -> void:
    visual_root = VBoxContainer.new()
    visual_root.add_theme_constant_override("separation", 8)
    visual_root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    visual_root.alignment = BoxContainer.ALIGNMENT_CENTER
    add_child(visual_root)

func _set_input_ready(ready: bool) -> void:
    input_ready = ready
    input_ready_changed.emit(ready)
    if ready and challenge_id in ["color_timer", "second_signal", "only_x"]:
        response_window_started.emit(Time.get_ticks_msec(), response_duration_ms)

func _close_response_window(token: int) -> void:
    await get_tree().create_timer(float(response_duration_ms) / 1000.0).timeout
    if token != phase_token or not input_ready: return
    _set_input_ready(false)
    if visual_root: _label("TOO_SLOW", 26)

func clear_view() -> void:
    if visual_root:
        visual_root.queue_free()
        visual_root = null

func _label(key: String, size: int = 30) -> Label:
    var label := Label.new()
    label.text = tr(key)
    label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    label.add_theme_font_size_override("font_size", size)
    label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    visual_root.add_child(label)
    return label

func _card(text: String, size: int = 46, height: int = 78) -> PanelContainer:
    var panel := PanelContainer.new()
    panel.custom_minimum_size = Vector2(0, height)
    var label := Label.new()
    label.text = text
    label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    label.add_theme_font_size_override("font_size", size)
    panel.add_child(label)
    visual_root.add_child(panel)
    _pop_in(panel)
    return panel

func _color_word_card(word: String, color: Color, size: int = 58, height: int = 90) -> PanelContainer:
    var panel := PanelContainer.new()
    panel.custom_minimum_size = Vector2(0, height)
    var label := Label.new()
    label.text = word
    label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    label.add_theme_font_size_override("font_size", size)
    label.add_theme_color_override("font_color", color)
    panel.add_child(label)
    visual_root.add_child(panel)
    _pop_in(panel)
    return panel

func _pop_in(node: Control) -> void:
    node.modulate.a = 0.0
    node.scale = Vector2(0.94, 0.94)
    var tween := create_tween()
    tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
    tween.parallel().tween_property(node, "modulate:a", 1.0, 0.18)
    tween.parallel().tween_property(node, "scale", Vector2.ONE, 0.18)

func _pulse(node: Control) -> void:
    var tween := create_tween()
    tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
    tween.tween_property(node, "scale", Vector2(1.06, 1.06), 0.12)
    tween.tween_property(node, "scale", Vector2.ONE, 0.16)

func _build_see() -> void:
    _label("SEE_WATCH", 24)
    for i in 4:
        var value := SEE_SHAPES[i]
        if i == correct_index: value = _see_exception_shape()
        _card(value, 52, 82)
    _label(_see_footer(), 24)

func _see_exception_shape() -> String:
    match challenge_id:
        "mirrored", "see_direction": return "←"
        "see_rotation": return "◀"
        "see_missing_edge": return "◇"
        "see_filled_shape": return "●"
        "see_outline_break": return "○"
        "see_odd_symbol": return "★"
        "see_pattern_break": return "✕"
        "see_duplicate": return SEE_SHAPES[(correct_index + 1) % SEE_SHAPES.size()]
        "see_color_change": return "RED ●"
        "see_size_change": return "●●"
        "see_spacing": return "●     ●"
        "see_angle_change": return "◢"
        "see_symmetry": return "◐"
        "see_position_shift", "see_shape_shift": return "✦"
        _: return "✦"

func _see_footer() -> String:
    match challenge_id:
        "see_rotation": return tr("SEE_ROTATION_VISUAL")
        "see_pattern_break": return tr("SEE_PATTERN_VISUAL")
        "see_duplicate": return tr("SEE_DUPLICATE_VISUAL")
        _: return tr("SEE_SELECT")

func _run_speed_change(token: int) -> void:
    _label("SEE_SPEED", 26)
    var cards: Array[Control] = []
    for i in 4: cards.append(_card(str(char(65 + i)), 52, 82))
    await get_tree().create_timer(0.55).timeout
    if token != phase_token or visual_root == null: return
    for i in 4:
        var count := 4 if i == correct_index else 1
        var speed := 0.08 if i == correct_index else 0.22
        for _j in count:
            if token != phase_token or visual_root == null: return
            var tween := create_tween()
            tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
            tween.tween_property(cards[i], "scale", Vector2(1.07, 1.07), speed)
            tween.tween_property(cards[i], "scale", Vector2.ONE, speed)
            await tween.finished
        await get_tree().create_timer(0.10).timeout
    await get_tree().create_timer(0.30).timeout
    if token != phase_token or visual_root == null: return
    clear_view(); _new_root()
    _label("SEE_SPEED_CHOOSE", 26)
    _card("A        B        C        D", 44, 82)
    _set_input_ready(true)

func _run_remember(token: int) -> void:
    _label("REMEMBER_MEMORIZE", 26)
    var sequence := _remember_sequence()
    var sequence_card := _card(sequence, 40, 92)
    _pulse(sequence_card)
    await get_tree().create_timer(1.15 if challenge_id.begins_with("remember_") else 0.9).timeout
    if token != phase_token or visual_root == null: return
    clear_view(); _new_root()
    _label("REMEMBER_CHOOSE", 30)
    _card("1        2        3        4", 40, 86)
    _set_input_ready(true)

func _remember_sequence() -> String:
    match challenge_id:
        "remember_positions": return "TOP   →   RIGHT   →   BOTTOM"
        "sequence": return "▲   →   ●   →   ■"
        "reverse_sequence": return "■   →   ●   →   ▲"
        "order_memory": return "1   →   2   →   3"
        "vanishing_rule": return "A   →   C   →   B"
        "remember_colors": return "RED   →   BLUE   →   GREEN"
        "remember_shapes": return "●   →   ▲   →   ◆"
        "remember_numbers": return "7   →   2   →   9"
        "remember_corners": return "TOP-LEFT   →   BOTTOM-RIGHT   →   TOP-RIGHT"
        "remember_direction": return "↑   →   →   →   ↓"
        "remember_pairs": return "A1   →   B2   →   C3"
        "remember_lights": return "●   ○   ●   ●"
        "remember_symbols": return "★   →   ◆   →   ✦"
        "remember_path": return "1   →   3   →   2   →   4"
        "remember_slots": return "■   ○   ■   ○"
        "remember_tones": return "LOW   →   HIGH   →   MID"
        "remember_letters": return "A   →   D   →   B"
        "remember_icons": return "★   →   ●   →   ▲"
        "remember_positions_2": return "1:TOP   →   2:LEFT   →   3:RIGHT   →   4:BOTTOM"
        "remember_order_2": return "A   →   C   →   D   →   B"
        _: return "●   →   ▲   →   ■"

func _run_react(token: int) -> void:
    _label("REACT_WAIT", 30); _card("○", 72, 86)
    await get_tree().create_timer(0.55).timeout
    if token != phase_token or visual_root == null: return
    clear_view(); _new_root()
    var target := _react_target()
    _label("REACT_WATCH", 26); _card(target, 58, 92)
    await get_tree().create_timer(0.30).timeout
    if token != phase_token or visual_root == null: return
    clear_view(); _new_root()
    _label("REACT_NOW", 28)
    var target_card := _card(target, 64, 96)
    _pulse(target_card); _set_input_ready(true); _close_response_window(token)

func _react_target() -> String:
    match challenge_id:
        "color_timer", "react_green_twice": return "GREEN"
        "react_red": return "RED"
        "react_blue": return "BLUE"
        "react_yellow": return "YELLOW"
        "react_circle": return "●"
        "react_triangle": return "▲"
        "react_star": return "★"
        "react_even": return "2"
        "react_third": return "3"
        "react_fourth": return "4"
        "react_after_change": return "GO"
        "react_signal_two", "second_signal": return "SECOND"
        "react_final": return "FINAL"
        "only_x", "react_x_only": return "X"
        _: return "X"

func _run_switch(token: int) -> void:
    _label("SWITCH_RULE_ONE", 24); _card(_switch_old_rule(), 40, 70)
    await get_tree().create_timer(0.65).timeout
    if token != phase_token or visual_root == null: return
    clear_view(); _new_root()
    _label("SWITCH_RULE_CHANGED", 26); _card(_switch_new_rule(), 40, 82); _label("SWITCH_CHOOSE", 28)
    await get_tree().create_timer(0.45).timeout
    if token != phase_token or visual_root == null: return
    clear_view(); _new_root(); _label("SWITCH_CHOOSE", 28); _card(_switch_choices(), 40, 82); _set_input_ready(true)

func _switch_old_rule() -> String:
    match challenge_id:
        "sound_switch", "switch_after_signal": return tr("SWITCH_SIGNAL")
        "no_repeat": return tr("SWITCH_NO_REPEAT")
        _: return tr("SWITCH_BLUE")

func _switch_new_rule() -> String:
    match challenge_id:
        "sound_switch", "switch_after_signal": return tr("SWITCH_NEW_SIGNAL")
        "switch_reverse": return tr("SWITCH_REVERSE")
        "switch_number": return tr("SWITCH_NUMBER")
        "switch_shape": return tr("SWITCH_SHAPE")
        "switch_direction", "switch_direction_two": return tr("SWITCH_DIRECTION")
        "switch_timing": return tr("SWITCH_TIMING")
        "switch_action": return tr("SWITCH_ACTION")
        _: return tr("SWITCH_NEW_RULE")

func _switch_choices() -> String:
    match challenge_id:
        "switch_number": return "1        2        3        4"
        "switch_shape": return "●        ▲        ■        ◆"
        "switch_direction", "switch_direction_two": return "↑        →        ↓        ←"
        _: return "BLUE        RED        GREEN        YELLOW"

func _build_trick() -> void:
    match challenge_id:
        "dont_press": _card(tr("PRESS_IT"), 44, 78); _label("TRICK_OBVIOUS", 26)
        "largest_wrong", "trick_smallest", "trick_not_largest": _card("SMALL      MEDIUM      LARGE", 34, 78); _label("TRICK_SIZE", 26)
        "obvious_wrong", "trick_second", "trick_obvious_two": _card("FIRST      SECOND      THIRD      FOURTH", 30, 78); _label("TRICK_FIRST_IS_DECOY", 25)
        "word_color", "trick_word", "trick_color": _color_word_card("BLUE", Color("e24b4b"), 58, 90); _label("TRICK_WORD_COLOR", 26)
        "trick_forbidden": _card("DO NOT TAP", 42, 80); _label("TRICK_FORBIDDEN", 26)
        "trick_slowest": _card("FAST   FAST   SLOW   FAST", 38, 82); _label("TRICK_SLOWEST", 26)
        "trick_decoy": _card("REAL   DECOY   REAL   REAL", 34, 82); _label("TRICK_DECOY", 26)
        "trick_exception": _card("RULE   RULE   EXCEPTION   RULE", 31, 82); _label("TRICK_EXCEPTION", 26)
        "trick_wrong_label": _card("LABEL A   LABEL B   LABEL C   LABEL D", 26, 82); _label("TRICK_LABEL", 26)
        "trick_contradiction": _card("OLD RULE   →   NEW RULE", 30, 82); _label("TRICK_LATEST", 26)
        "trick_hidden", "trick_mislead", "trick_reverse": _card("A      B      C      D", 46, 82); _label("TRICK_HIDDEN", 26)
        _: _card("A      B      C      D", 46, 82); _label("TRICK_READ_RULE", 26)

func _run_mix(token: int) -> void:
    _label("MIX_SEE", 24); _card("●   ▲   ◆   ●", 44, 72); _label("MIX_NOTICE", 22)
    await get_tree().create_timer(0.45).timeout
    if token != phase_token or visual_root == null: return
    clear_view(); _new_root(); _label("MIX_SWITCH", 24); var new_rule := _card(tr("SWITCH_NEW_RULE"), 36, 78); _pulse(new_rule)
    await get_tree().create_timer(0.45).timeout
    if token != phase_token or visual_root == null: return
    clear_view(); _new_root(); _label("MIX_REACT", 24); _card("WAIT  →  GO", 44, 76); _label("MIX_CHOOSE_SIGNAL", 24); _card("FIRST     SECOND     THIRD     FOURTH", 30, 78); _set_input_ready(true)

func _build_generic() -> void:
    _card(tr("UNSUPPORTED_CHALLENGE"), 30, 78)
