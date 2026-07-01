# Desktop themes

Rudimentary theme system for Hyprland + waybar + kitty + rofi. Each theme is a
folder of asset files; switching re-points the symlinks that the app configs
import, then live-reloads the apps.

## Available themes

| Theme | Mood |
|-------|------|
| `tokyo-night` | cyberpunk neon (default) |
| `gruvbox` | warm retro, no neon |
| `nord` | calm arctic blue, minimal |
| `catppuccin-mocha` | cozy pastel dark |
| `catppuccin-latte` | light (daytime) |

## Switch theme

```sh
./set-theme.sh <name>        # e.g. ./set-theme.sh nord
./set-theme.sh               # list available themes
```

The active theme is recorded by the `current` symlink. Hyprland also runs
`set-theme.sh` at login (re-applies `current`, re-randomises wallpaper).

## Layout

```
themes/<name>/
  waybar.css            @define-color palette ONLY (see waybar note below)
  kitty.conf            kitty color block
  rofi.rasi             rofi color variables
  wallpapers/*.{jpg,png}  one or more wallpapers (random pick on switch)
```

### Waybar is variable-based

`~/.config/waybar/style.css` holds the full shared layout (islands, glows,
animations) and references colors as `@bg @fg @accent @glow @red @green @teal
@purple @orange @yellow @cyan @crit @hi @dim @bgdeep`. A theme's `waybar.css`
only `@define-color`s those — so the bar looks identical across themes, only
recolored. To add a theme, copy an existing `waybar.css` and change the hexes.

## Add a theme

1. Copy an existing folder under `themes/` to `themes/<new-name>/`.
2. Edit the three files (waybar palette, kitty colors, rofi vars).
3. Drop wallpaper(s) into `wallpapers/` (optional — without any, switching
   keeps the current wallpaper).
4. `./set-theme.sh <new-name>`.

## Wallpapers

The repo ships **no wallpapers** (only the original `tokyo-night/bg1.jpg`).
Drop your own into each theme's `wallpapers/`. Official packs exist for
Catppuccin / Gruvbox / Nord. With multiple images, one is picked at random on
each switch / login.

## Using this repo on another machine

1. Clone it to `~/.config/themes`.
2. Apply the one-time base-config edits (per machine):
   - `~/.config/waybar/style.css`  → shared layout, `@import "theme.css";` first
   - `~/.config/kitty/kitty.conf`  → `include theme.conf` (at end)
   - `~/.config/rofi/config.rasi`  → `@import "theme.rasi"`
   - `~/.config/hypr/hyprpaper.conf` → `path = ~/.config/hypr/current-wallpaper`
3. Run `./set-theme.sh <name>` once to create the symlinks.
