#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd -P)"
PKG_DIR="$ROOT/firmware/gen2/packages"
OUT_ROOT="$ROOT/firmware/gen2/unpacked"
UNPACKER_DIR="$ROOT/external/A4_fw_unpacker"

expected_size() {
  case "$1" in
    FwUpdater_gen2_2.1.00.20271FP.pkg) echo 792878234 ;;
    FwUpdater_gen2_1.1.02.15120FP.pkg) echo 758100282 ;;
    FwUpdater_gen2_1.1.02.12130FP.pkg) echo 757807658 ;;
    FwUpdater_gen2_1.1.01.04100FP.pkg) echo 755832890 ;;
    FwUpdater_gen2_1.1.00.26010FP.pkg) echo 755365882 ;;
    FwUpdater_gen2_1.1.00.24160FP.pkg) echo 755382970 ;;
    FwUpdater_gen2_1.1.00.21150FP.pkg) echo 687169626 ;;
    FwUpdater_gen2_1.1.00.17310FP.pkg) echo 687141722 ;;
    FwUpdater_gen2_1.1.00.15020FP.pkg) echo 665703050 ;;
    FwUpdater_gen2_1.1.00.09240FP.pkg) echo 665374650 ;;
    FwUpdater_gen2_1.0.00.17060FP.pkg) echo 661897501 ;;
    *) echo "" ;;
  esac
}

mkdir -p "$PKG_DIR" "$OUT_ROOT"

shopt -s nullglob
packages=("$PKG_DIR"/FwUpdater_gen2_*.pkg)
if [[ ${#packages[@]} -eq 0 ]]; then
  echo "No firmware packages found in $PKG_DIR"
  exit 1
fi

for pkg in "${packages[@]}"; do
  name="$(basename "$pkg")"
  expected="$(expected_size "$name")"
  actual="$(stat -f '%z' "$pkg")"
  if [[ -n "$expected" && "$actual" != "$expected" ]]; then
    echo "SKIP $name: expected $expected bytes, found $actual bytes"
    continue
  fi

  stem="${name%.pkg}"
  out="$OUT_ROOT/$stem"
  mkdir -p "$out"
  shasum -a 256 "$pkg" > "$out/package.sha256"

  echo "UNPACK $name"
  (
    cd "$UNPACKER_DIR"
    ./unpacker.sh "$pkg" "$out"
  )

  for archive in preparation_archive.zip contents_archive.zip; do
    if [[ -f "$out/$archive" ]]; then
      dest="$out/${archive%.zip}"
      mkdir -p "$dest"
      unzip -q -o "$out/$archive" -d "$dest"
    fi
  done
done
