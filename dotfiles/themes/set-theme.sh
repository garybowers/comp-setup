#!/usr/bin/env bash
# set-theme.sh — switch the active desktop theme.
#
# Themes live in this repo under themes/<name>/. Each theme provides:
#   waybar.css           imported by ~/.config/waybar/style.css
#   kitty.conf           included by ~/.config/kitty/kitty.conf
#   rofi.rasi            imported by ~/.config/rofi/config.rasi
#   hyprlock.conf        sourced by ~/.config/hypr/hyprlock.conf (lock-screen colours)
#   wallpapers/*.{jpg,png,webp}  one or more wallpapers (chosen in the menu, or random)
#
# Switching re-points the stable symlinks each app imports, then live-reloads
# the running apps. Safe to run repeatedly; safe to run on a fresh machine
# (it creates the symlinks the configs expect).
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
THEMES_DIR="$REPO/themes"

usage() {
  echo "Usage: $(basename "$0") [theme-name [wallpaper-file|random]]   (no name: menu; --rofi: rofi menu)"
  echo "Available themes:"
  ls -1 "$THEMES_DIR" 2>/dev/null | sed 's/^/  /' || echo "  (none)"
  exit 1
}

list_walls() { # list_walls <theme-dir> — full paths of its wallpapers
  [ -d "$1/wallpapers" ] || return 0
  find "$1/wallpapers" -type f \
    \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) | sort
}

show_wall() { # show_wall <file> — make it the wallpaper now and at next login
  ln -sfn "$1" "$HOME/.config/hypr/current-wallpaper"
  if command -v hyprctl >/dev/null 2>&1; then
    hyprctl hyprpaper preload "$1" >/dev/null 2>&1 || true
    hyprctl hyprpaper wallpaper ",$1" >/dev/null 2>&1 || true
  fi
}

