# RULEBREAK — QA EVIDENCE MATRIX

| Gate | Repository evidence | Physical device required | Release blocking |
|---|---|---:|---:|
| Critical GDScript compile | GitHub Actions | No | Yes |
| Static integrity | GitHub Actions | No | Yes |
| Catalog behavior (100) | GitHub Actions | No | Yes |
| Localization fallback | GitHub Actions | No | Yes |
| Audio smoke | GitHub Actions | No | Yes |
| Main-scene boot | GitHub Actions | No | Yes |
| End-to-end gameplay | GitHub Actions | No | Yes |
| Debug APK export | GitHub Actions | No | Yes |
| Unsigned Release AAB export | GitHub Actions | No | Yes |
| Touch / portrait UX | CI contract + device | Yes | Yes |
| Haptics | Smoke + device | Yes | Yes |
| Real audio output | Smoke + device | Yes | Yes |
| Restart persistence | Runtime test + device | Yes | Yes |
| Signed artifact | Owner release environment | No | Yes |
| Play testing track | Owner Play Console | Yes | Yes |

## Evidence rule
CI evidence proves the tested repository behavior for the exact source SHA. Owner-side evidence must identify the exact signed build tested. No release claim should combine evidence from different source SHAs without explicitly recording the distinction.
