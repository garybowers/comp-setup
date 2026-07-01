#!/usr/bin/env bash
# AMD GPU load + temperature for Waybar.
# Portable: scans every DRM card for the amdgpu busy-percent sysfs node.
# Prints e.g. "12% 55°C" ( ° via printf escape -> pure-ASCII source ),
# or just "12%" if no temp sensor, or "" if no AMD GPU is present.

for d in /sys/class/drm/card*/device; do
  [ -r "$d/gpu_busy_percent" ] || continue
  load=$(cat "$d/gpu_busy_percent" 2>/dev/null)
  [ -n "$load" ] || continue

  temp=""
  for h in "$d"/hwmon/hwmon*/temp1_input; do
    [ -r "$h" ] || continue
    t=$(cat "$h" 2>/dev/null)
    [ -n "$t" ] && temp=$(( t / 1000 ))
    break
  done

  if [ -n "$temp" ]; then
    printf '%s%% %s°C\n' "$load" "$temp"
  else
    printf '%s%%\n' "$load"
  fi
  exit 0
done
echo ""
