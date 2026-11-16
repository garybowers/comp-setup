--###############
--## MONITORS ###
--###############

-- See https://wiki.hyprland.org/Configuring/Monitors/
--monitor=,preferred,auto,1
-- Laptop Screen
hl.monitor({
	output = "eDP-1",
	mode = "preferred",
	position = "auto",
	scale = "1",
})

-- Fallback for any monitor not named explicitly
hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "1",
})

--######################
--## PER-HOST CONFIG ###
--######################

-- Machine-specific settings (external monitor layout, etc.) live in
-- hosts/<hostname>.lua so this file stays identical on every machine.
-- If there is no file for this hostname, hosts/default.lua is used.
-- (hypridle's suspend-on-idle is per-host too: see hypridle.conf.)
do
	local dir = (os.getenv("XDG_CONFIG_HOME") or (os.getenv("HOME") .. "/.config")) .. "/hypr/hosts/"
	local host = "default"
	local f = io.open("/etc/hostname", "r")
	if f then
		host = (f:read("*l") or ""):gsub("%s+", "")
		f:close()
	end
	local path = dir .. host .. ".lua"
	local probe = io.open(path, "r")
	if probe then
		probe:close()
	else
		path = dir .. "default.lua"
	end
	dofile(path)
end

--##################
--## MY PROGRAMS ###
--##################

-- See https://wiki.hyprland.org/Configuring/Keywords/

-- Set programs that you use
local terminal = "kitty"
local fileManager = "nautilus"
local menu = "rofi -show combi"
local browser = "firefox"
local browseralt = "google-chrome-stable" -- flags live in ~/.config/chrome-flags.conf

--################
--## AUTOSTART ###
--################

hl.on("hyprland.start", function()
	hl.exec_cmd("kdeconnect-indicator")
end)
--exec-once = easyeffects --gapplication-service &

--for libadwaita gtk4 apps you can use this command:

--for gtk3 apps you need to install adw-gtk3 theme (in arch linux sudo pacman -S adw-gtk-theme)

--for kde apps you need to install: sudo pacman -S qt5ct qt6ct kvantum kvantum breeze-icons
--you will need to set dark theme for qt apps from kde more difficult thans with gnome :D:
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")

--############################
--## ENVIRONMENT VARIABLES ###
--############################

-- See https://wiki.hyprland.org/Configuring/Environment-variables/

-- One cursor theme and size everywhere (package: adwaita-cursors).
-- GTK apps get the same via gsettings in the config.reloaded hook below.
hl.env("XCURSOR_THEME", "Adwaita")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

--##################
--## PERMISSIONS ###
--##################

-- See https://wiki.hyprland.org/Configuring/Permissions/
-- Please note permission changes here require a Hyprland restart and are not applied on-the-fly
-- for security reasons

-- ecosystem {
--   enforce_permissions = 1
-- }

-- permission = /usr/(bin|local/bin)/grim, screencopy, allow
-- permission = /usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland, screencopy, allow
-- permission = /usr/(bin|local/bin)/hyprpm, plugin, allow

--####################
--## LOOK AND FEEL ###
--####################

-- Refer to https://wiki.hyprland.org/Configuring/Variables/

-- https://wiki.hyprland.org/Configuring/Variables/#general

hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1.0 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })
hl.animation({
	leaf = "global",
	enabled = true,
	speed = 10,
	bezier = "default",
})
hl.animation({
	leaf = "border",
	enabled = true,
	speed = 5.39,
	bezier = "easeOutQuint",
})
hl.animation({
	leaf = "windows",
	enabled = true,
	speed = 4.79,
	bezier = "easeOutQuint",
})
hl.animation({
	leaf = "windowsIn",
	enabled = true,
	speed = 4.1,
	bezier = "easeOutQuint",
	style = "popin 87%",
})
hl.animation({
	leaf = "windowsOut",
	enabled = true,
	speed = 1.49,
	bezier = "linear",
	style = "popin 87%",
})
hl.animation({
	leaf = "fadeIn",
	enabled = true,
	speed = 1.73,
	bezier = "almostLinear",
})
hl.animation({
	leaf = "fadeOut",
	enabled = true,
	speed = 1.46,
	bezier = "almostLinear",
})
hl.animation({
	leaf = "fade",
	enabled = true,
	speed = 3.03,
	bezier = "quick",
})
hl.animation({
	leaf = "layers",
	enabled = true,
	speed = 3.81,
	bezier = "easeOutQuint",
})
hl.animation({
	leaf = "layersIn",
	enabled = true,
	speed = 4,
	bezier = "easeOutQuint",
	style = "fade",
})
hl.animation({
	leaf = "layersOut",
	enabled = true,
	speed = 1.5,
	bezier = "linear",
	style = "fade",
})
hl.animation({
	leaf = "fadeLayersIn",
	enabled = true,
	speed = 1.79,
	bezier = "almostLinear",
})
hl.animation({
	leaf = "fadeLayersOut",
	enabled = true,
	speed = 1.39,
	bezier = "almostLinear",
})
hl.animation({
	leaf = "workspaces",
	enabled = true,
	speed = 1.94,
	bezier = "almostLinear",
	style = "fade",
})
hl.animation({
	leaf = "workspacesIn",
	enabled = true,
	speed = 1.21,
	bezier = "almostLinear",
	style = "fade",
})
hl.animation({
	leaf = "workspacesOut",
	enabled = true,
	speed = 1.94,
	bezier = "almostLinear",
	style = "fade",
})

