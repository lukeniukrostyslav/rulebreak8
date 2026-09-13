class_name ChallengeViewV2
extends Control

signal input_ready_changed(ready: bool)
signal response_window_started(started_at_ms: int, duration_ms: int)

const FAMILIES := {"KIND_SEE":1,"KIND_REMEMBER":1,"KIND_REACT":1,"KIND_SWITCH":1,"KIND_TRICK":1,"KIND_MIX":1}
const MEM := ["● → ▲ → ■","RED → BLUE → GREEN","7 → 2 → 9","TOP → RIGHT → BOTTOM","A → C → B","★ → ◆ → ✦","1 → 3 → 2 → 4","■ ○ ■ ○","A → D → B","↑ → → → ↓"]
const REACT := ["RED","BLUE","GREEN","YELLOW","●","▲","★","2","3","4","GO","SECOND","X","FINAL"]

var challenge_id := ""
var correct_index := -1
var visual_root: Control
var input_ready := false
var phase_token := 0
var response_duration_ms := 1400

func _ready()->void: mouse_filter=Control.MOUSE_FILTER_IGNORE

func supports_challenge(c:Dictionary)->bool:
    return FAMILIES.has(str(c.get("kind_key",""))) and not str(c.get("id","")).is_empty()

func show_challenge(c:Dictionary)->void:
    phase_token+=1; var token:=phase_token; _set_input_ready(false); clear_view()
    challenge_id=str(c.get("id","")); correct_index=int(c.get("correct",-1)); _new_root()
    match str(c.get("kind_key","")):
        "KIND_SEE": await _see(token)
        "KIND_REMEMBER": await _remember(token)
        "KIND_REACT": await _react(token)
        "KIND_SWITCH": await _switch(token)
        "KIND_TRICK": _trick()
        "KIND_MIX": await _mix(token)
        _: _label("UNSUPPORTED_CHALLENGE"); _set_input_ready(true)

func _new_root()->void:
    visual_root=VBoxContainer.new(); visual_root.add_theme_constant_override("separation",10)
    visual_root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); visual_root.alignment=BoxContainer.ALIGNMENT_CENTER; add_child(visual_root)

func _set_input_ready(v:bool)->void:
    input_ready=v; input_ready_changed.emit(v)
    if v and challenge_id in ["color_timer","second_signal","only_x"]: response_window_started.emit(Time.get_ticks_msec(),response_duration_ms)

func _label(key:String,size:int=30)->void:
    var l:=Label.new(); l.text=tr(key); l.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER; l.autowrap_mode=TextServer.AUTOWRAP_WORD_SMART; l.add_theme_font_size_override("font_size",size); visual_root.add_child(l)

func _card(text:String,size:int=46,height:int=82)->PanelContainer:
    var p:=PanelContainer.new(); p.custom_minimum_size=Vector2(0,height); var l:=Label.new(); l.text=text; l.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER; l.vertical_alignment=VERTICAL_ALIGNMENT_CENTER; l.add_theme_font_size_override("font_size",size); p.add_child(l); visual_root.add_child(p); return p

func _pulse(n:Control)->void:
    var t:=create_tween(); t.tween_property(n,"scale",Vector2(1.06,1.06),0.12); t.tween_property(n,"scale",Vector2.ONE,0.16)

func _see(token:int)->void:
    _label("SEE_WATCH",24)
    if challenge_id=="speed_change": await _speed(token); return
    var shapes:=["●","▲","■","◆"]
    for i in 4:
        var value:=shapes[i]
        if i==correct_index: value=["✦","◀","◐","✕"][abs(challenge_id.hash())%4]
        _card(value,52,82)
    _label("SEE_SELECT",24); _set_input_ready(true)

