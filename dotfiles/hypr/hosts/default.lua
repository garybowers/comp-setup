-- Default host config: used when there is no hosts/<hostname>.lua for this
-- machine. Every machine currently uses it -- gary-desktop and the laptops
-- (gary-x1, gary-thinkpad, gary-starbook) all drive the same desk monitors:
-- two Lenovo 32" 4K panels side by side, P32p on the left, T32p on the right.
-- Both run 10-bit colour (bitdepth = 10); remove that line if a machine or
-- cable cannot drive it. The built-in laptop panel (eDP-1) and any other monitor are handled by the
-- generic rules in hyprland.lua.
--
-- To give one machine its own layout, copy this file to hosts/<hostname>.lua
-- (hostname as in /etc/hostname) and edit it.

hl.monitor({
	output = "desc:Lenovo Group Limited P32p-30 V30D66GG",
	mode = "preferred",
	position = "0x0",
	scale = "1",
	bitdepth = 10,
})

hl.monitor({
	output = "desc:Lenovo Group Limited T32p-30 V30DH3TX",
	mode = "preferred",
	position = "3840x0",
	scale = "1",
	bitdepth = 10,
})