hl.gesture({
	fingers = 4,
	direction = "horizontal",
	action = "workspace",
})

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd(browseralt))
-- Power menu (rofi): lock, log out, suspend, reboot, shut down. Esc cancels.
-- Log out uses `uwsm stop` under uwsm so units shut down in order.
hl.bind(
	mainMod .. " + SHIFT + Q",
	hl.dsp.exec_cmd(
		[[c=$(printf 'Lock\nLog out\nSuspend\nReboot\nShut down' | rofi -dmenu -i -p 'Power'); case "$c" in Lock) loginctl lock-session ;; "Log out") systemctl --user is-active -q 'wayland-wm@*.service' && uwsm stop || hyprctl eval 'hl.dispatch(hl.dsp.exit())' ;; Suspend) systemctl suspend ;; Reboot) systemctl reboot ;; "Shut down") systemctl poweroff ;; esac]]
	)
)
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("rofi -modi emoji -show emoji")) -- emoji picker (launcher is SUPER + SPACE)
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit")) -- dwindle: flip the split direction

hl.bind(mainMod .. " + X", hl.dsp.exec_cmd('cliphist list | rofi -dmenu -p "clipboard" | cliphist decode | wl-copy'))
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("hyprpicker -a"))
-- Calculator: result updates as you type; Enter copies it to the clipboard
hl.bind(
	mainMod .. " + equal",
	hl.dsp.exec_cmd([[rofi -show calc -modi calc -no-show-match -no-sort -calc-command "echo -n '{result}' | wl-copy"]])
)
-- Lock: mute while locked, then restore on unlock (only if it wasn't already
-- muted beforehand). hyprlock blocks until unlocked.
hl.bind(
	mainMod .. " + L",
	hl.dsp.exec_cmd(
		[[pidof hyprlock || { m=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -c MUTED); wpctl set-mute @DEFAULT_AUDIO_SINK@ 1; hyprlock; [ "$m" = 0 ] && wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; }]]
	)
)
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(menu))
-- Window switcher: every open window on all monitors; type to filter, Enter to jump
hl.bind("ALT + TAB", hl.dsp.exec_cmd("rofi -show window -modi window"))
-- Notifications (swaync): open/close the panel, toggle do-not-disturb
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("swaync-client --toggle-panel --skip-wait"))
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd("swaync-client --toggle-dnd --skip-wait"))

