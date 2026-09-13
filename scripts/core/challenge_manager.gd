class_name ChallengeManager
extends RefCounted

var challenges: Array[Dictionary] = [
    {"id":"see_change","rule":"FIND THE CHANGED SHAPE","choices":["A","B","C","D"],"correct":0,"kind":"SEE"},
    {"id":"remember_positions","rule":"REMEMBER THE ORIGINAL POSITION","choices":["TOP","RIGHT","BOTTOM","LEFT"],"correct":1,"kind":"REMEMBER"},
    {"id":"sequence","rule":"REPEAT THE SEQUENCE","choices":["▲ ● ■","● ■ ▲","■ ▲ ●","● ▲ ■"],"correct":0,"kind":"REMEMBER"},
    {"id":"reverse_sequence","rule":"REPEAT IT IN REVERSE","choices":["■ ● ▲","▲ ● ■","● ▲ ■","■ ▲ ●"],"correct":0,"kind":"REMEMBER"},
    {"id":"color_timer","rule":"TAP THE CORRECT COLOR","choices":["BLUE","RED","GREEN","YELLOW"],"correct":2,"kind":"REACT"},
    {"id":"second_signal","rule":"IGNORE THE FIRST SIGNAL","choices":["FIRST","SECOND","BOTH","NONE"],"correct":1,"kind":"REACT"},
    {"id":"rule_switch","rule":"FIRST: TAP BLUE. THEN: TAP RED.","choices":["BLUE","RED","GREEN","YELLOW"],"correct":1,"kind":"SWITCH"},
    {"id":"sound_switch","rule":"WHEN THE RULE CHANGES, SWITCH","choices":["KEEP OLD RULE","SWITCH RULE","DO NOTHING","TAP TWICE"],"correct":1,"kind":"SWITCH"},
    {"id":"word_color","rule":"TAP THE WORD, NOT THE COLOR","choices":["WORD","COLOR","BOTH","NONE"],"correct":0,"kind":"TRICK"},
    {"id":"largest_wrong","rule":"THE LARGEST SHAPE IS WRONG","choices":["SMALLEST","LEFT","LARGEST","RIGHT"],"correct":0,"kind":"TRICK"},
    {"id":"speed_change","rule":"FIND THE OBJECT MOVING DIFFERENTLY","choices":["A","B","C","D"],"correct":2,"kind":"SEE"},
    {"id":"order_memory","rule":"CHOOSE THE ORIGINAL ORDER","choices":["1-2-3","2-1-3","3-2-1","1-3-2"],"correct":0,"kind":"REMEMBER"},
    {"id":"only_x","rule":"TAP ONLY WHEN X APPEARS","choices":["X","O","△","□"],"correct":0,"kind":"REACT"},
    {"id":"no_repeat","rule":"DO NOT REPEAT YOUR LAST ACTION","choices":["LEFT","RIGHT","LEFT AGAIN","NONE"],"correct":1,"kind":"SWITCH"},
    {"id":"dont_press","rule":"DO NOT PRESS THE BUTTON","choices":["PRESS IT","WAIT","LEAVE","PRESS TWICE"],"correct":1,"kind":"TRICK"},
    {"id":"mirrored","rule":"FIND THE MIRRORED SHAPE","choices":["A","B","C","D"],"correct":3,"kind":"SEE"},
    {"id":"vanishing_rule","rule":"REMEMBER THIS RULE","choices":["TAP A","TAP B","TAP C","TAP D"],"correct":2,"kind":"REMEMBER"},
    {"id":"instruction_change","rule":"THE INSTRUCTION CHANGES DURING THE ROUND","choices":["FOLLOW NEW","FOLLOW OLD","IGNORE BOTH","TAP ALL"],"correct":0,"kind":"SWITCH"},
    {"id":"obvious_wrong","rule":"THE OBVIOUS ANSWER IS WRONG","choices":["OBVIOUS","SECOND","THIRD","FOURTH"],"correct":1,"kind":"TRICK"},
    {"id":"mixed","rule":"SEE IT. SWITCH. REACT.","choices":["A","B","C","D"],"correct":2,"kind":"MIX"}
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
