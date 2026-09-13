class_name ChallengeManager
extends RefCounted

# Deterministic, offline-first seed catalog. Each challenge is self-contained so
# the game can be tested without a backend or network dependency.
var challenges: Array[Dictionary] = [
    {"id":"see_change","rule":"FIND THE CHANGED ONE","choices":["A","B","C","D"],"correct":0,"kind":"SEE"},
    {"id":"remember_positions","rule":"REMEMBER: B IS THE ANSWER","choices":["A","B","C","D"],"correct":1,"kind":"REMEMBER"},
    {"id":"sequence","rule":"REPEAT: 2 → 4 → 1","choices":["1-2-4","2-4-1","4-1-2","2-1-4"],"correct":1,"kind":"REMEMBER"},
    {"id":"reverse_sequence","rule":"REPEAT IN REVERSE: 1 → 3 → 4","choices":["4-3-1","1-3-4","3-4-1","4-1-3"],"correct":0,"kind":"REMEMBER"},
    {"id":"color_timer","rule":"TAP THE BLUE SIGNAL","choices":["BLUE","RED","GREEN","YELLOW"],"correct":0,"kind":"REACT"},
    {"id":"second_signal","rule":"IGNORE THE FIRST SIGNAL","choices":["FIRST","SECOND","BOTH","NONE"],"correct":1,"kind":"REACT"},
    {"id":"rule_switch","rule":"AFTER 3: TAP RED","choices":["BLUE","RED","GREEN","YELLOW"],"correct":1,"kind":"SWITCH"},
    {"id":"sound_switch","rule":"WHEN THE RULE SWITCHES: TAP GREEN","choices":["BLUE","RED","GREEN","YELLOW"],"correct":2,"kind":"SWITCH"},
    {"id":"word_color","rule":"TAP THE WORD, NOT THE COLOR","choices":["WORD","COLOR","BOTH","NONE"],"correct":0,"kind":"TRICK"},
    {"id":"largest_wrong","rule":"THE LARGEST IS WRONG — CHOOSE SECOND","choices":["LARGEST","SECOND","THIRD","SMALLEST"],"correct":1,"kind":"TRICK"},
    {"id":"speed_change","rule":"FIND THE DIFFERENT SPEED","choices":["A","B","C","D"],"correct":2,"kind":"SEE"},
    {"id":"order_memory","rule":"ORIGINAL ORDER: C → A → D","choices":["C-A-D","A-C-D","D-A-C","C-D-A"],"correct":0,"kind":"REMEMBER"},
    {"id":"only_x","rule":"TAP ONLY WHEN X APPEARS","choices":["X","O","+","—"],"correct":0,"kind":"REACT"},
    {"id":"no_repeat","rule":"DO NOT REPEAT YOUR LAST ACTION","choices":["LEFT","RIGHT","LEFT AGAIN","NONE"],"correct":1,"kind":"SWITCH"},
    {"id":"dont_press","rule":"DON'T PRESS IT — EXCEPT NOW","choices":["PRESS","WAIT","NONE","BACK"],"correct":0,"kind":"TRICK"},
    {"id":"mirrored","rule":"FIND THE MIRRORED SHAPE","choices":["A","B","C","D"],"correct":3,"kind":"SEE"},
    {"id":"vanishing_rule","rule":"REMEMBER: CHOOSE D","choices":["A","B","C","D"],"correct":3,"kind":"REMEMBER"},
    {"id":"instruction_change","rule":"RULE CHANGED: TAP YELLOW","choices":["BLUE","RED","GREEN","YELLOW"],"correct":3,"kind":"SWITCH"},
    {"id":"obvious_wrong","rule":"THE OBVIOUS ANSWER IS WRONG","choices":["OBVIOUS","SECOND","THIRD","FOURTH"],"correct":1,"kind":"TRICK"},
    {"id":"mixed","rule":"SEE → SWITCH → REACT: TAP GREEN","choices":["BLUE","RED","GREEN","YELLOW"],"correct":2,"kind":"MIX"}
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
