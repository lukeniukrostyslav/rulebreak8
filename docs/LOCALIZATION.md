# RULEBREAK Localization

RULEBREAK is configured for English plus 20 additional languages:

- Spanish (`es`)
- Brazilian Portuguese (`pt_BR`)
- French (`fr`)
- German (`de`)
- Italian (`it`)
- Russian (`ru`)
- Ukrainian (`uk`)
- Polish (`pl`)
- Turkish (`tr`)
- Dutch (`nl`)
- Arabic (`ar`)
- Hebrew (`he`)
- Hindi (`hi`)
- Indonesian (`id`)
- Vietnamese (`vi`)
- Thai (`th`)
- Japanese (`ja`)
- Korean (`ko`)
- Simplified Chinese (`zh`)
- Traditional Chinese (`zh_TW`)

The game selects the device language at startup and falls back to English when a locale is unavailable.

Translation sources are stored as UTF-8 CSV files under `locale/` and registered in `project.godot`. Godot supports CSV translation import and runtime locale switching. Before release, every locale must be tested on-device for text fit, line wrapping, RTL behavior, and font fallback.

Truth status:
- Localization infrastructure: IMPLEMENTED
- Automatic device-language selection: IMPLEMENTED
- Core gameplay rules translated: IMPLEMENTED for the current 20 challenge seed set
- Full visual/linguistic QA for all 20 locales: NOT VERIFIED
- Native-speaker review: NOT VERIFIED
