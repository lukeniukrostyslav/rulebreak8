class_name ChallengeView
extends Control

signal input_ready_changed(ready: bool)
signal response_window_started(started_at_ms: int, duration_ms: int)

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
            _build_see()
            _set_input_ready(true)
        "KIND_REMEMBER":
            await _run_remember(token)
        "KIND_REACT":
            await _run_react(token)
        "KIND_SWITCH":
            await _run_switch(token)
        "KIND_TRICK":
            _build_trick()
            _set_input_ready(true)
        "KIND_MIX":
            await _run_mix(token)
        _:
            _build_generic()
            _set_input_ready(true)

func _new_root() -> void:
    visual_root = VBoxContainer.new()
    visual_root.add_theme_constant_override("separation", 8)
    visual_root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    visual_root.alignment = BoxContainer.ALIGNMENT_CENTER
    add_child(visual_root)

func _set_input_ready(ready: bool) -> void:
    input_ready = ready
    input_ready_changed.emit(ready)
    if ready and (challenge_id == "color_timer" or challenge_id == "second_signal" or challenge_id == "only_x"):
        response_window_started.emit(Time.get_ticks_msec(), response_duration_ms)

func clear_view() -> void:
    if visual_root:
        visual_root.queue_free()
        visual_root = null

func _label(text: String, size: int = 30) -> Label:
    var label := Label.new()
    label.text = text
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
    _label("A        B        C        D", 24)
    var panels: Array[PanelContainer] = []
    for i in 4:
        var shape := "●"
        if i == 1:
            shape = "▲"
        elif i == 2:
            shape = "■"
        elif i == 3:
            shape = "◆"
        if i == correct_index:
            if challenge_id == "mirrored":
                shape = "◀"
            else:
                shape = "✦"
        panels.append(_card(shape, 52, 82))
    _label("FIND THE CHANGE", 26)

func _run_remember(token: int) -> void:
    _label("MEMORIZE", 26)
    var sequence := "●   →   ▲   →   ■"
    if challenge_id == "remember_positions":
        sequence = "TOP   →   RIGHT   →   BOTTOM"
    elif challenge_id == "sequence":
        sequence = "▲   →   ●   →   ■"
    elif challenge_id == "reverse_sequence":
        sequence = "■   →   ●   →   ▲"
    elif challenge_id == "order_memory":
        sequence = "1   →   2   →   3"
    elif challenge_id == "vanishing_rule":
        sequence = "A   →   C   →   B"
    var sequence_card := _card(sequence, 44, 86)
    _pulse(sequence_card)
    await get_tree().create_timer(0.9).timeout
    if token != phase_token or visual_root == null:
        return
    clear_view()
    _new_root()
    _label("NOW CHOOSE", 30)
    _card("THE SEQUENCE IS GONE", 30, 86)
    _set_input_ready(true)

func _run_react(token: int) -> void:
    _label("WAIT...", 30)
    _card("○", 72, 86)
    await get_tree().create_timer(0.75).timeout
    if token != phase_token or visual_root == null:
        return
    clear_view()
    _new_root()
    var signal_text := "GREEN"
    if challenge_id == "second_signal":
        signal_text = "SECOND!"
    elif challenge_id == "only_x":
        signal_text = "X"
    var signal_card := _card(signal_text, 58, 92)
    _label("REACT NOW", 28)
    _pulse(signal_card)
    _set_input_ready(true)

func _run_switch(token: int) -> void:
    var old_rule := "TAP BLUE"
    var new_rule := "NOW TAP RED"
    if challenge_id == "sound_switch":
        old_rule = "KEEP LISTENING"
        new_rule = "SWITCH RULE"
    elif challenge_id == "no_repeat":
        old_rule = "DO NOT REPEAT LEFT"
        new_rule = "CHOOSE RIGHT"
    elif challenge_id == "instruction_change":
        old_rule = "FOLLOW OLD INSTRUCTION"
        new_rule = "FOLLOW NEW INSTRUCTION"
    _label("RULE 1", 24)
    _card(old_rule, 40, 70)
    await get_tree().create_timer(0.7).timeout
    if token != phase_token or visual_root == null:
        return
    clear_view()
    _new_root()
    _label("RULE CHANGED", 26)
    var new_rule_card := _card(new_rule, 40, 82)
    _label("SWITCH", 28)
    _pulse(new_rule_card)
    _set_input_ready(true)

func _build_trick() -> void:
    if challenge_id == "dont_press":
        _card("PRESS IT", 44, 78)
        _label("THE RULE SAYS: WAIT", 28)
    elif challenge_id == "largest_wrong":
        _card("SMALL   MEDIUM   LARGE", 34, 78)
        _label("THE LARGEST IS WRONG", 26)
    elif challenge_id == "obvious_wrong":
        _card("OBVIOUS   SECOND   THIRD   FOURTH", 28, 78)
        _label("THE OBVIOUS ANSWER IS WRONG", 25)
    else:
        _card("RED", 58, 78)
        _label("THE WORD IS BLUE", 26)
        _label("FOLLOW THE WORD", 25)

func _run_mix(token: int) -> void:
    _label("SEE", 24)
    _card("◆   ●   ▲   ◆", 44, 72)
    await get_tree().create_timer(0.55).timeout
    if token != phase_token or visual_root == null:
        return
    clear_view()
    _new_root()
    _label("SWITCH", 24)
    var new_rule := _card("NEW RULE: TAP C", 36, 78)
    _pulse(new_rule)
    await get_tree().create_timer(0.55).timeout
    if token != phase_token or visual_root == null:
        return
    _label("REACT", 24)
    _set_input_ready(true)

func _build_generic() -> void:
    _card(challenge_id, 36, 78)
