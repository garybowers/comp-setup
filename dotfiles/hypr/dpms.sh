#!/usr/bin/env bash
#
# State-aware DPMS for hypridle: `dpms.sh off` / `dpms.sh on`.
#
# Why: on this lua-config Hyprland the dpms dispatcher IGNORES its mode arg and
# always TOGGLES (see dpms-resume.sh). A blind dpms call from hypridle inverts
# whatever mixed state the monitors are in, so we read each monitor's
# dpmsStatus and only toggle the ones in the wrong state.
#
# The "off" case also re-asserts once after a delay: when the Dells enter deep
# sleep they drop their DP link, and the resulting hotplug reconfigure wakes
# the still-connected Lenovo. The second pass puts it back to sleep.

set -euo pipefail

want=$1 # "on" or "off"
[[ $want == on ]] && target=true || target=false

assert_state() {
	local name
	for name in $(hyprctl monitors -j | jq -r --argjson t "$target" \
		'.[] | select(.dpmsStatus != $t) | .name'); do
		hyprctl eval "hl.dispatch(hl.dsp.dpms({ mode = \"${want}\", monitor = \"${name}\" }))" >/dev/null
	done
}

assert_state

if [[ $want == off ]]; then
	sleep 5
	assert_state
fi
