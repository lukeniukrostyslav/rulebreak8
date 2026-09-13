class_name ChallengeManager
extends RefCounted

var challenges: Array[Dictionary] = [
    {"id":"see_change","rule_key":"RULE_SEE_CHANGE","choices":["A","B","C","D"],"correct":0,"kind_key":"KIND_SEE"},
    {"id":"remember_positions","rule_key":"RULE_REMEMBER_POS","choices":["TOP","RIGHT","BOTTOM","LEFT"],"correct":1,"kind_key":"KIND_REMEMBER"},
    {"id":"sequence","rule_key":"RULE_SEQUENCE","choices":["▲ ● ■","● ■ ▲","■ ▲ ●","● ▲ ■"],"correct":0,"kind_key":"KIND_REMEMBER"},
    {"id":"reverse_sequence","rule_key":"RULE_REVERSE","choices":["■ ● ▲","▲ ● ■","● ▲ ■","■ ▲ ●"],"correct":0,"kind_key":"KIND_REMEMBER"},
    {"id":"color_timer","rule_key":"RULE_COLOR","choices":["BLUE","RED","GREEN","YELLOW"],"correct":2,"kind_key":"KIND_REACT"},
    {"id":"second_signal","rule_key":"RULE_SECOND","choices":["FIRST","SECOND","BOTH","NONE"],"correct":1,"kind_key":"KIND_REACT"},
    {"id":"rule_switch","rule_key":"RULE_SWITCH","choices":["BLUE","RED","GREEN","YELLOW"],"correct":1,"kind_key":"KIND_SWITCH"},
    {"id":"sound_switch","rule_key":"RULE_SOUND_SWITCH","choices":["KEEP_OLD","SWITCH_RULE","DO_NOTHING","TAP_TWICE"],"correct":1,"kind_key":"KIND_SWITCH"},
    {"id":"word_color","rule_key":"RULE_WORD","choices":["WORD","COLOR","BOTH","NONE"],"correct":0,"kind_key":"KIND_TRICK"},
    {"id":"largest_wrong","rule_key":"RULE_LARGEST_WRONG","choices":["SMALLEST","LEFT","LARGEST","RIGHT"],"correct":0,"kind_key":"KIND_TRICK"},
    {"id":"speed_change","rule_key":"RULE_SPEED","choices":["A","B","C","D"],"correct":2,"kind_key":"KIND_SEE"},
    {"id":"order_memory","rule_key":"RULE_ORDER","choices":["1-2-3","2-1-3","3-2-1","1-3-2"],"correct":0,"kind_key":"KIND_REMEMBER"},
    {"id":"only_x","rule_key":"RULE_X","choices":["X","O","△","□"],"correct":0,"kind_key":"KIND_REACT"},
    {"id":"no_repeat","rule_key":"RULE_NO_REPEAT","choices":["LEFT","RIGHT","LEFT","NONE"],"correct":1,"kind_key":"KIND_SWITCH"},
    {"id":"dont_press","rule_key":"RULE_DONT_PRESS","choices":["PRESS_IT","WAIT","LEAVE","PRESS_TWICE"],"correct":1,"kind_key":"KIND_TRICK"},
    {"id":"mirrored","rule_key":"RULE_MIRROR","choices":["A","B","C","D"],"correct":3,"kind_key":"KIND_SEE"},
    {"id":"vanishing_rule","rule_key":"RULE_VANISH","choices":["TAP_A","TAP_B","TAP_C","TAP_D"],"correct":2,"kind_key":"KIND_REMEMBER"},
    {"id":"instruction_change","rule_key":"RULE_INSTRUCTION","choices":["FOLLOW_NEW","FOLLOW_OLD","IGNORE_BOTH","TAP_ALL"],"correct":0,"kind_key":"KIND_SWITCH"},
    {"id":"obvious_wrong","rule_key":"RULE_OBVIOUS","choices":["OBVIOUS","SECOND","THIRD","FOURTH"],"correct":1,"kind_key":"KIND_TRICK"},
    {"id":"mixed","rule_key":"RULE_MIX","choices":["A","B","C","D"],"correct":2,"kind_key":"KIND_MIX"}
]

var index := 0

func current() -> Dictionary:
    return challenges[index]

func next() -> Dictionary:
    index = (index + 1) % challenges.size()
    return current()

func reset() -> void:
    index = 0

func check(choice: int) -> bool:
    return choice == int(current().get("correct", -1))
