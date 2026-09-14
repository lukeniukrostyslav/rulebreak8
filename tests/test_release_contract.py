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
    verification_workflow = read(".github/workflows/godot.yml")
    final_apk_workflow = read(".github/workflows/final-apk.yml")
    aab_workflow = read(".github/workflows/release-aab.yml")
    final_build_policy = read("docs/FINAL_BUILD_POLICY.md")
    catalog = json.loads(read("scripts/data/challenges.json"))

    require(project, 'config/name="RULEBREAK"', "project identity")
    require(project, 'run/main_scene="res://main.tscn"', "main scene")
    require(project, 'config/features=PackedStringArray("4.3")', "Godot version")
    require(project, 'window/size/viewport_width=1080', "portrait viewport width")
    require(project, 'window/size/viewport_height=1920', "portrait viewport height")
    require(project, 'renderer/rendering_method.mobile="gl_compatibility"', "mobile renderer")

    for expected in (
        'name="Android Debug"', 'name="Android Release AAB (Unsigned)"', 'platform="Android"',
        'gradle_build/min_sdk="24"', 'gradle_build/target_sdk="36"', 'architectures/arm64-v8a=true',
        'architectures/armeabi-v7a=false', 'architectures/x86=false', 'architectures/x86_64=false',
        'version/name="0.1.0"', 'package/unique_name="com.rulebreak.game"', 'package/signed=false',
    ):
        require(presets, expected, "Android export contract")
    if presets.count("version/code=1") != 1 or presets.count("version/code=2") != 1:
        raise AssertionError("debug/release version-code contract drifted")
    if re.search(r"(?:password|secret|token|api[_-]?key)\s*[=:]\s*['\"]?[^\s#'\"]+", presets, re.I):
        raise AssertionError("export presets appear to contain a secret")

    if catalog.get("version") != 2 or catalog.get("total_levels") != 100:
        raise AssertionError("challenge catalog version/size contract changed")
    if len(catalog.get("mvp_seed", [])) != 20:
        raise AssertionError("challenge catalog must retain 20 seed levels")
    if set(catalog.get("challenge_families", [])) != {"SEE", "REMEMBER", "REACT", "SWITCH", "TRICK", "MIX"}:
        raise AssertionError("challenge family contract changed unexpectedly")

    manager = read("scripts/core/challenge_manager.gd")
    if manager.count('"choices":[') < 20:
        raise AssertionError("seed challenge choices appear incomplete")
    spec_rows = re.findall(r'\["(?:SEE|REMEMBER|REACT|SWITCH|TRICK|MIX)",\s*"[^"]+",', manager)
    if len(spec_rows) != 80:
        raise AssertionError(f"extended challenge specs must contain exactly 80 rows, found {len(spec_rows)}")

    forbidden = re.compile(r"(?:http://|https://)(?!localhost|127\.0\.0\.1)", re.I)
    for path in ("scripts/game.gd", "scripts/core/challenge_manager.gd", "scripts/core/progression.gd", "scripts/core/localization.gd"):
        if forbidden.search(read(path)):
            raise AssertionError(f"runtime file unexpectedly contains a network URL: {path}")

    for expected in (
        "Close all gameplay/content/UX/data/persistence/localization/audio/haptics/security/offline blocks.",
        "Close all automated compile, runtime, family-behavior, catalog, localization, save/recovery and release-contract checks.",
        "Only then create the final APK for physical Android QA.",
        "After physical QA passes, perform production signing and create the final AAB.",
        "Only after signed AAB verification proceed to Google Play Console testing/release.",
    ):
        require(final_build_policy, expected, "final build policy")

    runtime_marker = "Validate project through headless runtime tests"
    if verification_workflow.find(runtime_marker) < 0:
        raise AssertionError("routine verification workflow must run runtime gates")
    if any(marker in verification_workflow for marker in ("Export Android debug APK", "Export unsigned release AAB", "gh release create", "gh release upload")):
        raise AssertionError("routine verification workflow must not build or publish release artifacts")
    require(verification_workflow, "permissions:\n  contents: read", "routine verification permissions")
    require(verification_workflow, "concurrency:", "routine verification concurrency")
    require(verification_workflow, "cancel-in-progress: true", "routine verification concurrency")

    for expected in (
        "workflow_dispatch:", "physical_qa_ready", "Run final automated gates", "Export Android debug APK",
        "Verify APK manifest identity", "package: name='com.rulebreak.game' versionCode='1' versionName='0.1.0'",
        "sdkVersion:'24'", "targetSdkVersion:'36'", "lib/arm64-v8a/", "lib/(armeabi-v7a|x86|x86_64)/", "Record APK checksum",
        "actions/upload-artifact@v4", "build/android/rulebreak-debug.apk", "build/android/rulebreak-debug.apk.sha256",
        "artifact_type=debug-apk", "source_commit=${GITHUB_SHA}", "signed=debug-keystore",
    ):
        require(final_apk_workflow, expected, "final APK workflow")
    if final_apk_workflow.find("Run final automated gates") > final_apk_workflow.find("Export Android debug APK"):
        raise AssertionError("final APK export must occur after automated gates")
    if "gh release create" in final_apk_workflow or "gh release upload" in final_apk_workflow:
        raise AssertionError("final APK workflow must not publish a release automatically")
    require(final_apk_workflow, "permissions:\n  contents: read", "final APK permissions")

    for expected in (
        "workflow_dispatch:", "physical_qa_passed", "Run runtime gates", "Export unsigned release AAB", "Record AAB checksum and build metadata",
        "build/android/rulebreak-release.aab", "build/android/rulebreak-release.aab.sha256", "build/android/rulebreak-release.aab.metadata.txt",
        "artifact_type=unsigned-release-aab", "source_commit=${GITHUB_SHA}", "signed=false", "verification=ci-verified-export",
        "actions/upload-artifact@v4",
    ):
        require(aab_workflow, expected, "AAB release pipeline")
    if aab_workflow.find("Run runtime gates") > aab_workflow.find("Export unsigned release AAB"):
        raise AssertionError("AAB export must occur only after runtime gates")
    if "gh release create" in aab_workflow or "gh release upload" in aab_workflow:
        raise AssertionError("unsigned AAB workflow must not publish a production release")
    require(aab_workflow, "permissions:\n  contents: read", "AAB permissions")

    print("RELEASE CONTRACT PASS: routine CI is verification-only; final APK and post-QA AAB exports are separately gated and non-publishing")


if __name__ == "__main__":
    main()
