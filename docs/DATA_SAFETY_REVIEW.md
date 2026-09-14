# RULEBREAK — Data Safety Review

## Repository-level finding
The current MVP is designed as an offline-first game with local progression. The repository contains no required backend, account system, analytics service, advertising SDK, subscription system or IAP dependency.

## Data handled by the MVP
The gameplay state that needs persistence is stored locally on the device. This includes progression state such as current level and streak-related values.

## Network behavior
The product does not require an internet connection to play. Runtime code is intentionally kept free of network URLs/dependencies by the release contract test.

## Third-party services
The repository does not require a cloud service for the core gameplay loop.

## Play Console boundary
This document is engineering evidence, not a completed Google Play Data Safety declaration. The owner must review the exact signed build, exported dependencies and any future SDK additions before submitting the Data Safety form.

## Release rule
If analytics, ads, crash reporting, remote configuration, social features, cloud saves or any other networked SDK is added later, this review must be redone before claiming the current Data Safety position still applies.
