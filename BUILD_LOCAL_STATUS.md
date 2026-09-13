# RULEBREAK — Build Status

## Verified
- Repository: `lukeniukrostyslav/rulebreak8`
- Branch: `main`
- Godot project configuration present.
- Android verification workflow present.

## Current blocker
The connected execution environment does not contain the Godot executable and cannot clone/download the repository from the public internet. Therefore a genuine local Android APK build cannot be claimed here.

## Build policy
An APK is considered READY only after the actual APK file is produced and inspected. GitHub Actions must not be described as successful merely because the workflow file exists.

## Next target
Obtain an executable Godot 4.3.x build environment, run the existing tests, export Android Debug, inspect the resulting APK, and only then mark Android Build PROVEN.
