#!/usr/bin/env bash
# Waybar custom audio visualizer driven by the `cava` CLI in raw mode
# (this Waybar build has no compiled-in cava module).
#
# Portable: only needs `cava`. Bars are Unicode block glyphs U+2581..U+2588,
# generated via printf escapes so the source stays pure ASCII.
#
# Leak-safe: cava + sed run in the background and are killed on exit/signal,
# so Waybar reloads don't orphan cava processes.

command -v cava >/dev/null 2>&1 || { echo ""; exit 0; }

bars=12

# level 0..7 -> block glyph (lowest .. full)
levels=()
for cp in 2581 2582 2583 2584 2585 2586 2587 2588; do
  levels+=("$(printf "\\u$cp")")
done

# sed program: strip ';' separators, map each digit to its glyph
dict="s/;//g"
for i in 0 1 2 3 4 5 6 7; do
  dict="${dict};s/$i/${levels[$i]}/g"
done

config=$(mktemp)
fifo=$(mktemp -u); mkfifo "$fifo"
cat > "$config" <<CFG
[general]
mode = normal
framerate = 12
bars = $bars
[input]
method = pulse
source = auto
[output]
method = raw
raw_target = $fifo
data_format = ascii
ascii_max_range = 7
CFG

cleanup() { kill "$CAVA" "$SED" 2>/dev/null; rm -f "$config" "$fifo"; }
trap cleanup EXIT INT TERM HUP

cava -p "$config" &        # writes raw digit frames to the fifo
CAVA=$!
sed -u "$dict" < "$fifo" & # maps digits -> glyphs, prints to stdout for Waybar
SED=$!
wait
