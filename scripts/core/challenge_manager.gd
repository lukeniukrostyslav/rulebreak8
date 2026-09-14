class_name ChallengeManager
extends RefCounted

var index: int = 0

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
    {"id":"no_repeat","rule_key":"RULE_NO_REPEAT","choices":["LEFT","RIGHT","UP","NONE"],"correct":1,"kind_key":"KIND_SWITCH"},
    {"id":"dont_press","rule_key":"RULE_DONT_PRESS","choices":["PRESS_IT","WAIT","LEAVE","PRESS_TWICE"],"correct":1,"kind_key":"KIND_TRICK"},
    {"id":"mirrored","rule_key":"RULE_MIRROR","choices":["A","B","C","D"],"correct":3,"kind_key":"KIND_SEE"},
    {"id":"vanishing_rule","rule_key":"RULE_VANISH","choices":["TAP_A","TAP_B","TAP_C","TAP_D"],"correct":2,"kind_key":"KIND_REMEMBER"},
    {"id":"instruction_change","rule_key":"RULE_INSTRUCTION","choices":["FOLLOW_NEW","FOLLOW_OLD","IGNORE_BOTH","TAP_ALL"],"correct":0,"kind_key":"KIND_SWITCH"},
    {"id":"obvious_wrong","rule_key":"RULE_OBVIOUS","choices":["OBVIOUS","SECOND","THIRD","FOURTH"],"correct":1,"kind_key":"KIND_TRICK"},
    {"id":"mixed","rule_key":"RULE_MIX","choices":["FIRST","SECOND","THIRD","FOURTH"],"correct":2,"kind_key":"KIND_MIX"}
]

func _init() -> void:
    _append_extended_levels()
    _normalize_index()

