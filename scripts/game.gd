extends Control

var challenge_manager := ChallengeManager.new()
var progression := Progression.new()

var buttons: Array[Button] = []
var rule_label: Label
var streak_label: Label
var feedback_label: Label
var challenge_label: Label

func _ready() -> void:
    _set_device_language()
    progression.load_state()
    _build_ui()
    _show_challenge()

func _set_device_language() -> void:
    var language := OS.get_locale_language()
    if language.is_empty():
        language = "en"
    TranslationServer.set_locale(language)

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
    root.add_theme_constant_override("separation", 22)
    margin.add_child(root)

    var title := Label.new()
    title.text = tr("GAME_TITLE")
    title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    title.add_theme_font_size_override("font_size", 42)
    root.add_child(title)

    challenge_label = Label.new()
    challenge_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    challenge_label.add_theme_font_size_override("font_size", 20)
    root.add_child(challenge_label)

    rule_label = Label.new()
    rule_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    rule_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    rule_label.add_theme_font_size_override("font_size", 52)
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
        b.add_theme_font_size_override("font_size", 30)
        b.custom_minimum_size = Vector2(0, 240)
        b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
        b.pressed.connect(_on_choice.bind(i))
        grid.add_child(b)
        buttons.append(b)

    feedback_label = Label.new()
    feedback_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    feedback_label.add_theme_font_size_override("font_size", 30)
    feedback_label.custom_minimum_size.y = 80
    root.add_child(feedback_label)

func _show_challenge() -> void:
    var challenge: Dictionary = challenge_manager.current()
    var total := challenge_manager.challenges.size()
    var position := challenge_manager.index + 1
    var kind_key := str(challenge.get("kind_key", ""))
    challenge_label.text = "%s  %d / %d   •   %s" % [tr("CHALLENGE"), position, total, tr(kind_key)]
    rule_label.text = tr(str(challenge.get("rule_key", "")))
    streak_label.text = "%s  %d   •   %s  %d" % [tr("STREAK"), progression.streak, tr("BEST"), progression.best_streak]
    feedback_label.text = ""

    var choices: Array = challenge.get("choices", [])
    for i in buttons.size():
        buttons[i].text = tr(str(choices[i])) if i < choices.size() else "—"
        buttons[i].disabled = false

func _on_choice(choice: int) -> void:
    var correct := challenge_manager.check(choice)
    for b in buttons:
        b.disabled = true

    progression.record(correct)

    if correct:
        feedback_label.text = "%s  ✓" % tr("CORRECT")
        challenge_manager.next()
        await get_tree().create_timer(0.35).timeout
    else:
        feedback_label.text = "%s  •  %s" % [tr("WRONG"), tr("TRY_AGAIN")]
        await get_tree().create_timer(0.7).timeout

    _show_challenge()
