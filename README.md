[English](README.md) · [العربية](i18n/README.ar.md) · [Español](i18n/README.es.md) · [Français](i18n/README.fr.md) · [日本語](i18n/README.ja.md) · [한국어](i18n/README.ko.md) · [Tiếng Việt](i18n/README.vi.md) · [中文 (简体)](i18n/README.zh-Hans.md) · [中文（繁體）](i18n/README.zh-Hant.md) · [Deutsch](i18n/README.de.md) · [Русский](i18n/README.ru.md)

[![LazyingArt banner](https://github.com/lachlanchen/lachlanchen/raw/main/figs/banner.png)](https://github.com/lachlanchen/lachlanchen/blob/main/figs/banner.png)

# Fujitsu Quaderno

*Research notes and lightweight tooling for Fujitsu Quaderno Digital Paper devices.*

[![Website](https://img.shields.io/badge/LazyingArt-lazying.art-0EA5E9?style=for-the-badge)](https://lazying.art)
[![Device](https://img.shields.io/badge/Device-Fujitsu%20Quaderno-64748B?style=for-the-badge)](research.md)
[![Workflow](https://img.shields.io/badge/Workflow-Research%20%2B%20Mount%20Tools-16A34A?style=for-the-badge)](tools/README.md)
[![Sponsor](https://img.shields.io/badge/Sponsor-lachlanchen-EA4AAA?style=for-the-badge&logo=githubsponsors&logoColor=white)](https://github.com/sponsors/lachlanchen)

This repository collects Fujitsu Quaderno generation mapping, jailbreak and
firmware research, official firmware package links, and practical document
management tooling. The current local device context is a Quaderno A4 Gen 2
`FMVDP41`, controlled through the normal paired Digital Paper API rather than
root or ADB.

## Status

- Quaderno A4 Gen 2 `FMVDP41` was paired locally with `dpt-rp1-py`.
- macFUSE mounting works at `/Users/lachlanchen/QuadernoMount`.
- A clickable macOS launcher was installed as `Quaderno Mount.app`.
- Wi-Fi and USB CDC/ECM Digital Paper API access were verified.
- No public, confirmed Gen 2 or Gen 3C jailbreak/root path has been found.
- Gen 2 firmware analysis currently centers on `ygjsz/A4_fw_unpacker`.

## Contents

| Path | Purpose |
| --- | --- |
| `research.md` | Quaderno generation map, jailbreak/root research, repository links, and local control notes |
| `firmware-download-links.md` | Official Fujitsu Gen 2 firmware package URLs and expected package sizes |
| `tools/README.md` | Local Quaderno mount launcher notes |
| `tools/quaderno-mount.sh` | Lightweight mount helper for paired Digital Paper API access |
| `tools/unpack-gen2-firmware.sh` | Helper for unpacking downloaded Gen 2 firmware packages |
| `i18n/` | Multilingual README summaries |

Ignored local folders include downloaded firmware packages, cloned external
research repositories, and private paired-device configuration.

## Quick Start

Start with the research notes:

```bash
open research.md
```

Review firmware package links:

```bash
open firmware-download-links.md
```

Mount the paired Quaderno:

```bash
./tools/quaderno-mount.sh
```

Open mount launcher notes:

```bash
open tools/README.md
```

## Scope

This is a personal-device research workspace. It is not a DRM-removal workflow
and does not contain a confirmed Quaderno root exploit. Treat Sony Digital Paper
root tooling as adjacent research unless Quaderno model checks, updater format,
and signing behavior are independently verified.

## Links

- Project homepage: https://lazying.art
- Fujitsu support/download page: https://www.fmworld.net/digital-paper/support/download/
- `dpt-rp1-py`: https://github.com/janten/dpt-rp1-py
- `A4_fw_unpacker`: https://github.com/ygjsz/A4_fw_unpacker
- `dpt-tools`: https://github.com/HappyZ/dpt-tools

## Support

| Donate | PayPal | Stripe | GitHub Sponsors |
| --- | --- | --- | --- |
| [![Donate](https://img.shields.io/badge/Donate-LazyingArt-0EA5E9?style=for-the-badge&logo=kofi&logoColor=white)](https://chat.lazying.art/donate) | [![PayPal](https://img.shields.io/badge/PayPal-RongzhouChen-00457C?style=for-the-badge&logo=paypal&logoColor=white)](https://paypal.me/RongzhouChen) | [![Stripe](https://img.shields.io/badge/Stripe-Donate-635BFF?style=for-the-badge&logo=stripe&logoColor=white)](https://buy.stripe.com/aFadR8gIaflgfQV6T4fw400) | [![Sponsor](https://img.shields.io/badge/GitHub-Sponsor-EA4AAA?style=for-the-badge&logo=githubsponsors&logoColor=white)](https://github.com/sponsors/lachlanchen) |
