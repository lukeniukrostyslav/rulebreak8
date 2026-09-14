#!/usr/bin/env python3
"""Final source audit for runtime code and release-critical project files."""
from __future__ import annotations

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
RUNTIME_ROOTS = [ROOT / "scripts", ROOT / "main.tscn", ROOT / "project.godot", ROOT / "export_presets.cfg"]
FORBIDDEN_PATTERNS = [
    re.compile(r"\bTODO\b", re.IGNORECASE),
    re.compile(r"\bFIXME\b", re.IGNORECASE),
    re.compile(r"\b(?:mock|stub|placeholder)\b", re.IGNORECASE),
    re.compile(r"(?:localhost|127\.0\.0\.1)", re.IGNORECASE),
    re.compile(r"https?://", re.IGNORECASE),
]


def runtime_files() -> list[Path]:
    files: list[Path] = []
    for root in RUNTIME_ROOTS:
        if root.is_dir():
            files.extend(p for p in root.rglob("*") if p.is_file())
        elif root.is_file():
            files.append(root)
    return sorted(set(files))


def main() -> None:
    files = runtime_files()
    assert files, "no runtime files discovered"
    violations: list[str] = []
    for path in files:
        try:
            text = path.read_text(encoding="utf-8")
        except UnicodeDecodeError:
            continue
        for pattern in FORBIDDEN_PATTERNS:
            if pattern.search(text):
                violations.append(f"{path.relative_to(ROOT)} matches {pattern.pattern}")

    assert not violations, "runtime source audit failed:\n" + "\n".join(violations)

    for artifact in ROOT.rglob("*"):
        if not artifact.is_file():
            continue
        if artifact.name.endswith((".apk", ".aab")):
            raise AssertionError(f"release artifact must not be committed: {artifact.relative_to(ROOT)}")

    print("RULEBREAK source audit: PASS — runtime tree has no TODO/FIXME/mock/stub/placeholder markers, local/network endpoints, or committed APK/AAB artifacts")


if __name__ == "__main__":
    main()
