#!/usr/bin/env bash
set -euo pipefail

LABEL="com.lachlanchen.quaderno.dptmount"
HOME_DIR="${HOME:-/Users/lachlanchen}"
BASE_DIR="$HOME_DIR/.local/share/quaderno-mount"
VENV="$BASE_DIR/venv"
PY="$VENV/bin/python"
DPTRP1="$VENV/bin/dptrp1"
DPTMOUNT="$VENV/bin/dptmount"
BOOTSTRAP_PY="${QUADERNO_PYTHON:-/usr/bin/python3}"
CONFIG="$HOME_DIR/.config/dpt-rp1.conf"
LAST_ADDR_FILE="$BASE_DIR/last-addr"
CLIENT_ID="$HOME_DIR/.config/dpt/deviceid.dat"
KEY="$HOME_DIR/.config/dpt/privatekey.dat"
MOUNTPOINT="$HOME_DIR/QuadernoMount"
LOG="$HOME_DIR/Library/Logs/quaderno-mount.log"
USB_SWITCH_SEQ=$'\x01\x00\x00\x01\x00\x00\x00\x01\x01\x04'
SCRIPT_PATH="$(cd "$(dirname "$0")" && pwd -P)/$(basename "$0")"

log() {
  printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*" | tee -a "$LOG" >&2
}

die() {
  log "ERROR: $*"
  osascript -e "display notification \"${*//\"/\\\"}\" with title \"Quaderno Mount\"" >/dev/null 2>&1 || true
  exit 1
}

run_timeout() {
  perl -e 'alarm shift; exec @ARGV' "$@"
}

ensure_tools() {
  mkdir -p "$BASE_DIR" "$HOME_DIR/.config" "$HOME_DIR/Library/Logs"

  if [[ ! -x "$DPTRP1" || ! -x "$DPTMOUNT" ]]; then
    log "Installing dpt-rp1-py into $VENV"
    "$BOOTSTRAP_PY" -m venv "$VENV"
    "$PY" -m pip install --upgrade pip dpt-rp1-py
  fi

  [[ -f "$CLIENT_ID" && -f "$KEY" ]] || die "Pair the Quaderno first; missing $CLIENT_ID or $KEY"
  [[ -d /Library/Filesystems/macfuse.fs ]] || die "macFUSE is not installed"
}

already_mounted() {
  # Avoid calling global mount(8): it can block when FUSE/network is slow.
  [[ -d "$MOUNTPOINT/Books" || -d "$MOUNTPOINT/Note" || -d "$MOUNTPOINT/Received" ]]
}

discover_wifi_ip() {
  local out ip
  out="$(run_timeout 8 dns-sd -G v4v6 Android.local 2>/dev/null || true)"
  ip="$(printf '%s\n' "$out" | awk '$6 ~ /^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$/ && $6 != "0.0.0.0" { print $6; exit }')"
  printf '%s' "$ip"
}

switch_usb_network() {
  local port
  for port in /dev/cu.usbmodem*; do
    [[ -e "$port" ]] || continue
    log "Trying USB CDC/ECM switch on $port"
    printf '%b' "$USB_SWITCH_SEQ" > "$port" || true
  done
}

test_addr() {
  local addr="$1"
  [[ -n "$addr" ]] || return 1
  run_timeout 20 "$DPTRP1" --addr "$addr" --quiet list-documents >/dev/null 2>&1
}

choose_addr() {
  local wifi_ip last_addr config_addr

  if [[ -f "$LAST_ADDR_FILE" ]]; then
    last_addr="$(tr -d '[:space:]' < "$LAST_ADDR_FILE")"
    if test_addr "$last_addr"; then
      log "Using last known Quaderno address $last_addr"
      printf '%s' "$last_addr"
      return 0
    fi
  fi

  if [[ -f "$CONFIG" ]]; then
    config_addr="$(awk '$1 == "addr:" { print $2; exit }' "$CONFIG")"
    if [[ -n "$config_addr" && "$config_addr" != "Android.local" ]] && test_addr "$config_addr"; then
      log "Using configured Quaderno address $config_addr"
      printf '%s' "$config_addr"
      return 0
    fi
  fi

  wifi_ip="$(discover_wifi_ip)"
  if test_addr "$wifi_ip"; then
    log "Using Quaderno over Wi-Fi at $wifi_ip"
    printf '%s' "$wifi_ip"
    return 0
  fi

  switch_usb_network
  sleep 3

  if test_addr "Android.local"; then
    log "Using Quaderno over USB network via Android.local"
    printf '%s' "Android.local"
    return 0
  fi

  wifi_ip="$(discover_wifi_ip)"
  if test_addr "$wifi_ip"; then
    log "Using Quaderno over Wi-Fi at $wifi_ip"
    printf '%s' "$wifi_ip"
    return 0
  fi

  return 1
}

write_config() {
  local addr="$1"
  mkdir -p "$(dirname "$CONFIG")"
  umask 077
  {
    printf 'dptrp1:\n'
    printf '  client-id: %s\n' "$CLIENT_ID"
    printf '  key: %s\n' "$KEY"
    printf '  addr: %s\n' "$addr"
  } > "$CONFIG"
  printf '%s\n' "$addr" > "$LAST_ADDR_FILE"
}

stop_mount() {
  if already_mounted; then
    log "Unmounting existing Quaderno mount"
    diskutil unmount "$MOUNTPOINT" >/dev/null 2>&1 || umount "$MOUNTPOINT" >/dev/null 2>&1 || true
  fi
  launchctl remove "$LABEL" >/dev/null 2>&1 || true
}

start_mount() {
  mkdir -p "$MOUNTPOINT"
  launchctl submit -l "$LABEL" -- /bin/zsh -lc "export DYLD_LIBRARY_PATH=/usr/local/lib; exec '$SCRIPT_PATH' --daemon >> '$LOG' 2>&1"
}

wait_for_mount() {
  local i
  for i in $(seq 1 30); do
    if already_mounted; then
      return 0
    fi
    sleep 1
  done
  return 1
}

daemon() {
  export DYLD_LIBRARY_PATH="/usr/local/lib:${DYLD_LIBRARY_PATH:-}"
  exec "$DPTMOUNT" "$MOUNTPOINT" --logfile "$LOG"
}

main() {
  if [[ "${1:-}" == "--daemon" ]]; then
    daemon
  fi

  ensure_tools

  if already_mounted; then
    log "Quaderno is already mounted at $MOUNTPOINT"
    open "$MOUNTPOINT"
    exit 0
  fi

  local addr
  addr="$(choose_addr)" || die "Could not reach Quaderno over Wi-Fi or USB"
  write_config "$addr"
  stop_mount
  start_mount

  if wait_for_mount; then
    log "Mounted Quaderno at $MOUNTPOINT"
    open "$MOUNTPOINT"
    osascript -e 'display notification "Mounted and opened QuadernoMount" with title "Quaderno Mount"' >/dev/null 2>&1 || true
  else
    launchctl remove "$LABEL" >/dev/null 2>&1 || true
    die "Mount did not become ready; see $LOG"
  fi
}

main "$@"
