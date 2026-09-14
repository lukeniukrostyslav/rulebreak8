#!/usr/bin/env python3
"""Repository-level release contract checks for RULEBREAK."""
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
    apk_workflow = read(".github/workflows/godot.yml")
    aab_workflow = read(".github/workflows/release-aab.yml")
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
    spec_rows = re.findall(
        r'^\s+\["(?:SEE|REMEMBER|REACT|SWITCH|TRICK|MIX)",\s*"[^"]+",',
        manager,
        re.MULTILINE,
    )
    if len(spec_rows) != 80:
        raise AssertionError(f"extended challenge specs must contain exactly 80 rows, found {len(spec_rows)}")

    forbidden = re.compile(r"(?:http://|https://)(?!localhost|127\.0\.0\.1)", re.I)
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

    for expected in (
        "Export Android debug APK",
        "Record APK checksum",
        "Upload Android debug APK",
        "Publish APK to GitHub Release",
        "gh release create",
        "build/android/rulebreak-debug.apk",
        "build/android/rulebreak-debug.apk.sha256",
        "artifact_type=debug-apk",
        "source_commit=${GITHUB_SHA}",
        "signed=false",
    ):
        require(apk_workflow, expected, "APK release pipeline")

    for expected in (
        "Export unsigned release AAB",
        "Record AAB checksum and build metadata",
        "build/android/rulebreak-release.aab",
        "build/android/rulebreak-release.aab.sha256",
        "build/android/rulebreak-release.aab.metadata.txt",
        "artifact_type=unsigned-release-aab",
        "source_commit=${GITHUB_SHA}",
        "signed=false",
        "verification=ci-verified-export",
        "actions/upload-artifact@v4",
    ):
        require(aab_workflow, expected, "AAB release pipeline")

    if "gh release create" in aab_workflow:
        raise AssertionError("unsigned AAB workflow must not publish a misleading production release")

    print("RELEASE CONTRACT PASS: project, Android presets, catalog, offline runtime boundaries, APK metadata and AAB verification pipeline verified")


if __name__ == "__main__":
    main()
