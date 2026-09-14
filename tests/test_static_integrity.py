#!/usr/bin/env python3
"""Repository-only integrity gate for RULEBREAK.

This intentionally uses only the Python standard library so CI can catch
catalog/localization/export configuration regressions before Godot boots.
It is not a replacement for the Godot runtime tests.
"""
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
LOCALE_DIR = ROOT / "locale"

EXPECTED_LOCALES = [
    "en", "es", "pt_BR", "fr", "de", "it", "ru", "uk", "pl", "tr", "nl",
    "ar", "he", "hi", "id", "vi", "th", "ja", "ko", "zh", "zh_TW",
]
EXPECTED_FAMILIES = {"SEE", "REMEMBER", "REACT", "SWITCH", "TRICK", "MIX"}


def fail(message: str) -> None:
    raise AssertionError(message)


def main() -> None:
    manager = MANAGER.read_text(encoding="utf-8")
    metadata = json.loads(CATALOG.read_text(encoding="utf-8"))

    if metadata["total_levels"] != 100:
        fail("catalog metadata total_levels must be 100")
    if metadata["base_seed_levels"] != 20:
        fail("catalog metadata base_seed_levels must be 20")
    if metadata["generated_extension_levels"] != 80:
        fail("catalog metadata generated_extension_levels must be 80")

    seed_items = metadata["mvp_seed"]
    seed_ids = [item["id"] for item in seed_items]
    if len(seed_ids) != 20 or len(seed_ids) != len(set(seed_ids)):
        fail("mvp_seed must contain 20 unique IDs")

    base_rows = re.findall(
        r'\{"id":"([^"]+)","rule_key":"([^"]+)","choices":\[([^\]]+)\],"correct":(\d+),"kind_key":"KIND_([^"]+)"\}',
        manager,
    )
    if len(base_rows) != 20:
        fail(f"ChallengeManager base catalog entries: expected 20, got {len(base_rows)}")

    base_ids = [row[0] for row in base_rows]
    if base_ids != seed_ids:
        fail("ChallengeManager seed IDs differ from scripts/data/challenges.json")

    for row, seed in zip(base_rows, seed_items):
        challenge_id, _rule_key, choices_blob, correct, family = row
        if family != str(seed["family"]):
            fail(f"{challenge_id}: seed family mismatch")
        choice_count = len(re.findall(r'"(?:[^"\\]|\\.)*"', choices_blob))
        if choice_count != 4:
            fail(f"{challenge_id}: expected exactly 4 choices, got {choice_count}")
        correct_index = int(correct)
        if not 0 <= correct_index < 4:
            fail(f"{challenge_id}: correct choice index must be in [0, 3], got {correct_index}")

    extension_rows = re.findall(
        r'\["(SEE|REMEMBER|REACT|SWITCH|TRICK|MIX)",\s*"([^"]+)",\s*"([^"]+)",\s*(\d+)\]',
        manager,
    )
    if len(extension_rows) != 80:
        fail(f"ChallengeManager extension entries: expected 80, got {len(extension_rows)}")

    for family, challenge_id, description, correct in extension_rows:
        if not challenge_id:
            fail(f"{family}: extension challenge has empty ID")
        if not description.strip():
            fail(f"{challenge_id}: extension challenge has empty English description")
        correct_index = int(correct)
        if not 0 <= correct_index < 4:
            fail(f"{challenge_id}: correct choice index must be in [0, 3], got {correct_index}")

    ids = base_ids + [row[1] for row in extension_rows]
    if len(ids) != 100 or len(ids) != len(set(ids)):
        fail("ChallengeManager must contain exactly 100 unique challenge IDs")

    families = [row[0] for row in extension_rows]
    family_counts = Counter(families)
    seed_family_counts = Counter(item["family"] for item in seed_items)
    final_counts = seed_family_counts + family_counts
    expected_counts = {
        "SEE": 18, "REMEMBER": 20, "REACT": 18,
        "SWITCH": 19, "TRICK": 19, "MIX": 6,
    }
    if final_counts != expected_counts:
        fail(f"family distribution mismatch: {dict(final_counts)}")
    if set(final_counts) != EXPECTED_FAMILIES:
        fail("all six challenge families must be represented")

    for path in sorted(LOCALE_DIR.glob("*.csv")):
        with path.open(encoding="utf-8", newline="") as fh:
            rows = list(csv.reader(fh))
        if not rows or rows[0][0] != "keys":
            fail(f"{path.name}: missing keys header")
        if rows[0][1:] != EXPECTED_LOCALES:
            fail(f"{path.name}: locale header mismatch")
        width = len(rows[0])
        keys = []
        for row in rows[1:]:
            if len(row) != width:
                fail(f"{path.name}: inconsistent CSV width")
            key = row[0].strip()
            if key:
                keys.append(key)
        if len(keys) != len(set(keys)):
            fail(f"{path.name}: duplicate translation key")

    project = PROJECT.read_text(encoding="utf-8")
    required_project_settings = [
        'run/main_scene="res://main.tscn"',
        'config/features=PackedStringArray("4.3")',
        'window/size/viewport_width=1080',
        'window/size/viewport_height=1920',
        'window/stretch/mode="canvas_items"',
        'locale/fallback="en"',
        'renderer/rendering_method.mobile="gl_compatibility"',
    ]
    for setting in required_project_settings:
        if setting not in project:
            fail(f"project.godot missing required setting: {setting}")

    game = GAME.read_text(encoding="utf-8")
    required_touch_contracts = [
        'b.custom_minimum_size = Vector2(0, 112)',
        'b.focus_mode = Control.FOCUS_NONE',
        'b.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND',
        '_style_choice_button(b)',
        'b.disabled = not challenge_view.input_ready',
        'if answer_locked or not challenge_view.input_ready:',
        'answer_locked = true',
        'challenge_view.input_ready = false',
    ]
    for contract in required_touch_contracts:
        if contract not in game:
            fail(f"game.gd missing Android interaction contract: {contract}")
    if game.count('b.custom_minimum_size = Vector2(0, 112)') != 1:
        fail("choice touch target height must remain explicitly defined")

    progression = PROGRESSION.read_text(encoding="utf-8")
    required_persistence_contracts = [
        'const TEMP_SAVE_PATH := "user://rulebreak_save.json.tmp"',
        'const BACKUP_SAVE_PATH := "user://rulebreak_save.json.bak"',
        'temp.flush()',
        'DirAccess.rename_absolute(save_abs, backup_abs)',
        'DirAccess.rename_absolute(temp_abs, save_abs)',
        '_try_restore_backup()',
    ]
    for contract in required_persistence_contracts:
        if contract not in progression:
            fail(f"progression.gd missing persistence recovery contract: {contract}")

    presets = PRESETS.read_text(encoding="utf-8")
    required_preset_settings = [
        'gradle_build/min_sdk="24"',
        'gradle_build/target_sdk="36"',
        'package/unique_name="com.rulebreak.game"',
        'package/name="RULEBREAK"',
        'package/signed=false',
        'architectures/arm64-v8a=true',
    ]
    for setting in required_preset_settings:
        if setting not in presets:
            fail(f"Android presets missing required setting: {setting}")
    if 'architectures/armeabi-v7a=false' not in presets or 'architectures/x86=false' not in presets or 'architectures/x86_64=false' not in presets:
        fail("Android presets must keep the locked arm64-only MVP ABI surface")
    if 'name="Android Debug"' not in presets or 'name="Android Release AAB (Unsigned)"' not in presets:
        fail("both debug APK and unsigned release AAB presets must remain defined")
    if 'export_format=0' not in presets or 'export_format=1' not in presets:
        fail("debug APK and release AAB export formats must both remain defined")

    print("RULEBREAK static integrity: PASS — 100 unique levels, seed/runtime catalog contract, descriptions/correct-index contract, family distribution, 21 locales, Android touch/input-lock contract, crash-resistant progression persistence, Godot viewport/renderer config, Android API 36/arm64 release config")


if __name__ == "__main__":
    main()
