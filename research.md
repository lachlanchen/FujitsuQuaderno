# Fujitsu Quaderno Jailbreak And Repository Research

Generated: 2026-06-12

Scope: public jailbreak/rooting material and related repositories across the Quaderno generations. I did not download firmware, clone these repositories, or run any jailbreak/root tool against the connected device.

Connected device context from earlier local checks: USB device `FMVDP41`, vendor Fujitsu, which matches Quaderno A4 Gen 2.

## Bottom Line

- I did not find a public, confirmed Quaderno Gen 2 or Gen 3C jailbreak/root repository.
- The most relevant Quaderno Gen 2 firmware project is `ygjsz/A4_fw_unpacker`, which unpacks Gen 2 firmware packages. Public discussion indicates repacking/signing remains the blocker for a normal software root path.
- `HappyZ/dpt-tools` is the central Sony Digital Paper root/tooling repo and has Quaderno discussion threads, but its rooted-device workflows are primarily for Sony DPT-RP1/DPT-CP1 and should not be assumed to work on Quaderno Gen 2.
- Practical public repos for Quaderno today are mostly file transfer, sync, GUI, and print workflows.

## Local Control Verified

Verified on 2026-06-12 with connected `FMVDP41`:

- Paired with `dpt-rp1-py`; credentials are stored in `/Users/lachlanchen/.config/dpt/`.
- File listing works over the Digital Paper HTTPS API.
- macFUSE mount works at `/Users/lachlanchen/QuadernoMount`.
- USB-network access works after switching the device to CDC/ECM mode through `/dev/cu.usbmodem*`.
- Wi-Fi access works at last observed address `192.168.1.193`.
- A clickable launcher was installed at `/Users/lachlanchen/Applications/Quaderno Mount.app`, with a Desktop shortcut.

This is not root access. It is authenticated document-management access through the normal Digital Paper API.

## Local Root / ADB Checks

Non-destructive checks on 2026-06-12:

- No `adb` binary was installed locally.
- USB enumeration showed `FMVDP41` with Fujitsu vendor/product IDs, but no obvious ADB interface.
- TCP checks against the Quaderno Wi-Fi address `192.168.1.193`:
  - `22`, `2222`, `5555`, `8022`: connection refused.
  - `8443`: open; this is the normal paired Digital Paper API.
- Bonjour `_adb._tcp` discovery found no ADB service.
- `HappyZ/dpt-tools` diagnosis/root workflows are Sony DPT-oriented and depend on diagnosis mode / updater-package behavior. They are not confirmed safe for `FMVDP41` Gen 2.

Conclusion: ADB/root is not exposed by the current normal boot state. Any next step toward root requires firmware analysis or a Quaderno-specific diagnosis/update path; do not run Sony DPT root/update flows against this device without confirming compatibility.

Firmware-download helper files:

- `firmware-download-links.md`
- `tools/unpack-gen2-firmware.sh`

## Generation Map

| Generation | Models | Notes |
| --- | --- | --- |
| Early / Gen 1 | `FMV-DPP01`, `FMV-DPP02`, `FMV-DPP03` A4, `FMV-DPP04` A5 | Fujitsu support separates these older models from current `FMVDP*` firmware/app downloads. Official product page lists A4 `FMV-DPP03` and A5 `FMV-DPP04`, with `FMV-DPP01`/`FMV-DPP02` also appearing in support tables. |
| Gen 2 | `FMVDP41` A4, `FMVDP51` A5 | Current public root discussions mainly target this generation. The connected device is `FMVDP41`. |
| Gen 3C / color | `FMVDP43CA4` A4 color, `FMVDP53CA5` A5 color | Current official support groups these with Gen 2 for `QUADERNO PC App` and firmware support. I found no public Gen 3C jailbreak repo. |

Official model references:

- Fujitsu support/download page: https://www.fmworld.net/digital-paper/support/download/
- Fujitsu Gen 1 product page: https://www.fmworld.net/digital-paper/gen1/product.html
- Fujitsu repair/model support table: https://azby.fmworld.net/support/repair/info/list_quaderno.html

## Jailbreak And Firmware Sources

| Source | Link | Generation | Status |
| --- | --- | --- | --- |
| `HappyZ/dpt-tools` | https://github.com/HappyZ/dpt-tools | Sony DPT-RP1/DPT-CP1; adjacent to Quaderno Gen 1/2 discussions | Main public root/tooling repo for Sony Digital Paper. Includes Quaderno issue threads. |
| Quaderno support issue `#181` | https://github.com/HappyZ/dpt-tools/issues/181 | Quaderno Gen 1/2 discussion | Tracks Quaderno firmware/root questions and links to Gen 2 unpacker work. |
| Gen 2 root issue `#195` | https://github.com/HappyZ/dpt-tools/issues/195 | Quaderno Gen 2 | Discusses failed attempts to root Gen 2 and the PKG repack/signature problem. |
| `ygjsz/A4_fw_unpacker` | https://github.com/ygjsz/A4_fw_unpacker | Quaderno Gen 2 A4/A5 | Public firmware unpacker for Gen 2 packages. Useful for analysis, not a complete root path. |
| `Antiparadox/Sony-Digital-Paper-Hack` | https://github.com/Antiparadox/Sony-Digital-Paper-Hack | Sony DPT-RP1/DPT-CP1 | Adjacent only; not confirmed for Quaderno Gen 2/3C. |
| `octavianx/Unpack-and-rebuild-the-DPT-RP1-upgrade-firmware` | https://github.com/octavianx/Unpack-and-rebuild-the-DPT-RP1-upgrade-firmware | Sony DPT-RP1 | Firmware background; adjacent only. |