-- Shift+Print: region -> ~/Pictures/Screenshots/<timestamp>.png AND clipboard
hl.bind(
	"SHIFT + print",
	hl.dsp.exec_cmd(
		[[g=$(slurp) && mkdir -p "$HOME/Pictures/Screenshots" && grim -g "$g" - | tee "$HOME/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png" | wl-copy]]
	)
)
-- Print: region -> clipboard only
hl.bind("print", hl.dsp.exec_cmd("slurp | grim -g - - | wl-copy"))
-- Ctrl+Print: region -> swappy, to draw arrows/text before saving or copying
hl.bind("CTRL + print", hl.dsp.exec_cmd([[g=$(slurp) && grim -g "$g" - | swappy -f -]]))
-- Super+Print: the whole focused monitor -> Screenshots folder AND clipboard
hl.bind(
	mainMod .. " + print",
	hl.dsp.exec_cmd(
		[[mkdir -p "$HOME/Pictures/Screenshots" && grim -o "$(hyprctl monitors -j | jq -r '.[] | select(.focused) | .name')" - | tee "$HOME/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png" | wl-copy]]
	)
)
-- Alt+Print: the active window -> Screenshots folder AND clipboard
hl.bind(
	"ALT + print",
	hl.dsp.exec_cmd(
		[[g=$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"') && mkdir -p "$HOME/Pictures/Screenshots" && grim -g "$g" - | tee "$HOME/Pictures/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).png" | wl-copy]]
	)
)
-- Super+Shift+R: start/stop recording a region to ~/Videos (wf-recorder).
-- The bar shows "REC" while it runs; clicking that also stops it.
hl.bind(
	mainMod .. " + SHIFT + R",
	hl.dsp.exec_cmd(
		[[if pgrep -x wf-recorder >/dev/null; then pkill -INT -x wf-recorder && notify-send 'Recording saved' "$HOME/Videos"; else g=$(slurp) && mkdir -p "$HOME/Videos" && wf-recorder -g "$g" -f "$HOME/Videos/recording_$(date +%Y-%m-%d_%H-%M-%S).mp4"; fi]]
	)
)

hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.move({ direction = "d" }))

