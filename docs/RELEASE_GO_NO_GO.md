# RULEBREAK — RELEASE GO / NO-GO

## GO requires
- [ ] Fresh authoritative GREEN Android verification on the exact release source SHA.
- [ ] Fresh authoritative GREEN unsigned Release AAB verification on the exact release source SHA.
- [ ] Physical Android QA complete.
- [ ] Production signing complete outside the repository.
- [ ] Signed AAB checksum recorded.
- [ ] Play testing track install verified.
- [ ] No open release-blocking defects.

## NO-GO triggers
- Any failed authoritative CI gate.
- Any unexplained runtime crash or progression loss on a physical device.
- Raw localization keys visible to players.
- Broken touch/input lock behavior.
- Invalid or unverifiable signed artifact.
- Missing release credentials or incomplete Play Console declarations.

## Decision rule
Until every GO item is checked with evidence, the build remains a release candidate and must not be represented as production-ready.
