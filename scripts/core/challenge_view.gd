class_name ChallengeView
extends Control

var challenge_id := ""
var visual_root: Control

func _ready() -> void:
    mouse_filter = Control.MOUSE_FILTER_IGNORE

func show_challenge(challenge: Dictionary) -> void:
    clear_view()
    challenge_id = str(challenge.get("id", ""))
    visual_root = VBoxContainer.new()
    visual_root.add_theme_constant_override("separation", 12)
    visual_root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    visual_root.alignment = BoxContainer.ALIGNMENT_CENTER
    add_child(visual_root)

    match str(challenge.get("kind_key", "")):
        "KIND_SEE": _build_see(challenge)
        "KIND_REMEMBER": _build_remember(challenge)
        "KIND_REACT": _build_react(challenge)
        "KIND_SWITCH": _build_switch(challenge)
        "KIND_TRICK": _build_trick(challenge)
        "KIND_MIX": _build_mix(challenge)
        _:
            _build_generic(challenge)

func clear_view() -> void:
    if visual_root:
        visual_root.queue_free()
        visual_root = null

func _label(text: String, size: int = 34) -> Label:
    var label := Label.new()
    label.text = text
    label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    label.add_theme_font_size_override("font_size", size)
    label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    visual_root.add_child(label)
    return label

func _card(text: String, size: int = 46) -> PanelContainer:
    var panel := PanelContainer.new()
    panel.custom_minimum_size = Vector2(0, 105)
    var label := Label.new()
    label.text = text
    label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
    label.add_theme_font_size_override("font_size", size)
    panel.add_child(label)
    visual_root.add_child(panel)
    return panel

func _build_see(challenge: Dictionary) -> void:
    _label("●   ▲   ■   ◆", 58)
    _label("        ◆   ← changed", 30)
    _label("A        B        C        D", 34)

func _build_remember(challenge: Dictionary) -> void:
    _label("●  →  ▲  →  ■", 58)
    _label("MEMORIZE", 28)
    _card("▲   ●   ■", 48)

func _build_react(challenge: Dictionary) -> void:
    _label("READY", 30)
    _card("●", 76)
    _label("REACT NOW", 30)

func _build_switch(challenge: Dictionary) -> void:
    _label("RULE 1", 28)
    _card("TAP BLUE", 42)
    _label("↓  SWITCH  ↓", 30)
    _card("NOW TAP RED", 42)

func _build_trick(challenge: Dictionary) -> void:
    _card("RED", 64)
    _label("but the word is BLUE", 30)
    _label("TRUST THE RULE — NOT THE OBVIOUS", 26)

func _build_mix(challenge: Dictionary) -> void:
    _label("SEE", 26)
    _card("◆   ●   ▲   ◆", 48)
    _label("↓ SWITCH ↓", 26)
    _card("NEW RULE: TAP RED", 40)
    _label("↓ REACT ↓", 26)

func _build_generic(challenge: Dictionary) -> void:
    _card(str(challenge.get("id", "RULE")), 38)
