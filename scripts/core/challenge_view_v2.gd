class_name ChallengeViewV2
extends Control

signal input_ready_changed(ready: bool)
signal response_window_started(started_at_ms: int, duration_ms: int)

const FAMILIES := {"KIND_SEE":1,"KIND_REMEMBER":1,"KIND_REACT":1,"KIND_SWITCH":1,"KIND_TRICK":1,"KIND_MIX":1}
const MEM := ["● → ▲ → ■","RED → BLUE → GREEN","7 → 2 → 9","TOP → RIGHT → BOTTOM","A → C → B","★ → ◆ → ✦","1 → 3 → 2 → 4","■ ○ ■ ○","A → D → B","↑ → → → ↓"]
const REACT := ["RED","BLUE","GREEN","YELLOW","●","▲","★","2","3","4","GO","SECOND","X","FINAL"]
const SEE_SHAPES := ["●","▲","■","◆"]
const DIRECTIONS := ["↑","→","↓","←"]
const COLORS := ["RED","BLUE","GREEN","YELLOW"]

var challenge_id := ""
var correct_index := -1
var visual_root: Control
var input_ready := false
var phase_token := 0
var response_duration_ms := 1400

func _ready()->void:
    mouse_filter=Control.MOUSE_FILTER_IGNORE

func supports_challenge(c:Dictionary)->bool:
    return FAMILIES.has(str(c.get("kind_key",""))) and not str(c.get("id","")).is_empty()

func show_challenge(c: Dictionary) -> void:
    phase_token += 1
    var token: int = phase_token
    _set_input_ready(false)
    clear_view()
    challenge_id = str(c.get("id", ""))
    correct_index = int(c.get("correct", -1))
    _new_root()
    match str(c.get("kind_key", "")):
        "KIND_SEE": await _see(token)
        "KIND_REMEMBER": await _remember(token)
        "KIND_REACT": await _react(token)
        "KIND_SWITCH": await _switch(token)
        "KIND_TRICK": _trick()
        "KIND_MIX": await _mix(token)
        _: _label("UNSUPPORTED_CHALLENGE"); _set_input_ready(false)

func _new_root() -> void:
    visual_root = VBoxContainer.new()
    visual_root.add_theme_constant_override("separation", 10)
    visual_root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    visual_root.alignment = BoxContainer.ALIGNMENT_CENTER
    add_child(visual_root)

func _set_input_ready(v:bool)->void:
    input_ready=v
    input_ready_changed.emit(v)
    if v and (challenge_id.begins_with("react_") or challenge_id in ["color_timer","second_signal","only_x","mix_see_react","mix_trick_react","mix_full"]):
        response_window_started.emit(Time.get_ticks_msec(),response_duration_ms)

func _label(key:String,size:int=30)->void:
    var l:=Label.new()
    l.text=tr(key)
    l.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
    l.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
    l.add_theme_font_size_override("font_size",size)
    visual_root.add_child(l)

func _plain_label(text:String,size:int=30)->void:
    var l:=Label.new()
    l.text=text
    l.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
    l.vertical_alignment=VERTICAL_ALIGNMENT_CENTER
    l.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART
    l.add_theme_font_size_override("font_size",size)
    visual_root.add_child(l)

func _card(text:String,size:int=46,height:int=82)->PanelContainer:
    var p:=PanelContainer.new()
    p.custom_minimum_size=Vector2(0,height)
    var l:=Label.new()
    l.text=text
    l.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
    l.vertical_alignment=VERTICAL_ALIGNMENT_CENTER
    l.add_theme_font_size_override("font_size",size)
    p.add_child(l)
    visual_root.add_child(p)
    return p

func _colored_card(text:String,size:int,color:Color)->PanelContainer:
    var p:=PanelContainer.new()
    p.custom_minimum_size=Vector2(0,82)
    var l:=Label.new()
    l.text=text
    l.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
    l.vertical_alignment=VERTICAL_ALIGNMENT_CENTER
    l.add_theme_font_size_override("font_size",size)
    l.add_theme_color_override("font_color",color)
    p.add_child(l)
    visual_root.add_child(p)
    return p