func _append_extended_levels() -> void:
    var specs := [
        ["SEE", "see_shape_shift", "Find the shape that changed direction.", 1], ["SEE", "see_missing_edge", "Find the shape missing one edge.", 3], ["SEE", "see_rotation", "Find the rotated symbol.", 2], ["SEE", "see_size_change", "Find the only object with a different size.", 0], ["SEE", "see_pattern_break", "Find the object that breaks the pattern.", 2], ["SEE", "see_odd_symbol", "Find the only symbol from a different set.", 1], ["SEE", "see_position_shift", "Find the object in the wrong position.", 3], ["SEE", "see_filled_shape", "Find the only filled shape.", 0], ["SEE", "see_outline_break", "Find the only outlined object.", 2], ["SEE", "see_angle_change", "Find the object with a changed angle.", 1], ["SEE", "see_duplicate", "Find the duplicated shape.", 3], ["SEE", "see_color_change", "Find the object with a changed color.", 0], ["SEE", "see_spacing", "Find the object with different spacing.", 2], ["SEE", "see_direction", "Find the object pointing the wrong way.", 1], ["SEE", "see_symmetry", "Find the object that breaks symmetry.", 3],
        ["REMEMBER", "remember_colors", "Remember the three-color order.", 0], ["REMEMBER", "remember_shapes", "Remember the shape order.", 1], ["REMEMBER", "remember_numbers", "Remember three numbers in order.", 2], ["REMEMBER", "remember_corners", "Remember the occupied corners.", 0], ["REMEMBER", "remember_direction", "Remember the direction sequence.", 1], ["REMEMBER", "remember_pairs", "Remember the matching pair order.", 2], ["REMEMBER", "remember_lights", "Remember which lights appeared.", 3], ["REMEMBER", "remember_symbols", "Remember the symbol sequence.", 1], ["REMEMBER", "remember_path", "Remember the path.", 2], ["REMEMBER", "remember_slots", "Remember the filled slots.", 0], ["REMEMBER", "remember_tones", "Remember the tone order.", 3], ["REMEMBER", "remember_letters", "Remember the letters.", 2], ["REMEMBER", "remember_icons", "Remember the icons.", 1], ["REMEMBER", "remember_positions_2", "Remember four positions.", 0], ["REMEMBER", "remember_order_2", "Remember the original order.", 3],
        ["REACT", "react_red", "Tap when RED appears.", 0], ["REACT", "react_blue", "Tap when BLUE appears.", 1], ["REACT", "react_yellow", "Tap when YELLOW appears.", 3], ["REACT", "react_third", "React only to the third signal.", 2], ["REACT", "react_late", "Ignore the early signal and react late.", 1], ["REACT", "react_circle", "Tap only when the circle appears.", 0], ["REACT", "react_triangle", "Tap only when the triangle appears.", 2], ["REACT", "react_star", "Tap only when the star appears.", 3], ["REACT", "react_even", "React to the even signal.", 1], ["REACT", "react_fourth", "React only to the fourth signal.", 3], ["REACT", "react_after_change", "React only after the rule changes.", 1], ["REACT", "react_green_twice", "React to the second GREEN.", 1], ["REACT", "react_x_only", "Tap only on X.", 0], ["REACT", "react_signal_two", "Ignore signal one; react to signal two.", 1], ["REACT", "react_final", "React to the final signal.", 3],
        ["SWITCH", "switch_color", "The rule switches from BLUE to RED.", 1], ["SWITCH", "switch_direction", "The rule switches direction.", 1], ["SWITCH", "switch_after_two", "The rule changes after two actions.", 1], ["SWITCH", "switch_after_signal", "Switch when the signal appears.", 1], ["SWITCH", "switch_reverse", "The rule becomes reversed.", 1], ["SWITCH", "switch_number", "The target number changes.", 2], ["SWITCH", "switch_shape", "The target shape changes.", 3], ["SWITCH", "switch_instruction", "Follow the new instruction.", 1], ["SWITCH", "switch_timing", "The timing rule changes.", 1], ["SWITCH", "switch_action", "The required action changes.", 2], ["SWITCH", "switch_second_rule", "Use the second rule.", 1], ["SWITCH", "switch_after_three", "Change after three correct moves.", 1], ["SWITCH", "switch_direction_two", "The direction flips.", 3], ["SWITCH", "switch_target", "The target moves to another category.", 2], ["SWITCH", "switch_final", "Apply the final rule.", 2],
        ["TRICK", "trick_smallest", "The largest option is wrong; choose the smallest.", 0], ["TRICK", "trick_second", "The obvious first answer is wrong.", 1], ["TRICK", "trick_hidden", "The hidden exception is correct.", 2], ["TRICK", "trick_word", "Trust the word, not its color.", 0], ["TRICK", "trick_color", "Trust the color, not the word.", 1], ["TRICK", "trick_reverse", "Choose the opposite of the obvious answer.", 1], ["TRICK", "trick_forbidden", "The forbidden-looking option is correct.", 0], ["TRICK", "trick_slowest", "The slowest option is correct.", 2], ["TRICK", "trick_not_largest", "Do not choose the largest.", 0], ["TRICK", "trick_decoy", "Ignore the decoy.", 1], ["TRICK", "trick_mislead", "The instruction intentionally misleads.", 2], ["TRICK", "trick_exception", "Choose the exception.", 2], ["TRICK", "trick_wrong_label", "Ignore the label and follow the rule.", 1], ["TRICK", "trick_obvious_two", "The obvious second option is wrong.", 2], ["TRICK", "trick_contradiction", "Follow the latest rule.", 1],
        ["MIX", "mix_memory_switch", "Remember the pattern, then follow the changed rule.", 2], ["MIX", "mix_see_react", "Spot the visual change, then react.", 1], ["MIX", "mix_trick_react", "Ignore the decoy, then react to the signal.", 3], ["MIX", "mix_switch_memory", "Learn rule one, switch, then recall the target.", 0], ["MIX", "mix_full", "See, remember, switch and react in one round.", 2]
    ]
    for spec in specs:
        var family := str(spec[0]); var challenge_id := str(spec[1]); var description := str(spec[2]); var correct := int(spec[3])
        challenges.append({"id":challenge_id,"rule_key":"RULE_" + challenge_id.to_upper(),"description":description,"choices":_extended_choices(challenge_id, correct),"correct":correct,"kind_key":"KIND_" + family})