-- Resize the active window from the keyboard
hl.bind(mainMod .. " + CTRL + left", hl.dsp.window.resize({ x = -40, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.resize({ x = 40, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + up", hl.dsp.window.resize({ x = 0, y = -40, relative = true }), { repeating = true })
hl.bind(mainMod .. " + CTRL + down", hl.dsp.window.resize({ x = 0, y = 40, relative = true }), { repeating = true })

-- Focus the monitor to the left / right, and move the active window there
hl.bind(mainMod .. " + comma", hl.dsp.focus({ monitor = "l" }))
hl.bind(mainMod .. " + period", hl.dsp.focus({ monitor = "r" }))
hl.bind(mainMod .. " + SHIFT + comma", hl.dsp.window.move({ monitor = "l" }))
hl.bind(mainMod .. " + SHIFT + period", hl.dsp.window.move({ monitor = "r" }))

hl.bind(mainMod .. " + 1", hl.dsp.focus({ workspace = 1 }))
hl.bind(mainMod .. " + 2", hl.dsp.focus({ workspace = 2 }))
hl.bind(mainMod .. " + 3", hl.dsp.focus({ workspace = 3 }))
hl.bind(mainMod .. " + 4", hl.dsp.focus({ workspace = 4 }))
hl.bind(mainMod .. " + 5", hl.dsp.focus({ workspace = 5 }))
hl.bind(mainMod .. " + 6", hl.dsp.focus({ workspace = 6 }))
hl.bind(mainMod .. " + 7", hl.dsp.focus({ workspace = 7 }))
hl.bind(mainMod .. " + 8", hl.dsp.focus({ workspace = 8 }))
hl.bind(mainMod .. " + 9", hl.dsp.focus({ workspace = 9 }))
hl.bind(mainMod .. " + 0", hl.dsp.focus({ workspace = 10 }))

hl.bind(mainMod .. " + SHIFT + 1", hl.dsp.window.move({ workspace = 1 }))
hl.bind(mainMod .. " + SHIFT + 2", hl.dsp.window.move({ workspace = 2 }))
hl.bind(mainMod .. " + SHIFT + 3", hl.dsp.window.move({ workspace = 3 }))
hl.bind(mainMod .. " + SHIFT + 4", hl.dsp.window.move({ workspace = 4 }))
hl.bind(mainMod .. " + SHIFT + 5", hl.dsp.window.move({ workspace = 5 }))
hl.bind(mainMod .. " + SHIFT + 6", hl.dsp.window.move({ workspace = 6 }))
hl.bind(mainMod .. " + SHIFT + 7", hl.dsp.window.move({ workspace = 7 }))
hl.bind(mainMod .. " + SHIFT + 8", hl.dsp.window.move({ workspace = 8 }))
hl.bind(mainMod .. " + SHIFT + 9", hl.dsp.window.move({ workspace = 9 }))
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

hl.bind("CTRL + ALT + " .. mainMod .. " + SHIFT + left", function()
	local w = hl.get_active_workspace()
	if not w then
		return
	end
	hl.dispatch(hl.dsp.workspace.move({ workspace = w.id, monitor = "l" }))
end)
hl.bind("CTRL + ALT + " .. mainMod .. " + SHIFT + right", function()
	local w = hl.get_active_workspace()
	if not w then
		return
	end
	hl.dispatch(hl.dsp.workspace.move({ workspace = w.id, monitor = "r" }))
end)

hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag())
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize())

-- Volume, mute, brightness and media keys go through swayosd so they show an
-- on-screen display. Caps/Num Lock OSD comes from swayosd-libinput-backend
-- (a system service enabled by arch-hypr).
-- (swayosd-server is started in the hyprland.start hook below). 5% steps, capped at 100%.
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("swayosd-client --output-volume raise --max-volume 100"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("swayosd-client --output-volume lower --max-volume 100"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("swayosd-client --input-volume mute-toggle"),
	{ locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("swayosd-client --brightness raise"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("swayosd-client --brightness lower"), { locked = true, repeating = true })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("swayosd-client --playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("swayosd-client --playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("swayosd-client --playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("swayosd-client --playerctl prev"), { locked = true })

hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd("/home/gary/.config/hypr/switch.sh"), { locked = true })
hl.bind("switch:off:Lid Switch", hl.dsp.exec_cmd("/home/gary/.config/hypr/switch.sh"), { locked = true })

hl.window_rule({
	name = "suppress-maximize-events",
	match = {
		class = ".*",
	},
	-- Ignore maximize requests from all apps. You'll probably like this.
	suppress_event = "maximize",
})

hl.window_rule({
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	-- Fix some dragging issues with XWayland
	no_focus = true,
})

hl.window_rule({
	name = "fix-google-meet-sharing",
	match = {
		title = "^(.*is sharing your screen.*)$",
	},
	-- Match the title (adjust regex if your browser language isn't English)
	float = true,
	-- Moves it to the bottom-right corner (20px offset)
	move = "(monitor_w-window_w-20) (monitor_h-window_h-20)",
	pin = true,
	no_initial_focus = true,
})

-- Small utility windows open floating and centred instead of tiling
hl.window_rule({
	name = "float-utilities",
	match = { class = "^(org\\.pulseaudio\\.pavucontrol|nwg-look|qalculate-gtk|xdg-desktop-portal-gtk)$" },
	float = true,
	center = true,
	size = "1000 700",
})

-- Float all Steam child windows (Friends List, settings, toasts)
hl.window_rule({
    name = "steam-float",
    match = { class = "^(steam)$" },
    float = true,
})

-- Main Steam window tiles instead
hl.window_rule({
    name = "steam-main-tile",
    match = { class = "^(steam)$", title = "^(Steam)$" },
    float = false,
})

-- Native Steam games fullscreen
hl.window_rule({
    name = "steam-games-fullscreen",
    match = { class = "^(steam_app_\\d+)$" },
    fullscreen = true,
})

hl.config({
	general = {
		gaps_in = 2,
		gaps_out = 3,
		border_size = 2,
		-- https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
		col = {
			active_border = { colors = { "rgba(7dcfffee)", "rgba(bb9af7ee)", "rgba(f7768eee)" }, angle = 45 },
			inactive_border = "rgba(414868aa)",
		},
		-- Set to true enable resizing windows by clicking and dragging on borders and gaps
		resize_on_border = true,
		-- Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
		allow_tearing = false,
		layout = "dwindle",
	},
	-- https://wiki.hyprland.org/Configuring/Variables/#decoration
	decoration = {
		rounding = 5,
		rounding_power = 2,
		-- Change transparency of focused and unfocused windows
		-- (inactive windows go slightly translucent so the wallpaper glows through)
		-- Dim unfocused windows slightly so the focused one stands out
		dim_inactive = true,
		dim_strength = 0.12,
		active_opacity = 1.0,
		inactive_opacity = 1.0,
		-- Soft shadow with just a hint of neon tint
		shadow = {
			enabled = true,
			range = 5,
			render_power = 2,
			color = "rgba(7aa2f722)",
		},
		-- https://wiki.hyprland.org/Configuring/Variables/#blur
		blur = {
			enabled = true,
			size = 6,
			passes = 2,
			vibrancy = 0.1696,
		},
	},
	-- https://wiki.hyprland.org/Configuring/Variables/#animations
	animations = {
		enabled = true,
		-- Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
	},
	-- Ref https://wiki.hyprland.org/Configuring/Workspace-Rules/
	-- "Smart gaps" / "No gaps when only"
	-- uncomment all if you wish to use that.
	-- workspace = w[tv1], gapsout:0, gapsin:0
	-- workspace = f[1], gapsout:0, gapsin:0
	-- windowrule = bordersize 0, floating:0, onworkspace:w[tv1]
	-- windowrule = rounding 0, floating:0, onworkspace:w[tv1]
	-- windowrule = bordersize 0, floating:0, onworkspace:f[1]
	-- windowrule = rounding 0, floating:0, onworkspace:f[1]
	-- See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
	dwindle = {
		--    pseudotile = true # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
		preserve_split = true, -- You probably want this
	},
	-- See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
	master = {
		new_status = "master",
	},
	-- https://wiki.hyprland.org/Configuring/Variables/#misc
	misc = {
		force_default_wallpaper = 0,
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		-- Wake the monitors on any key press / mouse movement (safety net
		-- alongside hypridle's dpms.sh on-resume).
		key_press_enables_dpms = true,
		mouse_move_enables_dpms = true,
	},
	--############
	--## INPUT ###
	--############
	-- https://wiki.hyprland.org/Configuring/Variables/#input
	input = {
		kb_layout = "gb",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",
		follow_mouse = 1,
		sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.
		touchpad = {
			natural_scroll = false,
		},
	},
	-- Logging off: with it on, hyprland.log grows by ~75 MB/day in
	-- /run/user (tmpfs = RAM). Flip both to debug a problem.
	debug = {
		disable_logs = true,
		enable_stdout_logs = false,
	},
	ecosystem = {
		no_update_news = true,
		no_donation_nag = true,
	},
})

hl.on("hyprland.start", function()
	-- 1. Apply the last-used theme (default: tokyo-night) FIRST, so its symlinks
	--    (waybar.css / current-wallpaper / ...) exist before the services below
	--    read them. Also re-randomises the wallpaper each login and recreates
	--    the symlinks if missing (fresh machine). See ~/.config/themes/set-theme.sh.
	-- 2. Start the desktop services as systemd user units, so they restart on
	--    failure and stop cleanly at logout. This works the same whether the
	--    session was started plainly or through uwsm ("Hyprland (uwsm-managed)"
	--    at the login screen): starting an already-running unit is a no-op.
	--    import-environment gives the units the Wayland env they need.
	--      waybar          bar (unit: ~/.config/systemd/user/waybar.service)
	--      hyprpaper       wallpaper
	--      hypridle        idle lock / monitor off / suspend
	--      swaync          notifications
	--      hyprpolkitagent privilege prompts
	--      cliphist        clipboard history watcher
	hl.exec_cmd(
		'T=$(basename "$(readlink ~/.config/themes/current 2>/dev/null)" 2>/dev/null); ~/.config/themes/set-theme.sh "${T:-tokyo-night}"; systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE; for u in waybar hyprpaper hypridle swaync hyprpolkitagent cliphist; do systemctl --user start "$u.service"; done'
	)
	-- These have no systemd unit, so they are launched directly.
	hl.exec_cmd("swayosd-server &")
	hl.exec_cmd("easyeffects --service-mode &")
end)

hl.on("config.reloaded", function()
	hl.exec_cmd('gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"')
	hl.exec_cmd('gsettings set org.gnome.desktop.interface gtk-theme "Pop"')
	hl.exec_cmd('gsettings set org.gnome.desktop.interface cursor-theme "Adwaita"')
	hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-size 24")
end)