func _pulse(n:Control)->void:
    var t:=create_tween()
    t.tween_property(n,"scale",Vector2(1.06,1.06),0.12)
    t.tween_property(n,"scale",Vector2.ONE,0.16)

func _see(token:int)->void:
    _label("SEE_WATCH",24)
    if challenge_id=="speed_change":
        await _speed(token)
        return
    if challenge_id=="see_color_change":
        _label("SEE_SELECT",24)
        for i in 4:
            _colored_card(COLORS[i],38,Color("F4F6FA") if i!=correct_index else Color("FFD166"))
        _set_input_ready(true)
        return
    if challenge_id in ["see_direction","see_angle_change"]:
        for i in 4:
            var value: String = DIRECTIONS[i]
            if i==correct_index:
                value=DIRECTIONS[(i+1)%4]
            _card(value,58,82)
        _label("SEE_SELECT",24)
        _set_input_ready(true)
        return
    if challenge_id in ["see_size_change","see_duplicate","see_spacing","see_pattern_break"]:
        for i in 4:
            var value: String = SEE_SHAPES[i]
            var size := 52
            if challenge_id=="see_size_change" and i==correct_index:
                size=72
            elif challenge_id=="see_duplicate" and i==correct_index:
                value=SEE_SHAPES[(i+1)%4]
            elif challenge_id=="see_spacing" and i==correct_index:
                value="%s    %s" % [value,value]
            elif challenge_id=="see_pattern_break" and i==correct_index:
                value="✦"
            _card(value,size,82)
        _label("SEE_SELECT",24)
        _set_input_ready(true)
        return
    if challenge_id in ["see_filled_shape","see_outline_break","see_missing_edge","mirrored"]:
        var values:= ["●","○","■","□"]
        for i in 4:
            var value: String = values[i]
            if challenge_id=="see_filled_shape" and i==correct_index:
                value="◆"
            elif challenge_id=="see_outline_break" and i==correct_index:
                value="◆"
            elif challenge_id=="see_missing_edge" and i==correct_index:
                value="◢"
            elif challenge_id=="mirrored" and i==correct_index:
                value="◀"
            _card(value,58,82)
        _label("SEE_SELECT",24)
        _set_input_ready(true)
        return
    var shapes:=SEE_SHAPES.duplicate()
    for i in 4:
        var value: String = shapes[i]
        if i==correct_index:
            value=["✦","◀","◐","✕"][abs(challenge_id.hash())%4]
        _card(value,52,82)
    _label("SEE_SELECT",24)
    _set_input_ready(true)

func _speed(token:int)->void:
    _label("SEE_SPEED",26)
    var cards:Array[Control]=[]
    for i in 4:
        cards.append(_card(str(char(65+i)),52,82))
    await get_tree().create_timer(0.45).timeout
    for i in 4:
        for j in (4 if i==correct_index else 1):
            if token!=phase_token:return
            _pulse(cards[i])
            await get_tree().create_timer(0.12 if i==correct_index else 0.25).timeout
    if token==phase_token:
        clear_view()
        _new_root()
        _label("SEE_SPEED_CHOOSE",26)
        _card("A   B   C   D",44,82)
        _set_input_ready(true)

func _remember(token:int)->void:
    var memory_text := _memory_sequence()
    _label("REMEMBER_MEMORIZE",26)
    _card(memory_text,40,96)
    if challenge_id=="vanishing_rule":
        await get_tree().create_timer(1.35).timeout
        if token!=phase_token:return
        clear_view()
        _new_root()
        _label("REMEMBER_RULE_GONE",28)
        _card("?   ?   ?",44,86)
    else:
        await get_tree().create_timer(1.1 if challenge_id.begins_with("remember_") else 0.9).timeout
        if token!=phase_token:return
        clear_view()
        _new_root()
        _label("REMEMBER_CHOOSE",30)
        _card("1   2   3   4",40,86)
    _set_input_ready(true)

