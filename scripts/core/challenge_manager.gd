class_name ChallengeManager
extends RefCounted

var challenges: Array[Dictionary] = [
    {"id":"blue", "rule":"TAP BLUE", "choices":["BLUE","RED","GREEN","YELLOW"], "correct":0, "kind":"SWITCH"},
    {"id":"red", "rule":"TAP RED", "choices":["BLUE","RED","GREEN","YELLOW"], "correct":1, "kind":"SWITCH"},
    {"id":"largest", "rule":"TAP THE LARGEST", "choices":["SMALLEST","LEFT","LARGEST","RIGHT"], "correct":2, "kind":"TRICK"},
    {"id":"word", "rule":"TAP THE WORD, NOT THE COLOR", "choices":["WORD","COLOR","BOTH","NONE"], "correct":0, "kind":"TRICK"},
    {"id":"second_signal", "rule":"IGNORE THE FIRST SIGNAL", "choices":["FIRST","SECOND","BOTH","NONE"], "correct":1, "kind":"REACT"},
    {"id":"no_repeat", "rule":"DO NOT REPEAT YOUR LAST ACTION", "choices":["LEFT","RIGHT","LEFT AGAIN","NONE"], "correct":1, "kind":"SWITCH"},
    {"id":"mirror", "rule":"FIND THE MIRRORED SHAPE", "choices":["A","B","C","D"], "correct":0, "kind":"SEE"},
    {"id":"obvious_wrong", "rule":"THE OBVIOUS ANSWER IS WRONG", "choices":["OBVIOUS","SECOND","THIRD","FOURTH"], "correct":1, "kind":"TRICK"}
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
