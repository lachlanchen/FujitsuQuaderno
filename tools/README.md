# Quaderno Mount Launcher

This folder contains the source scripts for the local Quaderno mount launcher.

Installed runtime files:

- Launcher app: `/Users/lachlanchen/Applications/Quaderno Mount.app`
- Desktop shortcut: `/Users/lachlanchen/Desktop/Quaderno Mount.app`
- Installed runner: `/Users/lachlanchen/.local/share/quaderno-mount/quaderno-mount.sh`
- Persistent Python venv: `/Users/lachlanchen/.local/share/quaderno-mount/venv`
- Mount point: `/Users/lachlanchen/QuadernoMount`
- Log file: `/Users/lachlanchen/Library/Logs/quaderno-mount.log`

The runner tries, in order:

1. Last known working Quaderno address.
2. Configured address in `/Users/lachlanchen/.config/dpt-rp1.conf`.
3. Wi-Fi mDNS discovery for `Android.local`.
4. USB CDC/ECM mode switch and `Android.local`.
5. A second Wi-Fi discovery attempt.

Unmount:

```bash
diskutil unmount /Users/lachlanchen/QuadernoMount
launchctl remove com.lachlanchen.quaderno.dptmount
```

Reinstall the launcher app after editing `Quaderno Mount.applescript`:

```bash
osacompile -o /Users/lachlanchen/Applications/Quaderno\ Mount.app FujitsuQuaderno/tools/Quaderno\ Mount.applescript
ln -sfn /Users/lachlanchen/Applications/Quaderno\ Mount.app /Users/lachlanchen/Desktop/Quaderno\ Mount.app
```