Key inference: the public Gen 2 path currently stops at unpacking/analysis. Public comments in `#195` point to needing either the original PKG signing key, replacing trusted keys on-device, or finding a signature-check/update bug.

Local public-tool copies cloned on 2026-06-12:

- `external/A4_fw_unpacker`
- `external/dpt-tools`

Private local device configuration export:

- `private/device-configuration.json` (ignored by git)

## Repositories By Generation

### Gen 1 / Early Quaderno

| Repository | Link | Relevance |
| --- | --- | --- |
| `HappyZ/dpt-tools` | https://github.com/HappyZ/dpt-tools | Adjacent root tooling because first-generation Quaderno hardware/software is close to Sony Digital Paper. Verify exact firmware before any use. |
| `janten/dpt-rp1-py` | https://github.com/janten/dpt-rp1-py | File management tool for Sony Digital Paper and Fujitsu Quaderno. |
| `DPT-RP1/DigitalPaperApp` | https://github.com/DPT-RP1/DigitalPaperApp | Java port of `dpt-rp1-py`; adjacent management app. |
| `cristobaltapia/dpt-rp1-cups` | https://github.com/cristobaltapia/dpt-rp1-cups | CUPS backend that says it supports Fujitsu Quaderno e-readers. |
| `HSSLC/digital-paper-zhtw` | https://github.com/HSSLC/digital-paper-zhtw | Translation modifications for Sony/Fujitsu Digital Paper and Quaderno PC apps. |

### Gen 2 Quaderno

| Repository / Thread | Link | Relevance |
| --- | --- | --- |
| `ygjsz/A4_fw_unpacker` | https://github.com/ygjsz/A4_fw_unpacker | Direct Gen 2 firmware unpacking. |
| `janten/dpt-rp1-py` issue `#124` | https://github.com/janten/dpt-rp1-py/issues/124 | Quaderno A4 Gen 2 registration/support discussion. |
| `dpt-rp1-py` USB notes | https://github.com/janten/dpt-rp1-py/blob/master/docs/linux-ethernet-over-usb.md | Documents Quaderno Gen 2 over USB using `Android.local` and `_dp_fujitsu._tcp`. |
| `ikanher/quaderno-gui` | https://github.com/ikanher/quaderno-gui | GUI file manager/Zotero sync built against Quaderno A4 Gen 2. |
| `cristobaltapia/dpt-rp1-cups` | https://github.com/cristobaltapia/dpt-rp1-cups | Print-to-device workflow; claims all Quaderno versions. |
| `HappyZ/dpt-tools` issue `#181` | https://github.com/HappyZ/dpt-tools/issues/181 | Quaderno firmware/root discussion. |
| `HappyZ/dpt-tools` issue `#195` | https://github.com/HappyZ/dpt-tools/issues/195 | Gen 2 root issue; useful for understanding blockers. |

### Gen 3C / Color Quaderno

| Repository / Source | Link | Relevance |
| --- | --- | --- |
| Fujitsu support/download page | https://www.fmworld.net/digital-paper/support/download/ | Official page groups `FMVDP43CA4` and `FMVDP53CA5` with Gen 2 models for current app/firmware support. |
| `janten/dpt-rp1-py` | https://github.com/janten/dpt-rp1-py | Likely relevant for file management because it supports Fujitsu Quaderno generally, but verify against Gen 3C hardware/app pairing before relying on it. |
| `cristobaltapia/dpt-rp1-cups` | https://github.com/cristobaltapia/dpt-rp1-cups | Claims support for all Fujitsu Quaderno versions. |

No public Gen 3C jailbreak/root repo surfaced in the searches.

## Search Notes

- Searches included exact model numbers (`FMV-DPP01`, `FMV-DPP02`, `FMV-DPP03`, `FMV-DPP04`, `FMVDP41`, `FMVDP51`, `FMVDP43CA4`, `FMVDP53CA5`) plus `Fujitsu Quaderno`, `quaderno`, `root`, `jailbreak`, and GitHub filters.
- Broad GitHub searches for `quaderno` include many unrelated projects using the same name. I filtered this file to device-specific or Sony/Fujitsu Digital Paper ecosystem repositories.

## Practical Next Research Steps

1. For the connected `FMVDP41`, focus on Gen 2 sources first: `A4_fw_unpacker`, `dpt-rp1-py` issue `#124`, and `HappyZ/dpt-tools` issues `#181` and `#195`.
2. Treat any Sony DPT-RP1/DPT-CP1 root package as adjacent until the Quaderno updater format, model check, and signing path are proven.
3. If the goal is file access rather than root, test `dpt-rp1-py` or `quaderno-gui` before pursuing jailbreak paths.
