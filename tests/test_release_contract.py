#!/usr/bin/env python3
"""Repository-level release contract checks for RULEBREAK.

These checks intentionally run without Godot so obvious release regressions are
caught before the slower Android export jobs.
"""
from __future__ import annotations

import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]


def read(path: str) -> str:
    return (ROOT / path).read_text(encoding="utf-8")


def require(text: str, needle: str, label: str) -> None:
    if needle not in text:
        raise AssertionError(f"{label}: missing {needle!r}")


def main() -> None:
    project = read("project.godot")
    presets = read("export_presets.cfg")
    catalog = json.loads(read("scripts/data/challenges.json"))

    require(project, 'config/name="RULEBREAK"', "project identity")
    require(project, 'run/main_scene="res://main.tscn"', "main scene")
    require(project, 'config/features=PackedStringArray("4.3")', "Godot version")
    require(project, 'window/size/viewport_width=1080', "portrait viewport width")
    require(project, 'window/size/viewport_height=1920', "portrait viewport height")
    require(project, 'renderer/rendering_method.mobile="gl_compatibility"', "mobile renderer")

    for expected in (
        'name="Android Debug"',
        'name="Android Release AAB (Unsigned)"',
        'platform="Android"',
        'gradle_build/min_sdk="24"',
        'gradle_build/target_sdk="36"',
        'architectures/arm64-v8a=true',
        'architectures/armeabi-v7a=false',
        'architectures/x86=false',
        'architectures/x86_64=false',
        'package/unique_name="com.rulebreak.game"',
        'package/signed=false',
    ):
        require(presets, expected, "Android export contract")

    if re.search(r"(?:password|secret|token|api[_-]?key)\s*[=:]\s*['\"]?[^\s#'\"]+", presets, re.I):
        raise AssertionError("export presets appear to contain a secret")

    if catalog.get("version") != 2:
        raise AssertionError("challenge catalog version must be 2")
    if catalog.get("total_levels") != 100:
        raise AssertionError("challenge catalog must declare exactly 100 levels")
    if len(catalog.get("mvp_seed", [])) != 20:
        raise AssertionError("challenge catalog must retain 20 seed levels")
    families = set(catalog.get("challenge_families", []))
    if families != {"SEE", "REMEMBER", "REACT", "SWITCH", "TRICK", "MIX"}:
        raise AssertionError("challenge family contract changed unexpectedly")

    manager = read("scripts/core/challenge_manager.gd")
    if manager.count('"choices":[') < 20:
        raise AssertionError("seed challenge choices appear incomplete")
    if manager.count('challenges.append({') < 80:
        raise AssertionError("extended challenge generation appears incomplete")

    forbidden = re.compile(r"(?:http://|https://)(?!localhost|127\\.0\\.0\\.1)", re.I)
    runtime_files = [
        "scripts/game.gd",
        "scripts/core/challenge_manager.gd",
        "scripts/core/progression.gd",
        "scripts/core/localization.gd",
    ]
    for path in runtime_files:
        text = read(path)
        if forbidden.search(text):
            raise AssertionError(f"runtime file unexpectedly contains a network URL: {path}")

    print("RELEASE CONTRACT PASS: project, Android presets, catalog and offline runtime boundaries verified")


if __name__ == "__main__":
    main()