func _extended_choices(challenge_id: String, correct: int) -> Array:
    match challenge_id:
        "see_shape_shift": return _place_correct(["●","▲","■","◆"], correct, "◀")
        "see_missing_edge": return _place_correct(["●","▲","■","◆"], correct, "◢")
        "see_rotation": return _place_correct(["●","▲","■","◆"], correct, "◐")
        "see_size_change": return _place_correct(["SMALL","SMALL","SMALL","SMALL"], correct, "LARGE")
        "see_pattern_break": return _place_correct(["●","▲","■","●"], correct, "✦")
        "see_odd_symbol": return _place_correct(["●","▲","■","◆"], correct, "★")
        "see_position_shift": return _place_correct(["TOP","RIGHT","BOTTOM","LEFT"], correct, "CENTER")
        "see_filled_shape": return _place_correct(["○","□","△","◇"], correct, "◆")
        "see_outline_break": return _place_correct(["●","■","◆","▲"], correct, "□")
        "see_angle_change": return _place_correct(["UP","RIGHT","DOWN","LEFT"], correct, "DIAGONAL")
        "see_duplicate": return _place_correct(["A","B","C","D"], correct, "A A")
        "see_color_change": return _place_correct(["RED","BLUE","GREEN","YELLOW"], correct, "PURPLE")
        "see_spacing": return _place_correct(["A A","B B","C C","D D"], correct, "A    A")
        "see_direction": return _place_correct(["UP","RIGHT","DOWN","LEFT"], correct, "WRONG")
        "see_symmetry": return _place_correct(["SYMMETRIC","SYMMETRIC","SYMMETRIC","BROKEN"], correct, "BROKEN")
        "remember_colors": return _place_correct(["RED-BLUE-GREEN","BLUE-GREEN-RED","GREEN-RED-BLUE","RED-GREEN-BLUE"], correct, "RED-BLUE-GREEN")
        "remember_shapes": return _place_correct(["●-▲-■","▲-■-●","■-●-▲","●-■-▲"], correct, "●-▲-■")
        "remember_numbers": return _place_correct(["7-2-9","9-7-2","2-9-7","7-9-2"], correct, "7-2-9")
        "remember_corners": return _place_correct(["TL-BR-TR","TR-BL-BR","BR-TL-BL","TL-TR-BL"], correct, "TL-BR-TR")
        "remember_direction": return _place_correct(["UP-RIGHT-DOWN","RIGHT-DOWN-LEFT","DOWN-LEFT-UP","LEFT-UP-RIGHT"], correct, "UP-RIGHT-DOWN")
        "remember_pairs": return _place_correct(["A1-B2-C3","C3-A1-B2","B2-C3-A1","A1-C3-B2"], correct, "A1-B2-C3")
        "remember_lights": return _place_correct(["1-2-3","3-1-2","2-3-1","1-3-2"], correct, "1-2-3")
        "remember_symbols": return _place_correct(["★-◆-✦","✦-★-◆","◆-✦-★","★-✦-◆"], correct, "★-◆-✦")
        "remember_path": return _place_correct(["A-C-B-D","A-B-C-D","D-B-C-A","B-A-D-C"], correct, "A-C-B-D")
        "remember_slots": return _place_correct(["1-3-4","1-2-4","2-3-4","1-2-3"], correct, "1-3-4")
        "remember_tones": return _place_correct(["LOW-HIGH-LOW","HIGH-LOW-HIGH","LOW-LOW-HIGH","HIGH-HIGH-LOW"], correct, "LOW-HIGH-LOW")
        "remember_letters": return _place_correct(["A-D-B","B-A-D","D-B-A","A-B-D"], correct, "A-D-B")
        "remember_icons": return _place_correct(["★-◆-●","●-★-◆","◆-●-★","★-●-◆"], correct, "★-◆-●")
        "remember_positions_2": return _place_correct(["TOP-RIGHT-BOTTOM-LEFT","LEFT-TOP-RIGHT-BOTTOM","BOTTOM-LEFT-TOP-RIGHT","RIGHT-BOTTOM-LEFT-TOP"], correct, "TOP-RIGHT-BOTTOM-LEFT")
        "remember_order_2": return _place_correct(["1-3-2-4","1-2-3-4","4-2-3-1","2-1-4-3"], correct, "1-3-2-4")
        "react_circle": return ["●","▲","■","◆"]
        "react_triangle": return ["●","■","▲","◆"]
        "react_star": return ["●","▲","◆","★"]
        "react_red": return ["RED","BLUE","GREEN","YELLOW"]
        "react_blue": return ["RED","BLUE","GREEN","YELLOW"]
        "react_yellow": return ["RED","BLUE","GREEN","YELLOW"]
        "react_even", "react_third", "react_fourth", "react_signal_two", "react_final": return ["FIRST","SECOND","THIRD","FOURTH"]
        "react_after_change": return ["BEFORE","AFTER","DURING","NEVER"]
        "react_late": return ["EARLY","LATE","NOW","NEVER"]
        "react_green_twice": return ["FIRST","SECOND","THIRD","FOURTH"]
        "react_x_only": return ["X","O","△","□"]
        "switch_color": return ["BLUE","RED","GREEN","YELLOW"]
        "switch_direction", "switch_direction_two": return ["UP","RIGHT","DOWN","LEFT"]
        "switch_after_two", "switch_after_three", "switch_second_rule": return ["FIRST","SECOND","THIRD","FOURTH"]
        "switch_after_signal", "switch_instruction", "switch_final": return ["OLD_RULE","NEW_RULE","IGNORE","WAIT"]
        "switch_reverse": return ["FORWARD","REVERSE","SAME","NONE"]
        "switch_number": return ["1","2","3","4"]
        "switch_shape": return ["●","▲","■","◆"]
        "switch_timing": return ["FAST","SLOW","NOW","WAIT"]
        "switch_action": return ["TAP","HOLD","SWIPE","WAIT"]
        "switch_target": return ["SHAPE","COLOR","NUMBER","DIRECTION"]
        "trick_smallest": return ["SMALLEST","LARGEST","MIDDLE","NONE"]
        "trick_second", "trick_obvious_two": return ["FIRST","SECOND","THIRD","FOURTH"]
        "trick_hidden", "trick_exception": return ["OBVIOUS","DECOY","EXCEPTION","NONE"]
        "trick_word": return ["WORD","COLOR","BOTH","NONE"]
        "trick_color": return ["WORD","COLOR","BOTH","NONE"]
        "trick_reverse": return ["OBVIOUS","OPPOSITE","BOTH","NONE"]
        "trick_forbidden": return ["FORBIDDEN","SAFE","WAIT","NONE"]
        "trick_slowest": return ["FASTEST","MIDDLE","SLOWEST","NONE"]
        "trick_not_largest": return ["SMALLEST","LARGEST","MIDDLE","NONE"]
        "trick_decoy": return ["DECOY","TARGET","BOTH","NONE"]
        "trick_mislead": return ["FOLLOW","IGNORE","REVERSE","WAIT"]
        "trick_wrong_label": return ["LABEL","RULE","BOTH","NEITHER"]
        "trick_contradiction": return ["OLD","LATEST","BOTH","NONE"]
        "mix_memory_switch", "mix_see_react", "mix_trick_react", "mix_switch_memory", "mix_full": return ["FIRST","SECOND","THIRD","FOURTH"]
        _: return ["FIRST","SECOND","THIRD","FOURTH"]

