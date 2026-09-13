extends Control

const CHALLENGES := [
    {"rule":"TAP BLUE","correct":0, "kind":"switch"},
    {"rule":"TAP RED","correct":1, "kind":"switch"},
    {"rule":"TAP THE LARGEST","correct":2, "kind":"trick"},
    {"rule":"TAP THE WORD, NOT THE COLOR","correct":3, "kind":"trick"}
]

var challenge_index := 0
var streak := 0
var best_streak := 0
var buttons: Array[Button] = []
var rule_label: Label
var streak_label: Label
var feedback_label: Label

func _ready() -> void:
    _build_ui()
    _show_challenge()

func _build_ui() -> void:
    var bg := ColorRect.new()
    bg.color = Color("111217")
    bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(bg)

    var margin := MarginContainer.new()
    margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    margin.add_theme_constant_override("margin_left", 48)
    margin.add_theme_constant_override("margin_right", 48)
    margin.add_theme_constant_override("margin_top", 80)
    margin.add_theme_constant_override("margin_bottom", 80)
    add_child(margin)

    var root := VBoxContainer.new()
    root.add_theme_constant_override("separation", 28)
    margin.add_child(root)

    var title := Label.new()
    title.text = "RULEBREAK"
    title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title.add_theme_font_size_override("font_size", 42)
    root.add_child(title)

    rule_label = Label.new()
    rule_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    rule_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    rule_label.add_theme_font_size_override("font_size", 56)
    rule_label.custom_minimum_size.y = 150
    root.add_child(rule_label)

    streak_label = Label.new()
    streak_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    streak_label.add_theme_font_size_override("font_size", 28)
    root.add_child(streak_label)

    var grid := GridContainer.new()
    grid.columns = 2
    grid.size_flags_vertical = Control.SIZE_EXPAND_FILL
    grid.add_theme_constant_override("h_separation", 22)
    grid.add_theme_constant_override("v_separation", 22)
    root.add_child(grid)

    for i in 4:
        var b := Button.new()
        b.text = str(i + 1)
        b.add_theme_font_size_override("font_size", 44)
        b.custom_minimum_size = Vector2(0, 260)
        b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        b.pressed.connect(_on_choice.bind(i))
        grid.add_child(b)
        buttons.append(b)

    feedback_label = Label.new()
    feedback_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    feedback_label.add_theme_font_size_override("font_size", 34)
    feedback_label.custom_minimum_size.y = 80
    root.add_child(feedback_label)

func _show_challenge() -> void:
    var challenge: Dictionary = CHALLENGES[challenge_index]
    rule_label.text = challenge.rule
    streak_label.text = "STREAK  %d   •   BEST  %d" % [streak, best_streak]
    feedback_label.text = ""
    for i in buttons.size():
        buttons[i].text = ["BLUE", "RED", "LARGEST", "WORD"][i]
        buttons[i].disabled = false

func _on_choice(choice: int) -> void:
    var challenge: Dictionary = CHALLENGES[challenge_index]
    var correct: bool = choice == challenge.correct
    for b in buttons:
        b.disabled = true
    if correct:
        streak += 1
        best_streak = max(best_streak, streak)
        feedback_label.text = "CORRECT  ✓"
        challenge_index = (challenge_index + 1) % CHALLENGES.size()
        await get_tree().create_timer(0.35).timeout
        _show_challenge()
    else:
        feedback_label.text = "WRONG  •  BREAK THE RULE"
        streak = 0
        await get_tree().create_timer(0.7).timeout
        _show_challenge()
