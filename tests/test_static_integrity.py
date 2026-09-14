#!/usr/bin/env python3
"""Repository-only integrity gate for RULEBREAK."""
from __future__ import annotations

import csv
import json
import re
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MANAGER = ROOT / "scripts/core/challenge_manager.gd"
CATALOG = ROOT / "scripts/data/challenges.json"
PRESETS = ROOT / "export_presets.cfg"
PROJECT = ROOT / "project.godot"
GAME = ROOT / "scripts/game.gd"
PROGRESSION = ROOT / "scripts/core/progression.gd"
AUDIO = ROOT / "scripts/core/audio_feedback.gd"
LOCALE_DIR = ROOT / "locale"
EXPECTED_LOCALES = ["en", "es", "pt_BR", "fr", "de", "it", "ru", "uk", "pl", "tr", "nl", "ar", "he", "hi", "id", "vi", "th", "ja", "ko", "zh", "zh_TW"]
EXPECTED_FAMILIES = {"SEE", "REMEMBER", "REACT", "SWITCH", "TRICK", "MIX"}
EXPECTED_FAMILY_COUNTS = {"SEE": 18, "REMEMBER": 20, "REACT": 18, "SWITCH": 19, "TRICK": 19, "MIX": 6}


def fail(message: str) -> None:
    raise AssertionError(message)


def require_text(text: str, contracts: list[str], label: str) -> None:
    for contract in contracts:
        if contract not in text:
            fail(f"{label} missing contract: {contract}")


