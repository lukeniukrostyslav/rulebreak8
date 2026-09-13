class_name ChallengeManager
extends RefCounted

var challenges: Array[Dictionary] = [
    {"id":"switch_blue", "rule":"TAP BLUE", "correct":0, "kind":"SWITCH"},
    {"id":"switch_red", "rule":"TAP RED", "correct":1, "kind":"SWITCH"},
    {"id":"largest", "rule":"TAP THE LARGEST", "correct":2, "kind":"TRICK"},
    {"id":"word", "rule":"TAP THE WORD, NOT THE COLOR", "correct":3, "kind":"TRICK"},
    {"id":"ignore_first", "rule":"IGNORE THE FIRST SIGNAL", "correct":1, "kind":"REACT"},
    {"id":"no_repeat", "rule":"DO NOT REPEAT YOUR LAST ACTION", "correct":2, "kind":"SWITCH"},
    {"id":"mirror", "rule":"FIND THE MIRRORED SHAPE", "correct":0, "kind":"SEE"},
    {"id":"obvious_wrong", "rule":"THE OBVIOUS ANSWER IS WRONG", "correct":3, "kind":"TRICK"}
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
