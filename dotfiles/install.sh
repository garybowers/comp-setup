#!/usr/bin/env bash
# install.sh — copy my Hyprland desktop configs into ~/.config on this machine,
# so all my systems stay consistent.
#
# Installs, by copying real files (NOT symlinks back into this repo):
#   hypr/    hyprland.lua, hypridle.conf, hyprpaper.conf, hyprlock.conf, switch.sh, dpms-resume.sh
#   kitty/   kitty.conf
#   rofi/    config.rasi
#   waybar/  config.jsonc, style.css, power_menu.xml, scripts/
#   themes/  the theme system (set-theme.sh + themes/<name>/…)
#   systemd/user/waybar.service
#
# Any existing target is backed up to <name>.bak.<timestamp> first, so it is
# safe to re-run. After copying, it applies the active theme, which creates the
# per-app theme symlinks (theme.css / theme.conf / theme.rasi / current-wallpaper)
# that the base configs import.
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"   # the dotfiles/ dir in the repo
CFG="${XDG_CONFIG_HOME:-$HOME/.config}"
STAMP="$(date +%Y%m%d-%H%M%S)"

say()  { printf '\033[1;32m::\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!!\033[0m %s\n' "$*"; }

backup() {  # move an existing file/dir/symlink aside
  local p="$1"
  if [ -e "$p" ] || [ -L "$p" ]; then
    mv "$p" "$p.bak.$STAMP"
    echo "   backed up $(basename "$p") -> $(basename "$p").bak.$STAMP"
  fi
}

install_dir() {  # install_dir <name> : copy SRC/<name>/ -> CFG/<name>/
  local name="$1" s="$SRC/$1" d="$CFG/$1"
  [ -d "$s" ] || { warn "skip $name (missing in repo)"; return; }
  backup "$d"
  mkdir -p "$d"
  cp -a "$s/." "$d/"
  say "installed $name"
}

# Preserve the currently-active theme across a re-install; default to tokyo-night.
THEME="tokyo-night"
if [ -L "$CFG/themes/current" ]; then
  THEME="$(basename "$(readlink -f "$CFG/themes/current")")"
fi

say "Installing configs into $CFG"
install_dir hypr
install_dir kitty
install_dir rofi
install_dir waybar
install_dir themes

# waybar systemd user unit — Hyprland's lua startup runs `systemctl --user start waybar.service`
if [ -f "$SRC/systemd/user/waybar.service" ]; then
  mkdir -p "$CFG/systemd/user"
  backup "$CFG/systemd/user/waybar.service"
  cp -a "$SRC/systemd/user/waybar.service" "$CFG/systemd/user/waybar.service"
  systemctl --user daemon-reload 2>/dev/null || true
  say "installed waybar.service user unit"
fi

# executable bits on the scripts
chmod +x "$CFG/hypr/switch.sh" "$CFG/hypr/dpms-resume.sh" "$CFG/themes/set-theme.sh" 2>/dev/null || true
chmod +x "$CFG"/waybar/scripts/*.sh 2>/dev/null || true

# Apply the theme -> creates theme.css / theme.conf / theme.rasi / current-wallpaper,
# the stable symlinks that waybar/kitty/rofi/hyprpaper import. Safe outside a session.
if [ -x "$CFG/themes/set-theme.sh" ]; then
  say "Applying theme: $THEME"
  "$CFG/themes/set-theme.sh" "$THEME" \
    || warn "set-theme.sh reported an issue (expected if not in a Hyprland session yet)"
fi

say "Done."
echo
echo "Notes:"
echo "  • Log into Hyprland (or run 'hyprctl reload') to pick up the hypr configs."
echo "  • hyprland.lua is copied verbatim and needs your Lua-config runtime (hl.*) present."
echo "  • hyprlock.conf points at a wallpaper under ~/Pictures/wallpapers — copy those"
echo "    over separately if you want the same lock-screen background."