func _speed(token:int)->void:
    _label("SEE_SPEED",26); var cards:Array[Control]=[]
    for i in 4: cards.append(_card(str(char(65+i)),52,82))
    await get_tree().create_timer(0.45).timeout
    for i in 4:
        for j in (4 if i==correct_index else 1):
            if token!=phase_token:return
            _pulse(cards[i]); await get_tree().create_timer(0.12 if i==correct_index else 0.25).timeout
    if token==phase_token: clear_view(); _new_root(); _label("SEE_SPEED_CHOOSE",26); _card("A   B   C   D",44,82); _set_input_ready(true)

func _remember(token:int)->void:
    _label("REMEMBER_MEMORIZE",26); _pulse(_card(MEM[abs(challenge_id.hash())%MEM.size()],40,92))
    await get_tree().create_timer(1.1 if challenge_id.begins_with("remember_") else 0.9).timeout
    if token!=phase_token:return
    clear_view(); _new_root(); _label("REMEMBER_CHOOSE",30); _card("1   2   3   4",40,86); _set_input_ready(true)

func _react(token:int)->void:
    _label("REACT_WAIT",30); _card("○",72,86); await get_tree().create_timer(0.5).timeout
    if token!=phase_token:return
    var target:=REACT[correct_index]
    if challenge_id=="second_signal" or challenge_id=="react_signal_two": target="SECOND"
    elif challenge_id=="only_x" or challenge_id=="react_x_only": target="X"
    elif challenge_id=="color_timer": target="GREEN"
    clear_view(); _new_root(); _label("REACT_WATCH",26); _card(target,58,92); await get_tree().create_timer(0.25).timeout
    if token!=phase_token:return
    clear_view(); _new_root(); _label("REACT_NOW",28); _pulse(_card(target,64,96)); _set_input_ready(true)
    await get_tree().create_timer(float(response_duration_ms)/1000.0).timeout
    if token==phase_token and input_ready: _set_input_ready(false); _label("TOO_SLOW",26)

func _switch(token:int)->void:
    _label("SWITCH_RULE_ONE",24); _card(tr("SWITCH_BLUE"),40,72); await get_tree().create_timer(0.6).timeout
    if token!=phase_token:return
    clear_view(); _new_root(); _label("SWITCH_RULE_CHANGED",26); _card(_switch_new(),40,82); await get_tree().create_timer(0.4).timeout
    if token!=phase_token:return
    clear_view(); _new_root(); _label("SWITCH_CHOOSE",28); _card(["BLUE   RED   GREEN   YELLOW","●   ▲   ■   ◆","↑   →   ↓   ←","1   2   3   4"][abs(challenge_id.hash())%4],36,82); _set_input_ready(true)

func _switch_new()->String:
    return [tr("SWITCH_NEW_RULE"),tr("SWITCH_REVERSE"),tr("SWITCH_DIRECTION"),tr("SWITCH_ACTION")][abs(challenge_id.hash())%4]

func _trick()->void:
    var mode:=abs(challenge_id.hash())%4; var items:=[]
    for i in 4: items.append("EXCEPTION" if i==correct_index else ("SMALL" if mode==0 else "DECOY"))
    _card("   ".join(items),30,84); _label(["TRICK_SIZE","TRICK_FIRST_IS_DECOY","TRICK_DECOY","TRICK_LATEST"][mode],26); _set_input_ready(true)

func _mix(token:int)->void:
    _label("MIX_SEE",24); _card("●   ▲   ◆   ●",42,72); _label("MIX_NOTICE",22); await get_tree().create_timer(0.4).timeout
    if token!=phase_token:return
    clear_view(); _new_root(); _label("MIX_SWITCH",24); _card(tr("SWITCH_NEW_RULE"),36,78); await get_tree().create_timer(0.4).timeout
    if token!=phase_token:return
    clear_view(); _new_root(); _label("MIX_REACT",24); _card("WAIT → GO",42,76); _label("MIX_CHOOSE_SIGNAL",24); _card("FIRST  SECOND  THIRD  FOURTH",30,78); _set_input_ready(true)

func clear_view()->void:
    if visual_root: visual_root.queue_free(); visual_root=null
