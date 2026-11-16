# Gary's Computer Setup Repo

Reproducible Arch Linux + Hyprland desktop for all my machines:
`gary-desktop`, `gary-x1`, `gary-thinkpad`, `gary-starbook`.

Everything a machine needs lives here. Packages and system setup go in
`arch-hypr`; configs go in `dotfiles/`. Nothing is installed or configured by
hand.

## Setting up a machine

```sh
git clone https://github.com/garybowers/comp-setup.git
cd comp-setup
./arch-hypr
```

`arch-hypr` installs the packages, enables the services, and finishes by
copying the configs from `dotfiles/` into place. Reboot, then at the ly login
screen choose **Hyprland (uwsm-managed)** (ly remembers the choice).

## Updating configs

Edit the files under `dotfiles/` in this repo, then redeploy just the configs
(no packages, no sudo):

```sh
./arch-hypr --dotfiles
```

Configs are **copied**, not symlinked, so editing `~/.config` directly will be
overwritten on the next deploy. Anything already in place is moved aside to
`<name>.bak.<timestamp>` first.

## What gets installed where

| In `dotfiles/` | Goes to | What it is |
|---|---|---|
| `hypr/` | `~/.config/hypr/` | Hyprland (`hyprland.lua`), idle, lock screen, wallpaper, helper scripts |
| `hypr/hosts/` | `~/.config/hypr/hosts/` | Per-machine settings (see below) |
| `waybar/` | `~/.config/waybar/` | Bar |
| `rofi/` | `~/.config/rofi/` | Launcher |
| `kitty/` | `~/.config/kitty/` | Terminal |
| `themes/` | `~/.config/themes/` | Theme switcher — see `dotfiles/themes/README.md` |
| `qt6ct/` | `~/.config/qt6ct/` | Dark theme for Qt apps |
| `uwsm/` | `~/.config/uwsm/` | Session environment when logging in via uwsm |
| `systemd/user/waybar.service` | `~/.config/systemd/user/` | Bar as a restartable service |
| `chrome-flags.conf` | `~/.config/chrome-flags.conf` | Flags for every Chrome launch |
| `.bashrc`, `.vimrc` | `~/` | Shell and editor |

## Per-machine settings

`hyprland.lua` is identical on every machine. Anything machine-specific goes in
`dotfiles/hypr/hosts/`, picked by the name in `/etc/hostname`:

- `hosts/<hostname>.lua` — loaded by `hyprland.lua` (monitor layout and the
  like). If a machine has no file of its own, `hosts/default.lua` is used.
  Today every machine uses the default: two Lenovo 32" 4K monitors side by side.
- `hosts/<hostname>.no-suspend` — an empty marker. A machine that has one never
  suspends on idle (its monitors still turn off). `gary-desktop` has one so it
  stays reachable remotely; the laptops suspend.

## Keys worth knowing

`Super` is the main modifier.

| Keys | Action |
|---|---|
| `Super+Return` | Terminal |
| `Super+Space` | App launcher |
| `Alt+Tab` | Window switcher |
| `Super+R` | Emoji picker |
| `Super+=` | Calculator (Enter copies the result) |
| `Super+X` | Clipboard history |
| `Super+N` / `Super+Shift+N` | Notification panel / do-not-disturb |
| `Super+C` | Close window |
| `Super+V` | Toggle floating |
| `Super+Shift+F` | Fullscreen |
| `Super+J` | Flip split direction |
| `Super+arrows` | Move focus |
| `Super+Shift+arrows` | Move window |
| `Super+Ctrl+arrows` | Resize window |
| `Super+,` / `Super+.` | Focus monitor left / right |
| `Super+Shift+,` / `Super+Shift+.` | Move window to monitor left / right |
| `Super+1…0` / `Super+Shift+1…0` | Switch workspace / move window to it |
| `Super+S` / `Super+Shift+S` | Scratchpad / move window to it |
| `Print` | Screenshot a region to the clipboard |
| `Shift+Print` | Screenshot a region to `~/Pictures/Screenshots` and the clipboard |
| `Ctrl+Print` | Screenshot a region and annotate it (swappy) |
| `Super+Print` | Screenshot the focused monitor to file and clipboard |
| `Alt+Print` | Screenshot the active window to file and clipboard |
| `Super+Shift+R` | Start / stop recording a region to `~/Videos` (bar shows REC) |
| `Super+Shift+P` | Colour picker |
| `Super+L` | Lock |
| `Super+Shift+Q` | Power menu: lock, log out, suspend, reboot, shut down |

## Other files

- `install-arch`, `setup-arch`, `arch_install.md`, `blade14_arch.md` — notes and
  scripts for the base Arch install, before `arch-hypr` is run.