func _memory_sequence()->String:
    match challenge_id:
        "remember_colors": return "RED  →  BLUE  →  GREEN"
        "remember_shapes": return "●  →  ▲  →  ■"
        "remember_numbers": return "7  →  2  →  9"
        "remember_corners": return "TOP-LEFT  →  BOTTOM-RIGHT  →  TOP-RIGHT"
        "remember_direction": return "↑  →  →  →  ↓"
        "remember_pairs": return "A1  →  B2  →  C3"
        "remember_lights": return "●  →  ●●  →  ●●●"
        "remember_symbols": return "★  →  ◆  →  ✦"
        "remember_path": return "A  →  C  →  B  →  D"
        "remember_slots": return "1  →  3  →  4"
        "remember_tones": return "LOW  →  HIGH  →  LOW"
        "remember_letters": return "A  →  D  →  B"
        "remember_icons": return "★  →  ◆  →  ●"
        "remember_positions_2": return "TOP  →  RIGHT  →  BOTTOM  →  LEFT"
        "remember_order_2": return "1  →  3  →  2  →  4"
        "order_memory": return "1  →  2  →  3"
        "sequence": return "▲  →  ●  →  ■"
        "reverse_sequence": return "■  →  ●  →  ▲"
        _: return MEM[abs(challenge_id.hash())%MEM.size()]

func _react(token:int)->void:
    while token==phase_token:
        _label("REACT_WAIT",30)
        _card("○",72,86)
        await get_tree().create_timer(0.5).timeout
        if token!=phase_token:return
        var target: String = _react_target()
        clear_view()
        _new_root()
        _label("REACT_WATCH",26)
        _card(target,58,92)
        await get_tree().create_timer(0.25).timeout
        if token!=phase_token:return
        clear_view()
        _new_root()
        _label("REACT_NOW",28)
        _pulse(_card(target,64,96))
        _set_input_ready(true)
        await get_tree().create_timer(float(response_duration_ms)/1000.0).timeout
        if token!=phase_token:return
        if input_ready:
            _set_input_ready(false)
            _label("TOO_SLOW",26)
            await get_tree().create_timer(0.45).timeout
            if token!=phase_token:return
        else:
            return

func _switch(token:int)->void:
    _label("SWITCH_RULE_ONE",24)
    _card(_switch_old(),40,72)
    await get_tree().create_timer(0.6).timeout
    if token!=phase_token:return
    clear_view()
    _new_root()
    _label("SWITCH_RULE_CHANGED",26)
    _card(_switch_new(),40,82)
    await get_tree().create_timer(0.4).timeout
    if token!=phase_token:return
    clear_view()
    _new_root()
    _label("SWITCH_CHOOSE",28)
    _card(_switch_choices_preview(),36,82)
    _set_input_ready(true)

func _switch_old()->String:
    match challenge_id:
        "switch_color": return "BLUE"
        "switch_direction", "switch_direction_two": return "UP"
        "switch_number": return "1"
        "switch_shape": return "●"
        "switch_action": return "TAP"
        "switch_timing": return "FAST"
        "switch_reverse": return "FORWARD"
        "switch_target": return "SHAPE"
        "switch_after_two", "switch_after_three": return "FIRST RULE"
        "switch_after_signal": return "OLD_RULE"
        "switch_instruction": return "OLD INSTRUCTION"
        "switch_second_rule": return "RULE ONE"
        "switch_final": return "INTERMEDIATE RULE"
        "sound_switch": return "KEEP OLD"
        "no_repeat": return "ALLOW REPEAT"
        "rule_switch": return tr("SWITCH_RULE")
        _: return tr("SWITCH_RULE")

func _react_target() -> String:
    match challenge_id:
        "second_signal", "react_signal_two": return "SECOND"
        "only_x", "react_x_only": return "X"
        "color_timer", "react_green_twice": return "GREEN"
        "react_circle": return "●"
        "react_triangle": return "▲"
        "react_star": return "★"
        "react_even": return "SECOND"
        "react_third": return "THIRD"
        "react_fourth": return "FOURTH"
        "react_after_change": return "AFTER"
        "react_late": return "LATE"
        "react_final": return "FINAL"
        _: return REACT[correct_index] if correct_index >= 0 and correct_index < REACT.size() else "GO"

