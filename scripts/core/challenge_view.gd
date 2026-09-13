class_name ChallengeView
extends Control

signal input_ready_changed(ready: bool)

var challenge_id := ""
var visual_root: Control
var input_ready := false
var phase_token := 0

func _ready() -> void:
    mouse_filter = Control.MOUSE_FILTER_IGNORE

func show_challenge(challenge: Dictionary) -> void:
    phase_token += 1
    var token := phase_token
    _set_input_ready(false)
    clear_view()
    challenge_id = str(challenge.get("id", ""))
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
    return panel

func _build_see() -> void:
    var changed := "C"
    if challenge_id == "mirrored":
        changed = "D"
    _label("A        B        C        D", 24)
    _card("●    ▲    ■    ◆", 48, 82)
    _label("CHANGED OBJECT: %s" % changed, 26)

func _run_remember(token: int) -> void:
    _label("MEMORIZE", 26)
    var sequence := "●   →   ▲   →   ■"
    if challenge_id == "reverse_sequence":
        sequence = "■   →   ●   →   ▲"
    elif challenge_id == "order_memory":
        sequence = "1   →   2   →   3"
    elif challenge_id == "vanishing_rule":
        sequence = "A   →   C   →   B"
    _card(sequence, 44, 86)
    await get_tree().create_timer(0.9).timeout
    if token != phase_token or visual_root == null:
        return
    clear_view()
    _new_root()
    _label("NOW CHOOSE", 30)
    _card("?   ?   ?", 54, 86)
    _set_input_ready(true)

func _run_react(token: int) -> void:
    _label("WAIT...", 30)
    _card("○", 72, 86)
    await get_tree().create_timer(0.75).timeout
    if token != phase_token or visual_root == null:
        return
    clear_view()
    _new_root()
    var signal_text := "●"
    if challenge_id == "only_x":
        signal_text = "X"
    elif challenge_id == "color_timer":
        signal_text = "GREEN"
    elif challenge_id == "second_signal":
        signal_text = "SECOND!"
    _card(signal_text, 58, 92)
    _label("REACT NOW", 28)
    _set_input_ready(true)

func _run_switch(token: int) -> void:
    _label("RULE 1", 24)
    _card("TAP BLUE", 40, 70)
    await get_tree().create_timer(0.7).timeout
    if token != phase_token or visual_root == null:
        return
    clear_view()
    _new_root()
    _label("RULE CHANGED", 26)
    _card("NOW TAP RED", 40, 82)
    _label("SWITCH", 28)
    _set_input_ready(true)

func _build_trick() -> void:
    if challenge_id == "dont_press":
        _card("PRESS IT", 44, 78)
        _label("THE RULE SAYS: WAIT", 28)
    elif challenge_id == "largest_wrong":
        _card("SMALL   MEDIUM   LARGE", 34, 78)
        _label("THE LARGEST IS WRONG", 26)
    elif challenge_id == "obvious_wrong":
        _card("OBVIOUS", 42, 78)
        _label("THE OBVIOUS ANSWER IS WRONG", 25)
    else:
        _card("RED", 58, 78)
        _label("THE WORD IS BLUE", 26)
        _label("FOLLOW THE RULE", 25)

func _run_mix(token: int) -> void:
    _label("SEE", 24)
    _card("◆   ●   ▲   ◆", 44, 72)
    await get_tree().create_timer(0.55).timeout
    if token != phase_token or visual_root == null:
        return
    clear_view()
    _new_root()
    _label("SWITCH", 24)
    _card("NEW RULE: TAP RED", 36, 78)
    await get_tree().create_timer(0.55).timeout
    if token != phase_token or visual_root == null:
        return
    _label("REACT", 24)
    _set_input_ready(true)

func _build_generic() -> void:
    _card(challenge_id, 36, 78)
