#!/usr/bin/env bash
# ==============================================================================
# Keep every runtime on the latest version
# DaikieJP - 2026
#
# `mise upgrade --prune` moves each tool in ~/.config/mise/config.toml to the
# newest release and uninstalls the version it replaced, so old builds never
# pile up. Runs weekly on its own (launchd on macOS, a systemd timer on Linux)
# and is safe to run by hand at any time.
#
# Heads up: a new PHP or Ruby release means a full source build, which is CPU
# heavy for a while. That is the price of "always latest" for those two.
# ==============================================================================

set -euo pipefail

LOG_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/mise"
LOG="$LOG_DIR/update.log"
mkdir -p "$LOG_DIR"

# Keep the log from growing forever
if [ -f "$LOG" ] && [ "$(wc -c < "$LOG")" -gt 1048576 ]; then
  mv "$LOG" "$LOG.old"
fi

exec >>"$LOG" 2>&1
echo ""
echo "=============================================================="
echo "$(date '+%Y-%m-%d %H:%M:%S')  starting"

# launchd and systemd start with a bare PATH; find mise wherever it lives.
for candidate in /opt/homebrew/bin /usr/local/bin "$HOME/.local/bin"; do
  [ -x "$candidate/mise" ] && PATH="$candidate:$PATH"
done
export PATH

if ! command -v mise >/dev/null 2>&1; then
  echo "mise not found in PATH; nothing to do."
  exit 0
fi

# Do not jump onto a release that is hours old: give it a week to be pulled if
# it turns out broken.
export MISE_YES=1
nice -n 10 mise upgrade --prune --minimum-release-age 7d

echo "$(date '+%Y-%m-%d %H:%M:%S')  done"
mise ls
