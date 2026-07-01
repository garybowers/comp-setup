#!/usr/bin/env bash
#
# Toggle the built-in laptop panel (eDP-1) on lid events.
# Bound in hyprland.lua: switch:on / switch:off "Lid Switch" (locked = true).
#
#   lid open    -> always wake + re-enable the internal panel
#   lid closed  -> disable the internal panel ONLY if an external monitor
#                  is connected (clamshell/docked). With no external, leave
#                  it on and let systemd-logind suspend the machine.
#
# Division of labour: logind owns suspend, this script owns eDP-1.

set -euo pipefail

LAPTOP="eDP-1"

# Lid state file name varies (LID, LID0, ...), so glob it.
lid_state="$(cat /proc/acpi/button/lid/*/state 2>/dev/null || true)"

enable_laptop() {
	hyprctl dispatch dpms on
	hyprctl eval 'hl.monitor({ output = "eDP-1", disabled = false })'
}

disable_laptop() {
	hyprctl eval 'hl.monitor({ output = "eDP-1", disabled = true })'
}

# Count active monitors that are NOT the laptop panel.
external_count() {
	hyprctl monitors -j | jq --arg l "$LAPTOP" '[.[] | select(.name != $l)] | length'
}

if grep -q open <<<"$lid_state"; then
	enable_laptop
elif [[ "$(external_count)" -gt 0 ]]; then
	disable_laptop
fi
# Lid closed with no external monitor: do nothing; logind suspends.