func _place_correct(choices: Array, correct: int, value: String) -> Array:
    var result: Array = choices.duplicate()
    var original: String = str(result[correct])
    var existing_index := -1
    for i in result.size():
        if i != correct and str(result[i]) == value:
            existing_index = i
            break
    result[correct] = value
    if existing_index >= 0:
        result[existing_index] = original

    var used := {}
    for i in result.size():
        var choice := str(result[i])
        if not used.has(choice):
            used[choice] = true
            continue
        var replacement := "DECOY_%d" % (i + 1)
        while used.has(replacement):
            replacement += "_X"
        result[i] = replacement
        used[replacement] = true
    return result

func current() -> Dictionary:
    _normalize_index()
    return challenges[index]

func check(choice: int) -> bool:
    _normalize_index()
    return choice == int(challenges[index].get("correct", -1))

func next() -> void:
    if challenges.is_empty():
        index = 0
        return
    _normalize_index()
    index = (index + 1) % challenges.size()

func previous() -> void:
    if challenges.is_empty():
        index = 0
        return
    _normalize_index()
    index = (index - 1 + challenges.size()) % challenges.size()

func reset() -> void:
    index = 0

func _normalize_index() -> void:
    if challenges.is_empty():
        index = 0
    else:
        index = clamp(index, 0, challenges.size() - 1)