def main() -> None:
    manager = MANAGER.read_text(encoding="utf-8")
    metadata = json.loads(CATALOG.read_text(encoding="utf-8"))
    if metadata.get("total_levels") != 100 or metadata.get("base_seed_levels") != 20 or metadata.get("generated_extension_levels") != 80:
        fail("catalog metadata must be 100 total = 20 seed + 80 extension")
    seed_items = metadata["mvp_seed"]
    seed_ids = [item["id"] for item in seed_items]
    if len(seed_ids) != 20 or len(set(seed_ids)) != 20:
        fail("mvp_seed must contain 20 unique IDs")

    base_rows = re.findall(r'\{"id":"([^"]+)","rule_key":"([^"]+)","choices":\[([^\]]+)\],"correct":(\d+),"kind_key":"KIND_([^"]+)"\}', manager)
    if len(base_rows) != 20 or [row[0] for row in base_rows] != seed_ids:
        fail("ChallengeManager seed catalog must contain the same 20 IDs as challenges.json")
    for row, seed in zip(base_rows, seed_items):
        if row[4] != str(seed["family"]):
            fail(f"{row[0]}: seed family mismatch")
        if len(re.findall(r'\"(?:[^\"\\]|\\.)*\"', row[2])) != 4 or not 0 <= int(row[3]) < 4:
            fail(f"{row[0]}: invalid seed choices")

    extension_rows = re.findall(r'\["(SEE|REMEMBER|REACT|SWITCH|TRICK|MIX)",\s*"([^"]+)",\s*"([^"]+)",\s*(\d+)\]', manager)
    if len(extension_rows) != 80:
        fail(f"ChallengeManager extension entries: expected 80, got {len(extension_rows)}")
    ids = [row[0] for row in base_rows] + [row[1] for row in extension_rows]
    if len(ids) != 100 or len(set(ids)) != 100:
        fail("ChallengeManager must contain exactly 100 unique challenge IDs")
    counts = Counter(row[4] for row in base_rows) + Counter(row[0] for row in extension_rows)
    if counts != EXPECTED_FAMILY_COUNTS or set(counts) != EXPECTED_FAMILIES:
        fail(f"family distribution mismatch: {dict(counts)}")

    for path in sorted(LOCALE_DIR.glob("*.csv")):
        with path.open(encoding="utf-8", newline="") as fh:
            rows = list(csv.reader(fh))
        if not rows or rows[0][0] != "keys" or rows[0][1:] != EXPECTED_LOCALES:
            fail(f"{path.name}: locale header mismatch")
        width = len(rows[0])
        keys = []
        for row in rows[1:]:
            if len(row) != width:
                fail(f"{path.name}: inconsistent CSV width")
            if row[0].strip():
                keys.append(row[0].strip())
        if len(keys) != len(set(keys)):
            fail(f"{path.name}: duplicate translation key")

    project = PROJECT.read_text(encoding="utf-8")
    require_text(project, ['run/main_scene="res://main.tscn"', 'config/features=PackedStringArray("4.3")', 'window/size/viewport_width=1080', 'window/size/viewport_height=1920', 'window/stretch/mode="canvas_items"', 'locale/fallback="en"', 'renderer/rendering_method.mobile="gl_compatibility"'], "project.godot")

    game = GAME.read_text(encoding="utf-8")
    require_text(game, [
        'const AudioFeedbackScript = preload("res://scripts/core/audio_feedback.gd")',
        'var audio_feedback := AudioFeedbackScript.new()', 'add_child(audio_feedback)',
        'audio_feedback.play_correct()', 'audio_feedback.play_wrong()', 'audio_feedback.play_timeout()',
        'var button_height := 92 if compact else 112', 'b.custom_minimum_size = Vector2(0, 112)',
        'if compact:', 'b.custom_minimum_size.y = button_height',
        'b.focus_mode = Control.FOCUS_NONE', '_style_choice_button(b)',
        'buttons[i].disabled = not challenge_view.input_ready',
        'if answer_locked or not challenge_view.input_ready:', 'answer_locked = true',
        'challenge_view.input_ready = false',
        'func _localized_rule_text(challenge: Dictionary) -> String:',
        'if not rule_key.is_empty() and translated != rule_key:',
        'if not description.is_empty():',
    ], "game.gd")
    if game.count('b.custom_minimum_size = Vector2(0, 112)') != 1:
        fail("choice touch target must retain one explicit full-size 112px contract")
    if game.count('b.custom_minimum_size.y = button_height') != 1:
        fail("choice touch target must apply the compact responsive height")

    audio = AUDIO.read_text(encoding="utf-8")
    require_text(audio, ['class_name AudioFeedback', 'AudioStreamGenerator.new()', 'AudioStreamGeneratorPlayback', 'play_correct()', 'play_wrong()', 'play_timeout()', 'playback.push_buffer(frames)'], "audio_feedback.gd")

    progression = PROGRESSION.read_text(encoding="utf-8")
    require_text(progression, ['const TEMP_SAVE_PATH := "user://rulebreak_save.json.tmp"', 'const BACKUP_SAVE_PATH := "user://rulebreak_save.json.bak"', 'const BACKUP_TEMP_SAVE_PATH := "user://rulebreak_save.json.bak.tmp"', 'temp.flush()', 'DirAccess.rename_absolute(save_abs, backup_temp_abs)', 'DirAccess.rename_absolute(temp_abs, save_abs)', 'DirAccess.rename_absolute(backup_temp_abs, backup_abs)', '_restore_backup()', 'func _is_valid_payload(parsed: Dictionary) -> bool:', 'required_keys := ['], "progression.gd")

    presets = PRESETS.read_text(encoding="utf-8")
    require_text(presets, ['gradle_build/min_sdk="24"', 'gradle_build/target_sdk="36"', 'package/unique_name="com.rulebreak.game"', 'package/name="RULEBREAK"', 'package/signed=false', 'architectures/arm64-v8a=true', 'architectures/armeabi-v7a=false', 'architectures/x86=false', 'architectures/x86_64=false', 'name="Android Debug"', 'name="Android Release AAB (Unsigned)"'], "export_presets.cfg")
    if 'export_format=0' not in presets or 'export_format=1' not in presets:
        fail("debug APK and release AAB export formats must both be defined")

    print("RULEBREAK static integrity: PASS — 100 unique levels, six-family distribution, 21 locales, localized rule fallback, responsive Android touch/input lock, correct/wrong/timeout audio feedback, durable persistence recovery, Godot 4.3 config, Android API 36/arm64 release config")


if __name__ == "__main__":
    main()
