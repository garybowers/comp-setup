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

hl.monitor({
	output = "desc:Dell Inc. DELL U2721DE CTP3623",
	mode = "preferred",
	position = "0x0",
	scale = "1",
})

hl.monitor({
	output = "desc: Lenovo Group Limited T32p-30 V30DH3TX",
	mode = "preferred",
	position = "2560x0",
	scale = "1",
})

hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "1",
})

--##################
--## MY PROGRAMS ###
--##################

-- See https://wiki.hyprland.org/Configuring/Keywords/

-- Set programs that you use
local terminal = "kitty"
local fileManager = "nautilus"
local menu = "rofi -show combi"
local browser = "firefox"
local browseralt = "/sbin/google-chrome-stable --disable-features=WaylandWpColorManagerV1"

--################
--## AUTOSTART ###
--################

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

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "32")

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
	-- TODO: manual review — extra gesture field ""
})

hl.device({
	name = "epic-mouse-v1",
	sensitivity = -0.5,
})

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd(browseralt))
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exit())
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())

hl.bind(mainMod .. " + X", hl.dsp.exec_cmd('cliphist list | rofi -dmenu -p "clipboard" | cliphist decode | wl-copy'))
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("hyprpicker -a"))
hl.bind(mainMod .. " + equal", hl.dsp.exec_cmd("rofi -show calc -modi calc -no-show-match -no-sort"))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ 1 && hyprlock"))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(menu))

hl.bind(
	"SHIFT + print",
	hl.dsp.exec_cmd("slurp | grim -g - - | tee ~/Pictures/screenshot_$(date +'%Y-%m-%d %H:%M:%S').png")
)
hl.bind("print", hl.dsp.exec_cmd("slurp | grim -g - - | wl-copy"))

hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.move({ direction = "d" }))

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

hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

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
	},
	--############
	--## INPUT ###
	--############
	-- https://wiki.hyprland.org/Configuring/Variables/#input
	input = {
		kb_layout = "gb",
		kb_variant = ",qwerty",
		kb_model = "",
		kb_options = "",
		kb_rules = "",
		follow_mouse = 1,
		sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.
		touchpad = {
			natural_scroll = false,
		},
	},
	-- Gestures
	-- Example per-device config
	-- See https://wiki.hyprland.org/Configuring/Keywords/#per-device-input-configs for more
	debug = {
		disable_logs = false,
		enable_stdout_logs = true,
	},
	--##################
	--## KEYBINDINGS ###
	--##################
	-- See https://wiki.hyprland.org/Configuring/Keywords/
	-- Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
	-- Clipboard history (cliphist) + colour picker (hyprpicker) -- need install (see notes)
	--bind = $mainMod, J, togglesplit, # dwindle
	-- Move focus with mainMod + arrow keys
	-- Move Windows
	-- Switch workspaces with mainMod + [0-9]
	-- Move active window to a workspace with mainMod + SHIFT + [0-9]
	-- Move workspace to another monitor
	-- Example special workspace (scratchpad)
	-- Scroll through existing workspaces with mainMod + scroll
	-- Move/resize windows with mainMod + LMB/RMB and dragging
	-- Laptop multimedia keys for volume and LCD brightness
	-- Requires playerctl
	-- Laptop Lid
	--bindl = , switch:on:Lid Switch, exec, hyprctl dispatch dpms off
	--bindl = , switch:off:Lid Switch, exec, hyprctl dispatch dpms on
	--#############################
	--## WINDOWS AND WORKSPACES ###
	--#############################
	-- See https://wiki.hyprland.org/Configuring/Window-Rules/ for more
	-- See https://wiki.hyprland.org/Configuring/Workspace-Rules/ for workspace rules
	-- Example windowrule
	-- windowrule = float,class:^(kitty)$,title:^(kitty)$
	-- Target the "sharing your screen" indicator
	ecosystem = {
		no_update_news = true,
		no_donation_nag = true,
	},
})

hl.on("hyprland.start", function()
	-- Apply the last-used theme (default: tokyo-night) FIRST, so its symlinks
	-- (waybar.css / current-wallpaper / ...) exist before the apps below read
	-- them. Runs foreground (terminated by ';') so it finishes before waybar
	-- and hyprpaper start. Also re-randomises the wallpaper each login and
	-- recreates the symlinks if missing (fresh machine). See
	-- ~/.config/themes/set-theme.sh.
	-- waybar then runs as a systemd user service so it auto-restarts on the
	-- known mpris/playerctl segfault; import-environment gives the unit the
	-- Wayland env it needs.
	hl.exec_cmd('T=$(basename "$(readlink ~/.config/themes/current 2>/dev/null)" 2>/dev/null); ~/.config/themes/set-theme.sh "${T:-tokyo-night}"; systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE && systemctl --user start waybar.service & hyprpaper &')
	hl.exec_cmd("swaync & hypridle &")
	hl.exec_cmd("wl-paste --watch cliphist store &")
	hl.exec_cmd("systemctl --user start seatd &")
	hl.exec_cmd("systemctl --user start hyprpolkitagent &")
	hl.exec_cmd("easyeffects --gpapplication-service &")
end)

hl.on("config.reloaded", function()
	hl.exec_cmd('gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"')
	hl.exec_cmd('gsettings set org.gnome.desktop.interface gtk-theme "Pop"')
end)