func _switch_choices_preview() -> String:
    match challenge_id:
        "switch_color": return "BLUE   RED   GREEN   YELLOW"
        "switch_direction", "switch_direction_two": return "UP   RIGHT   DOWN   LEFT"
        "switch_shape": return "●   ▲   ■   ◆"
        "switch_number": return "1   2   3   4"
        "switch_action": return "TAP   HOLD   SWIPE   WAIT"
        "switch_timing": return "FAST   SLOW   NOW   WAIT"
        "switch_reverse": return "FORWARD   REVERSE   SAME   NONE"
        "switch_target": return "SHAPE   COLOR   NUMBER   DIRECTION"
        "switch_after_two", "switch_after_three": return "FIRST   SECOND   THIRD   FOURTH"
        "switch_after_signal", "switch_instruction", "switch_final": return "OLD_RULE   NEW_RULE   IGNORE   WAIT"
        "switch_second_rule": return "RULE_ONE   RULE_TWO   RULE_THREE   RULE_FOUR"
        "sound_switch": return "KEEP_OLD   SWITCH_RULE   DO_NOTHING   TAP_TWICE"
        "no_repeat": return "LEFT   RIGHT   UP   NONE"
        "rule_switch": return "BLUE   RED   GREEN   YELLOW"
        _: return "BLUE   RED   GREEN   YELLOW"

func _switch_new()->String:
    match challenge_id:
        "switch_color": return "RED"
        "switch_direction", "switch_direction_two": return "SWITCH DIRECTION"
        "switch_shape": return "● → ▲"
        "switch_number": return "1 → 2"
        "switch_action": return "SWITCH ACTION"
        "switch_timing": return "SLOW"
        "switch_reverse": return "REVERSE"
        "switch_target": return "COLOR"
        "switch_after_two", "switch_after_three": return "SECOND RULE"
        "switch_after_signal": return "NEW_RULE"
        "switch_instruction": return "FOLLOW NEW INSTRUCTION"
        "switch_second_rule": return "RULE TWO"
        "switch_final": return "FINAL RULE"
        "sound_switch": return "SWITCH RULE"
        "no_repeat": return "NO REPEAT"
        "rule_switch": return tr("SWITCH_RULE")
        _: return tr("SWITCH_RULE")

func _trick()->void:
    match challenge_id:
        "word_color", "trick_word":
            _label("TRICK_WORD_RULE",26)
            _card("RED",52,86)
            _plain_label("BLUE",42)
            _set_input_ready(true)
            return
        "trick_color":
            _label("TRICK_COLOR_RULE",26)
            _colored_card("RED",52,Color("3A86FF"))
            _plain_label("BLUE",42)
            _set_input_ready(true)
            return
        "largest_wrong", "trick_smallest", "trick_not_largest":
            _label("TRICK_NOT_LARGEST",26)
            _card("●   ●●   ●●●●   ●●",42,86)
            _label("TRICK_CHOOSE",24)
            _set_input_ready(true)
            return
        "dont_press", "trick_forbidden", "trick_hidden":
            _label("TRICK_FORBIDDEN",26)
            _card("DO NOT PRESS",38,86)
            _label("TRICK_EXCEPTION",24)
            _set_input_ready(true)
            return
        "obvious_wrong", "trick_second", "trick_reverse", "trick_obvious_two":
            _label("TRICK_OBVIOUS",26)
            _card("OBVIOUS   •   EXCEPTION   •   DECOY   •   SAFE",26,90)
            _set_input_ready(true)
            return
    var mode: int = abs(challenge_id.hash()) % 4
    var items: Array[String] = []
    for i in 4:
        items.append("EXCEPTION" if i==correct_index else ("SMALL" if mode==0 else "DECOY"))
    _card("   ".join(items),30,84)
    _label(["TRICK_SIZE","TRICK_FIRST_IS_DECOY","TRICK_DECOY","TRICK_LATEST"][mode],26)
    _set_input_ready(true)

