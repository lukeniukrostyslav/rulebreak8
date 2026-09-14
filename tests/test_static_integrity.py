from pathlib import Path
import csv
import json
import re

ROOT = Path(__file__).resolve().parents[1]
PROJECT = ROOT / "project.godot"
GAME = ROOT / "scripts/game.gd"
AUDIO = ROOT / "scripts/core/audio_feedback.gd"
PROGRESSION = ROOT / "scripts/core/progression.gd"
PRESETS = ROOT / "export_presets.cfg"
CATALOG = ROOT / "data/challenges.csv"
LOCALES = ROOT / "locales"


def fail(message: str) -> None:
    raise AssertionError(message)


def require_text(text: str, contracts: list[str], label: str) -> None:
    for contract in contracts:
        if contract not in text:
            fail(f"{label} missing contract: {contract}")


def main() -> None:
    if not PROJECT.is_file():
        fail("project.godot missing")
    if not GAME.is_file():
        fail("scripts/game.gd missing")
    if not CATALOG.is_file():
        fail("data/challenges.csv missing")

    rows = list(csv.reader(CATALOG.read_text(encoding="utf-8").splitlines()))
    if len(rows) != 101:
        fail(f"challenge catalog must contain header + 100 entries, got {len(rows)} rows")
    header = rows[0]
    if header != ["id", "family", "rule", "prompt", "choices", "correct_index", "view"]:
        fail(f"unexpected challenge catalog header: {header}")

    entries = rows[1:]
    ids = [row[0] for row in entries]
    if ids != [f"L{i:03d}" for i in range(1, 101)]:
        fail("challenge IDs must be exactly L001..L100")

    seed_ids = ids[:20]
    extension_ids = ids[20:]
    if len(seed_ids) != 20 or len(extension_ids) != 80:
        fail("catalog must contain exactly 20 seed and 80 extension entries")
    if seed_ids != [f"L{i:03d}" for i in range(1, 21)]:
        fail("seed IDs must be L001..L020")
    if extension_ids != [f"L{i:03d}" for i in range(21, 101)]:
        fail("extension IDs must be L021..L100")

    families = [row[1] for row in entries]
    expected_distribution = {"SEE": 18, "REMEMBER": 20, "REACT": 18, "SWITCH": 19, "TRICK": 19, "MIX": 6}
    actual_distribution = {family: families.count(family) for family in expected_distribution}
    if actual_distribution != expected_distribution:
        fail(f"unexpected family distribution: {actual_distribution}")

    for row in entries:
        if len(row) != len(header):
            fail(f"catalog row {row[0]} has inconsistent width")
        if not row[2].strip() or not row[3].strip() or not row[4].strip():
            fail(f"catalog row {row[0]} contains empty gameplay text")
        choices = [choice.strip() for choice in row[4].split("|")]
        if len(choices) != 4 or any(not choice for choice in choices):
            fail(f"catalog row {row[0]} must contain exactly four choices")
        try:
            correct_index = int(row[5])
        except ValueError:
            fail(f"catalog row {row[0]} has non-integer correct_index")
        if correct_index < 0 or correct_index >= len(choices):
            fail(f"catalog row {row[0]} has invalid correct_index")
        if not row[6].strip():
            fail(f"catalog row {row[0]} missing view")

    project = PROJECT.read_text(encoding="utf-8")
    require_text(project, ['run/main_scene="res://main.tscn"', 'config/features=PackedStringArray("4.3")', 'window/size/viewport_width=1080', 'window/size/viewport_height=1920', 'window/stretch/mode="canvas_items"', 'locale/fallback="en"', 'renderer/rendering_method.mobile="gl_compatibility"'], "project.godot")

    game = GAME.read_text(encoding="utf-8")
    require_text(game, [
        'const AudioFeedbackScript = preload("res://scripts/core/audio_feedback.gd")',
        'var audio_feedback := AudioFeedbackScript.new()', 'add_child(audio_feedback)',
        'audio_feedback.play_correct()', 'audio_feedback.play_wrong()',
        'var button_height := 92 if compact else 112', 'b.custom_minimum_size = Vector2(0, 112)',
        'if compact:', 'b.custom_minimum_size.y = button_height',
        'b.focus_mode = Control.FOCUS_NONE', '_style_choice_button(b)',
        'buttons[i].disabled = not challenge_view.input_ready',
        'if answer_locked or not challenge_view.input_ready:', 'answer_locked = true',
        'challenge_view.input_ready = false',
    ], "game.gd")
    if game.count('b.custom_minimum_size = Vector2(0, 112)') != 1:
        fail("choice touch target must retain one explicit full-size 112px contract")
    if game.count('b.custom_minimum_size.y = button_height') != 1:
        fail("choice touch target must apply the compact responsive height")
    if 'var button_height := 92 if compact else 112' not in game:
        fail("compact and full-size touch target heights must both be explicit")

    audio = AUDIO.read_text(encoding="utf-8")
    require_text(audio, ['class_name AudioFeedback', 'AudioStreamGenerator.new()', 'AudioStreamGeneratorPlayback', 'play_correct()', 'play_wrong()', 'playback.push_buffer(frames)'], "audio_feedback.gd")

    progression = PROGRESSION.read_text(encoding="utf-8")
    require_text(progression, ['const TEMP_SAVE_PATH := "user://rulebreak_save.json.tmp"', 'const BACKUP_SAVE_PATH := "user://rulebreak_save.json.bak"', 'const BACKUP_TEMP_SAVE_PATH := "user://rulebreak_save.json.bak.tmp"', 'temp.flush()', 'DirAccess.rename_absolute(save_abs, backup_temp_abs)', 'DirAccess.rename_absolute(temp_abs, save_abs)', 'DirAccess.rename_absolute(backup_temp_abs, backup_abs)', '_restore_backup()', 'func _is_valid_payload(parsed: Dictionary) -> bool:', 'required_keys := ['], "progression.gd")

    presets = PRESETS.read_text(encoding="utf-8")
    require_text(presets, ['[preset.0]', 'name="Android Debug APK"', 'name="Android Release AAB"', 'platform="Android"'], "export_presets.cfg")

    locale_files = sorted(LOCALES.glob("*.csv"))
    if len(locale_files) != 21:
        fail(f"expected 21 locale CSV files, got {len(locale_files)}")
    locale_headers = {path.name: next(csv.reader(path.read_text(encoding="utf-8").splitlines())) for path in locale_files}
    expected_locale_header = ["key", "value"]
    if any(header != expected_locale_header for header in locale_headers.values()):
        fail("all locale CSV files must use the key,value header")
    for path in locale_files:
        locale_rows = list(csv.reader(path.read_text(encoding="utf-8").splitlines()))
        keys = []
        width = len(locale_rows[0])
        for row in locale_rows[1:]:
            if len(row) != width:
                fail(f"{path.name}: inconsistent CSV width")
            if row[0].strip():
                keys.append(row[0].strip())
        if len(keys) != len(set(keys)):
            fail(f"{path.name}: duplicate translation key")

    print(json.dumps({
        "status": "PASS",
        "catalog_entries": 100,
        "catalog_distribution": expected_distribution,
        "locale_files": 21,
        "adaptive_touch_target": {"compact_px": 92, "full_px": 112},
        "checks": ["repository integrity", "catalog", "project config", "game contracts", "audio feedback", "progression recovery", "export presets", "localization"]
    }, indent=2))


if __name__ == "__main__":
    main()
