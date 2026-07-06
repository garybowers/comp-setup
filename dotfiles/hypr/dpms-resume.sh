#!/usr/bin/env bash
#
# Wake external DisplayPort (USB-C alt-mode) monitors after suspend.
# Called from hypridle's after_sleep_cmd.
#
# Why: HDMI holds its link through suspend and wakes on its own. USB-C/DP
# monitors (the Dell U2721DE / P2720DC) drop their DP link on suspend and DO
# NOT retrain on resume -- Hyprland reports them as on (dpms=true) but the
# panel shows no signal. `hyprctl reload` is not enough; only tearing the
# output down and rebuilding it re-establishes the link. This is the software
# version of the physical off/on. The DP-N index can change across a resume,
# so we key by monitor description, not name.
#
# NOTE: this is a Lua-config (non-legacy) Hyprland (configProvider: lua), so we
# drive it through `hyprctl eval 'hl.*'` -- the `hyprctl dispatch`/`keyword`
# string forms do not work here. The dpms dispatcher also IGNORES its mode arg
# and always TOGGLES, so we never issue a blind dpms call: we read each
# monitor's dpmsStatus and only toggle the ones that are OFF.

set -euo pipefail

# Turn a single monitor on, but only if it is currently off (dpms is toggle-only).
ensure_on() {
	local name=$1 st
	st=$(hyprctl monitors -j | jq -r --arg n "$name" '.[] | select(.name==$n) | .dpmsStatus')
	if [[ "$st" == "false" ]]; then
		hyprctl eval "hl.dispatch(hl.dsp.dpms({ mode = \"on\", monitor = \"${name}\" }))" >/dev/null
	fi
}

# Re-train the USB-C monitors that drop their link on suspend: the Dells.
# Selected and re-applied BY DESCRIPTION -- the DP-N name shifts across resumes
# (DP-11 -> DP-9, etc.), so never key off the name. Capture each one's current
# geometry, disable it, then re-enable at the same mode/pos/scale.
mapfile -t dp < <(hyprctl monitors -j \
	| jq -r '.[] | select(.description | test("Dell"))
	         | "\(.description)\t\(.x)x\(.y)\t\(.scale)"')

for line in "${dp[@]}"; do
	IFS=$'\t' read -r desc pos scale <<<"$line"
	hyprctl eval "hl.monitor({ output = \"desc:${desc}\", disabled = true })" >/dev/null
done

[[ ${#dp[@]} -gt 0 ]] && sleep 1

for line in "${dp[@]}"; do
	IFS=$'\t' read -r desc pos scale <<<"$line"
	hyprctl eval "hl.monitor({ output = \"desc:${desc}\", disabled = false, mode = \"preferred\", position = \"${pos}\", scale = \"${scale}\" })" >/dev/null
done

# Give the re-enabled outputs a moment to settle, then make sure every monitor
# is powered on (re-enabling an output leaves it DPMS-off). Already-on monitors
# are skipped, so nothing that is working gets darkened.
[[ ${#dp[@]} -gt 0 ]] && sleep 1

for name in $(hyprctl monitors -j | jq -r '.[].name'); do
	ensure_on "$name"
done
