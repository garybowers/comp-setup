#!/usr/bin/env bash
# set-theme.sh — switch the active desktop theme.
#
# Themes live in this repo under themes/<name>/. Each theme provides:
#   waybar.css           imported by ~/.config/waybar/style.css
#   kitty.conf           included by ~/.config/kitty/kitty.conf
#   rofi.rasi            imported by ~/.config/rofi/config.rasi
#   wallpapers/*.{jpg,png}   one or more wallpapers (random pick on switch)
#
# Switching re-points the stable symlinks each app imports, then live-reloads
# the running apps. Safe to run repeatedly; safe to run on a fresh machine
# (it creates the symlinks the configs expect).
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEMES_DIR="$REPO/themes"

usage() {
  echo "Usage: $(basename "$0") <theme-name>"
  echo "Available themes:"
  ls -1 "$THEMES_DIR" 2>/dev/null | sed 's/^/  /' || echo "  (none)"
  exit 1
}

[ $# -eq 1 ] || usage
THEME="$1"
SRC="$THEMES_DIR/$THEME"
[ -d "$SRC" ] || { echo "error: theme '$THEME' not found"; usage; }

link() { # link <target> <linkname> — only if target exists
  local target="$1" name="$2"
  [ -e "$target" ] || { echo "  skip $(basename "$name") (theme has no $(basename "$target"))"; return; }
  mkdir -p "$(dirname "$name")"
  ln -sfn "$target" "$name"
  echo "  $name -> ${target#"$REPO"/}"
}

echo "Switching to theme: $THEME"

# --- per-app theme files (stable symlinks the base configs import) ---
link "$SRC/waybar.css" "$HOME/.config/waybar/theme.css"
link "$SRC/kitty.conf" "$HOME/.config/kitty/theme.conf"
link "$SRC/rofi.rasi"  "$HOME/.config/rofi/theme.rasi"

# --- wallpaper: pick one from wallpapers/ (random when there are several) ---
WALL=""
if [ -d "$SRC/wallpapers" ]; then
  mapfile -t walls < <(find "$SRC/wallpapers" -type f \
    \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \) | sort)
  if [ "${#walls[@]}" -gt 0 ]; then
    WALL="${walls[RANDOM % ${#walls[@]}]}"
    # hyprpaper.conf points at this stable symlink, so the wallpaper persists
    # across logins (uses whichever was last selected).
    ln -sfn "$WALL" "$HOME/.config/hypr/current-wallpaper"
    echo "  wallpaper: $(basename "$WALL")"
  fi
fi

# --- record the active theme ---
ln -sfn "$SRC" "$REPO/current"

# --- live-reload running apps ---
echo "Reloading..."
# waybar: systemd unit's ExecReload sends SIGUSR2 (falls back to a raw signal)
systemctl --user reload waybar.service 2>/dev/null \
  || pkill -SIGUSR2 -x waybar 2>/dev/null || true
# kitty: SIGUSR1 makes every running instance re-read its config
pkill -SIGUSR1 -x kitty 2>/dev/null || true
# wallpaper: swap live via hyprpaper IPC
if [ -n "$WALL" ] && command -v hyprctl >/dev/null 2>&1; then
  hyprctl hyprpaper preload "$WALL" >/dev/null 2>&1 || true
  hyprctl hyprpaper wallpaper ",$WALL" >/dev/null 2>&1 || true
fi
# rofi has no daemon — it reads theme.rasi on its next launch.

echo "Done. Active theme: $THEME"