# No argument, run in a terminal: full-screen arrow-key menu. Themes on the
# left, the current theme's backgrounds on the right. Moving through the
# backgrounds shows each one live, so you can cycle until you like one.
menu() {
  local themes=() mw=() pane=0 ti=0 wi=0 toff=0 woff=0 cur="" key rest H r i t style
  mapfile -t themes < <(ls -1 "$THEMES_DIR")
  cur="$(basename "$(readlink "$REPO/current" 2>/dev/null)" 2>/dev/null || true)"
  for i in "${!themes[@]}"; do [ "${themes[i]}" = "$cur" ] && ti=$i; done

  load_walls() { # backgrounds of the current theme; cursor on the one showing
    local curw; curw="$(readlink "$HOME/.config/hypr/current-wallpaper" 2>/dev/null || true)"
    mw=(); wi=0; woff=0
    [ -n "$cur" ] && mapfile -t mw < <(list_walls "$THEMES_DIR/$cur")
    for i in "${!mw[@]}"; do [ "${mw[i]}" = "$curw" ] && wi=$i; done
    return 0
  }
  apply_theme() { # apply the highlighted theme unless it is already the current one
    [ "${themes[ti]}" = "$cur" ] && return 0
    cur="${themes[ti]}"
    "${BASH_SOURCE[0]}" "$cur" >/dev/null 2>&1 || true
    load_walls
  }
  draw() {
    H=$(($(tput lines 2>/dev/null || echo 24) - 4)); [ "$H" -ge 1 ] || H=1
    [ "$ti" -lt "$toff" ] && toff=$ti; [ "$ti" -ge $((toff + H)) ] && toff=$((ti - H + 1))
    [ "$wi" -lt "$woff" ] && woff=$wi; [ "$wi" -ge $((woff + H)) ] && woff=$((wi - H + 1))
    printf '\e[H\e[1m %-28s %s\e[0m\e[K\n\e[K\n' "Themes" "Backgrounds${cur:+ - $cur}"
    for ((r = 0; r < H; r++)); do
      i=$((toff + r)); t=""; style=""
      if [ "$i" -lt "${#themes[@]}" ]; then
        t="${themes[i]}"; [ "$t" = "$cur" ] && t="$t *"
        if [ "$i" -eq "$ti" ]; then [ "$pane" -eq 0 ] && style='\e[7m' || style='\e[1m'; fi
      fi
      printf " $style%-27s\e[0m " "$t"
      i=$((woff + r)); t=""; style=""
      if [ "$i" -lt "${#mw[@]}" ]; then
        t="${mw[i]##*/}"
        if [ "$i" -eq "$wi" ]; then [ "$pane" -eq 1 ] && style='\e[7m' || style='\e[1m'; fi
      fi
      printf "$style%s\e[0m\e[K\n" "$t"
    done
    if [ "$pane" -eq 0 ]; then
      printf '\e[K\n\e[2m Up/Down move   Enter apply theme   Right backgrounds   q quit\e[0m\e[K\e[J'
    else
      printf '\e[K\n\e[2m Up/Down show background   Left themes   Enter or q done\e[0m\e[K\e[J'
    fi
  }

  load_walls
  printf '\e[?1049h\e[?25l'
  trap 'printf "\e[?25h\e[?1049l"' EXIT
  while true; do
    draw
    IFS= read -rsn1 key || break
    if [ "$key" = $'\e' ]; then
      rest=""; IFS= read -rsn2 -t 0.05 rest || true
      case "$rest" in "[A") key=up ;; "[B") key=down ;; "[C") key=right ;; "[D") key=left ;; *) key=left ;; esac
    fi
    case "$pane:$key" in
      *:q) break ;;
      0:up | 0:k) [ "$ti" -gt 0 ] && ti=$((ti - 1)) ;;
      0:down | 0:j) [ "$ti" -lt $((${#themes[@]} - 1)) ] && ti=$((ti + 1)) ;;
      0: | 0:right | 0:l) apply_theme; [ "${#mw[@]}" -gt 0 ] && pane=1 ;;
      1:up | 1:k) [ "$wi" -gt 0 ] && { wi=$((wi - 1)); show_wall "${mw[wi]}"; } ;;
      1:down | 1:j) [ "$wi" -lt $((${#mw[@]} - 1)) ] && { wi=$((wi + 1)); show_wall "${mw[wi]}"; } ;;
      1:left | 1:h) pane=0 ;;
      1:) break ;;
    esac
  done
  exit 0
}
# The same thing as rofi menus (SUPER + T, or `set-theme.sh --rofi`): pick a
# theme, then its backgrounds with thumbnails. Each background picked is shown
# live and the list stays open; Escape goes back to the themes, then closes.
rofi_menu() {
  local cur theme mw=() curw pick f
  while true; do
    cur="$(basename "$(readlink "$REPO/current" 2>/dev/null)" 2>/dev/null || true)"
    theme="$(ls -1 "$THEMES_DIR" | rofi -dmenu -i -p "Theme" -select "$cur")" || exit 0
    [ -d "$THEMES_DIR/$theme" ] || continue
    [ "$theme" = "$cur" ] || "${BASH_SOURCE[0]}" "$theme" >/dev/null 2>&1 || true
    mapfile -t mw < <(list_walls "$THEMES_DIR/$theme")
    [ "${#mw[@]}" -gt 0 ] || continue
    while true; do
      curw="$(basename "$(readlink "$HOME/.config/hypr/current-wallpaper" 2>/dev/null)" 2>/dev/null || true)"
      pick="$(for f in "${mw[@]}"; do printf '%s\0icon\x1f%s\n' "${f##*/}" "$f"; done \
        | rofi -dmenu -i -show-icons -p "Background ($theme)" -select "$curw")" || break
      [ -f "$THEMES_DIR/$theme/wallpapers/$pick" ] && show_wall "$THEMES_DIR/$theme/wallpapers/$pick"
    done
  done
}

if [ "${1:-}" = "--rofi" ]; then rofi_menu; fi
if [ $# -eq 0 ] && [ -t 0 ] && [ -t 1 ]; then menu; fi
if [ $# -eq 0 ] && [ -n "${WAYLAND_DISPLAY:-}" ] && command -v rofi >/dev/null 2>&1; then rofi_menu; fi

# Optional second argument: a wallpaper file name from the theme, or "random".
PICK="" # wallpaper file name, "random", or empty (= keep/auto, see below)
if [ $# -eq 2 ]; then PICK="$2"; set -- "$1"; fi

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
link "$SRC/hyprlock.conf" "$HOME/.config/hypr/hyprlock-theme.conf"

# --- wallpaper ---
# A named one if given; otherwise keep the current one when it already belongs
# to this theme (so a chosen background survives logins); otherwise random.
WALL=""
mapfile -t walls < <(list_walls "$SRC")
if [ "${#walls[@]}" -gt 0 ]; then
  CURWALL="$(readlink "$HOME/.config/hypr/current-wallpaper" 2>/dev/null || true)"
  if [ -n "$PICK" ] && [ "$PICK" != "random" ]; then
    [ -f "$SRC/wallpapers/$PICK" ] || { echo "error: no wallpaper '$PICK' in theme '$THEME'"; exit 1; }
    WALL="$SRC/wallpapers/$PICK"
  elif [ -z "$PICK" ] && [ "$(dirname "$CURWALL")" = "$SRC/wallpapers" ] && [ -f "$CURWALL" ]; then
    WALL="$CURWALL"
  else
    WALL="${walls[RANDOM % ${#walls[@]}]}"
  fi
  # hyprpaper.conf points at this stable symlink, so the wallpaper persists
  # across logins.
  ln -sfn "$WALL" "$HOME/.config/hypr/current-wallpaper"
  echo "  wallpaper: $(basename "$WALL")"
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
# hyprland: window border colours are read from the theme palette on reload
command -v hyprctl >/dev/null 2>&1 && hyprctl reload >/dev/null 2>&1 || true
# rofi has no daemon — it reads theme.rasi on its next launch.

echo "Done. Active theme: $THEME"
