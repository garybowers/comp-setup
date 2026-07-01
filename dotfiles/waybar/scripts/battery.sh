#!/usr/bin/env bash
# Portable Waybar battery module.
#   - Shows the system battery (laptop) on the bar.
#   - Lists peripheral batteries (mouse / headphones / keyboard) in the tooltip.
#   - Works on any machine: no hardcoded battery name or device models.
#   - Hides itself on desktops with no battery and no wireless peripherals.
#   - Pure-ASCII source: every glyph is emitted via printf '\uXXXX', so there
#     are no Nerd Font bytes stored in this file (portable + un-strippable).
#
# Output: Waybar JSON  {text, tooltip, class, percentage}

g() { printf "$1"; }   # emit a glyph from an escape, e.g. g ''

# upower is the only dependency; degrade gracefully if absent.
command -v upower >/dev/null 2>&1 || { echo '{"text":"","tooltip":""}'; exit 0; }

text=""; tip=""; cls=""; cap=0

# ---------- system (laptop) battery ----------
sysbat=$(upower -e 2>/dev/null | grep -m1 -E '/battery_BAT')
if [[ -n $sysbat ]]; then
  info=$(upower -i "$sysbat" 2>/dev/null)
  cap=$(sed -n 's/.*percentage: *//p' <<<"$info" | head -1 | tr -dc '0-9'); cap=${cap:-0}
  state=$(sed -n 's/.*state: *//p'    <<<"$info" | head -1 | awk '{print $1}')
  case "$state" in
    charging|pending-charge) ico=$(g ''); cls=charging ;;   # bolt
    fully-charged)           ico=$(g ''); cls=plugged  ;;   # plug
    *)
      if   (( cap >= 90 )); then ico=$(g '')
      elif (( cap >= 65 )); then ico=$(g '')
      elif (( cap >= 40 )); then ico=$(g '')
      elif (( cap >= 15 )); then ico=$(g '')
      else                       ico=$(g ''); fi
      if   (( cap <= 15 )); then cls=critical
      elif (( cap <= 30 )); then cls=warning; fi ;;
  esac
  text="${cap}% ${ico}"
  tip="$(g '')  Laptop  ${cap}%  (${state//-/ })"
fi

# ---------- peripherals ----------
periph=0
for d in $(upower -e 2>/dev/null | grep -E 'battery_hidpp|headset_|mouse_|keyboard_'); do
  di=$(upower -i "$d" 2>/dev/null)
  model=$(sed -n 's/.*model: *//p'       <<<"$di" | head -1 | sed 's/ *$//; s/"//g')
  pct=$(sed -n 's/.*percentage: *//p'    <<<"$di" | head -1 | awk '{print $1}')
  lvl=$(sed -n 's/.*battery-level: *//p' <<<"$di" | head -1 | awk '{print $1}')
  [[ -z $model ]] && model="Device"

  # hidpp mice report a coarse battery-level; prefer it when % is flagged ignored
  if grep -q 'should be ignored' <<<"$di" && [[ -n $lvl && $lvl != none ]]; then
    val="$lvl"
  else
    val="$pct"
  fi
  [[ -z $val ]] && continue

  if   [[ $d == *headset* || $model == *Ear* || $model == *Head* ]]; then gi=''        # headphones
  elif [[ $d == *hidpp*   || $d == *mouse*  ]];                       then gi='\U000f037d'   # mouse
  elif [[ $d == *keyboard* ]];                                        then gi=''       # keyboard
  else                                                                    gi=''; fi    # generic
  line="$(g "$gi")  ${model}  ${val}"
  [[ -z $tip ]] && tip="$line" || tip="${tip}\\n${line}"
  periph=1
done

# ---------- nothing present: hide module ----------
if [[ -z $sysbat && $periph -eq 0 ]]; then
  echo '{"text":"","tooltip":""}'; exit 0
fi

# Desktop (no system battery) but peripherals exist: show a small mouse glyph.
[[ -z $sysbat ]] && text="$(g '\U000f037d')"

printf '{"text":"%s","tooltip":"%s","class":"%s","percentage":%s}\n' \
  "$text" "$tip" "$cls" "${cap:-0}"