func _mix(token:int)->void:
    match challenge_id:
        "mixed":
            _label("MIX_SEE",24)
            _card("●   ▲   ◆   ●",42,72)
            await get_tree().create_timer(0.35).timeout
            if token!=phase_token:return
            clear_view(); _new_root()
            _label("KIND_SWITCH",24)
            _card("RULE CHANGED",36,78)
            await get_tree().create_timer(0.35).timeout
            if token!=phase_token:return
            clear_view(); _new_root()
            _label("MIX_REACT",24)
            _card("WAIT → GO",42,76)
            _label("MIX_CHOOSE_SIGNAL",22)
            _card("FIRST  SECOND  THIRD  FOURTH",30,78)
            _set_input_ready(true)
            return
        "mix_memory_switch":
            _label("KIND_REMEMBER",24)
            _card("●  →  ▲  →  ■",40,82)
            await get_tree().create_timer(0.65).timeout
            if token!=phase_token:return
            clear_view(); _new_root()
            _label("KIND_SWITCH",24)
            _card("SHAPE → POSITION",36,78)
            await get_tree().create_timer(0.45).timeout
            if token!=phase_token:return
            clear_view(); _new_root()
            _label("REMEMBER_CHOOSE",24)
            _card("FIRST  SECOND  THIRD  FOURTH",30,78)
            _set_input_ready(true)
            return
        "mix_see_react":
            _label("MIX_SEE",24)
            _card("●   ▲   ◆   ●",42,72)
            _label("MIX_NOTICE",22)
            await get_tree().create_timer(0.45).timeout
            if token!=phase_token:return
            clear_view(); _new_root()
            _label("MIX_REACT",24)
            _card("WAIT → GO",42,76)
            _label("MIX_CHOOSE_SIGNAL",24)
            _card("FIRST  SECOND  THIRD  FOURTH",30,78)
            _set_input_ready(true)
            return
        "mix_trick_react":
            _label("KIND_TRICK",24)
            _card("DECOY   •   SIGNAL   •   DECOY   •   SAFE",27,84)
            await get_tree().create_timer(0.5).timeout
            if token!=phase_token:return
            clear_view(); _new_root()
            _label("MIX_REACT",24)
            _card("IGNORE DECOY → GO",34,78)
            _label("MIX_CHOOSE_SIGNAL",24)
            _card("FIRST  SECOND  THIRD  FOURTH",30,78)
            _set_input_ready(true)
            return
        "mix_switch_memory":
            _label("KIND_SWITCH",24)
            _card("RULE A",38,78)
            await get_tree().create_timer(0.45).timeout
            if token!=phase_token:return
            clear_view(); _new_root()
            _label("SWITCH_RULE_CHANGED",24)
            _card("RULE B",38,78)
            await get_tree().create_timer(0.45).timeout
            if token!=phase_token:return
            clear_view(); _new_root()
            _label("KIND_REMEMBER",24)
            _card("TARGET: SECOND",34,78)
            _label("REMEMBER_CHOOSE",22)
            _card("FIRST  SECOND  THIRD  FOURTH",30,78)
            _set_input_ready(true)
            return
        "mix_full":
            _label("MIX_SEE",24)
            _card("●   ▲   ◆   ●",40,72)
            await get_tree().create_timer(0.35).timeout
            if token!=phase_token:return
            clear_view(); _new_root()
            _label("KIND_REMEMBER",24)
            _card("● → ▲ → ■",36,78)
            await get_tree().create_timer(0.55).timeout
            if token!=phase_token:return
            clear_view(); _new_root()
            _label("KIND_SWITCH",24)
            _card("RULE CHANGED",36,78)
            await get_tree().create_timer(0.45).timeout
            if token!=phase_token:return
            clear_view(); _new_root()
            _label("MIX_REACT",24)
            _card("WAIT → GO",42,76)
            _label("MIX_CHOOSE_SIGNAL",22)
            _card("FIRST  SECOND  THIRD  FOURTH",30,78)
            _set_input_ready(true)
            return
        _:
            _label("MIX_SEE",24)
            _card("●   ▲   ◆   ●",42,72)
            await get_tree().create_timer(0.4).timeout
            if token!=phase_token:return
            clear_view(); _new_root()
            _label("KIND_SWITCH",24)
            _card(tr("SWITCH_RULE"),36,78)
            await get_tree().create_timer(0.4).timeout
            if token!=phase_token:return
            clear_view(); _new_root()
            _label("MIX_REACT",24)
            _card("WAIT → GO",42,76)
            _label("MIX_CHOOSE_SIGNAL",24)
            _card("FIRST  SECOND  THIRD  FOURTH",30,78)
            _set_input_ready(true)

func clear_view()->void:
    if visual_root:
        visual_root.queue_free()
        visual_root = null
