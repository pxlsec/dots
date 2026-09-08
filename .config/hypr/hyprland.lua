--- Monitors ---
hl.monitor({
	output = "desc:ASUSTek COMPUTER INC PG27AQDM R8LMRS000334",
	mode = "preferred",
	position = "0x0",
	bitdepth = 10,
	cm = "dcip3",
})

--- APPS ---
local browser = "zen-browser"
local term = "kitty"

--- AUTOSTART ---
hl.on("hyprland.start", function()
	-- Starts systemd graphical target
	hl.exec_cmd("systemctl --user start hyprland-session.target")

	-- Services
	hl.exec_cmd("hypridle")
	hl.exec_cmd("waybar")
	hl.exec_cmd("dunst")
	hl.exec_cmd("systemctl --user start opentabletdriver.service")

	-- Apps
	hl.exec_cmd("steam --silent")
	hl.exec_cmd(browser)
	hl.exec_cmd("discord")
	hl.exec_cmd("spotify-launcher")
end)

hl.on("hyprland.shutdown", function()
	os.execute("systemctl --user stop hyprland-session.target && sleep 0.1")
	-- uses a blocking exec function and sleeps a bit to give things time to close
	-- you might also want to kill troublesome/crashing non-systemd background services here:
	-- os.execute("pkill wallpaperthing; systemctl --user stop hyprland-session.target && sleep 0.1")
end)

--- ENVIROMENT ---
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")

hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")

hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")

hl.env("XCURSOR_SIZE", "32")
hl.env("XCURSOR_THEME", "Vimix-cursors")
hl.env("HYPRCURSOR_SIZE", "32")
hl.env("HYPRCURSOR_THEME", "Vimix-cursors")

hl.env("GTK_THEME", "Adwaita:dark")
hl.env("QT_STYLE_OVERRIDE", "adwaita-dark")

--- STYLE ---
hl.config({
	input = {
		kb_layout = "custom",
		kb_variant = "",
		kb_model = "pc105",
		kb_options = "fkeys:basic_13-24",
		kb_rules = "",

		resolve_binds_by_sym = true,

		repeat_rate = 30,
		repeat_delay = 250,

		touchpad = {
			natural_scroll = true,
			disable_while_typing = true,
			scroll_factor = 0.3,
		},

		accel_profile = "custom 1 0 0.625", -- Compensate for high DPI in cursor mode
	},

	cursor = {
        no_break_fs_vrr = 1,
		no_hardware_cursors = 1,
	},

	general = {
		gaps_in = 4,
		gaps_out = 6,

		border_size = 0,

		allow_tearing = true,
	},

	decoration = {
		rounding = 8,
		blur = {
			size = 6,
			passes = 3,
			noise = 0.06,
			contrast = 0.9,
			brightness = 0.6,
			popups = true,
		},
		shadow = {
			enabled = true,
			range = 6,
		},
	},

	render = {
		new_render_scheduling = false,
		direct_scanout = 0,
		cm_auto_hdr = 0,
	},

	misc = {
		vrr = 3,
		enable_anr_dialog = false,
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
	},

	animations = {
		enabled = true,
	},
	ecosystem = {
		no_update_news = true,
		no_donation_nag = true,
	},
})

-- hl.curve("easeCubic", { type = "bezier", points = { { 0.33, 1 }, { 0.68, 1 } } })
--
-- hl.animation({ leaf = "global", enabled = true, speed = 2, bezier = "easeCubic" })
--
-- hl.animation({ leaf = "windows", enabled = true, speed = 2, bezier = "easeCubic",  style="gnomed" })
-- hl.animation({ leaf = "workspaces", enabled = true, speed = 2, bezier = "easeCubic", style = "fade" })
-- hl.animation({ leaf = "fade", enabled = true, speed = 2, bezier = "easeCubic" })

hl.curve("fluent_decel", { type = "bezier", points = { { 0, 0.2 }, { 0.4, 1 } } })
hl.curve("smooth_out", { type = "bezier", points = { { 0, 0.5 }, { 0.5, 1 } } })
hl.curve("overshoot", { type = "bezier", points = { { 0.05, 0.9 }, { 0.05, 1.1 } } })

hl.animation({ leaf = "windowsIn", enabled = true, speed = 2, bezier = "overshoot", style = "popin 80%" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 2, bezier = "overshoot", style = "popin 80%" })

hl.animation({ leaf = "windowsOut", enabled = true, speed = 4, bezier = "fluent_decel", style = "popin 80%" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 4, bezier = "fluent_decel", style = "popin 80%" })

hl.animation({ leaf = "windowsMove", enabled = true, speed = 2, bezier = "smooth_out", style = "slide" })
hl.animation({ leaf = "fade", enabled = true, speed = 3, bezier = "smooth_out" })

hl.animation({ leaf = "workspaces", enabled = true, speed = 4, bezier = "smooth_out", style = "fade" })

hl.animation({ leaf = "fade", enabled = true, speed = 3, bezier = "smooth_out" })

--- WINDOWRULES ---

-- hl.window_rule({
-- 	name = "disable xdg dragging",
-- 	match = {
--
-- 		class = ".*",
-- 	},
--
-- 	no_xdg_drags = true,
-- })

hl.window_rule({
	-- Fix some dragging issues with XWayland
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},

	no_focus = true,
})

hl.window_rule({
	name = "zen-browser",
	match = {
		class = "^zen",
	},
	workspace = "2 silent",
	content = "video",
})

hl.window_rule({

	name = "picture-in-picture",
	match = {
		title = "Picture-in-Picture",
	},
	float = true,
	size = { "monitor_w * 0.3", "monitor_h * 0.3" },
	move = { "monitor_w * 0.7 - 6", "monitor_h * 0.7 - 6" },
	pin = true,
})

hl.window_rule({
	name = "discord",
	match = {
		class = "^discord",
	},
	workspace = "5 silent",
})

hl.window_rule({
	name = "spotify",
	match = {
		class = "^Spotify",
	},
	workspace = "5 silent",
})

hl.window_rule({
	name = "steam",
	match = {
		class = "^steam",
	},
	workspace = "1 silent",
})

hl.window_rule({
	name = "mpv",
	match = {
		class = "^mpv",
	},
	float = true,
	size = { "monitor_w * 0.5", "monitor_h * 0.5" },
})

hl.window_rule({ match = { class = "gamescope" }, content = "game" })
hl.window_rule({ match = { class = "steam_app_\\d+" }, content = "game" })
hl.window_rule({ match = { class = "cs2" }, content = "game" })
hl.window_rule({ match = { title = "^[Mm]inecraft.*" }, content = "game" })
hl.window_rule({ match = { class = "osu!" }, content = "game" })
hl.window_rule({
	name = "games",
	match = {
		content = "game",
	},
	workspace = "1 silent",
	immediate = true,
	idle_inhibit = "focus",
})

--- LAYERRULES ---
hl.layer_rule({
	match = { namespace = "rofi" },
	blur = true,
	ignore_alpha = 0.75,
})

hl.layer_rule({
	match = { namespace = "waybar" },
	blur = true,
	ignore_alpha = 0.75,
})

--- KEYBINDS ---
local mainMod = "SUPER"

hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd("pkill rofi || rofi -show drun"))
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(term))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(
	mainMod .. " + SHIFT + Q",
	hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")
)
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd("nemo"))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + T", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + P", hl.dsp.window.pin())

hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("pidof hyprlock || hyprlock"))
hl.bind(mainMod .. " + L", function()
	hl.timer(function()
		hl.dispatch(hl.dsp.dpms({ action = "disable" }))
	end, { timeout = 500, type = "oneshot" })
end, { locked = true })
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.exec_cmd("systemctl suspend"), { locked = true })
hl.bind("Escape", hl.dsp.dpms({ action = "enable" }), { locked = true, non_consuming = true })

hl.bind("Print", hl.dsp.exec_cmd("hyprshot -o ~/Pictures/Screenshots -c -m active -m output"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("hyprshot -z -o ~/Pictures/Screenshots -m region"))
hl.bind("CONTROL + Print", hl.dsp.exec_cmd("hyprpicker -a -f hex"))

hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + N", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + E", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + I", hl.dsp.focus({ direction = "right" }))

hl.bind("CONTROL + Up", hl.dsp.send_shortcut({ window = "class:^(discord)$", mods = "CONTROL SHIFT", key = "M" }))
hl.bind("CONTROL + Down", hl.dsp.send_shortcut({ window = "class:^(discord)$", mods = "CONTROL SHIFT", key = "D" }))

hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl -p 'spotify' play-pause"), { locked = true })
hl.bind("XF86AudioStop", hl.dsp.exec_cmd("playerctl -p 'spotify' shuffle 'Toggle'"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl -p 'spotify' previous"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl -p 'spotify' next"), { locked = true })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })

for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i, on_current_monitor = true }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i, follow = false }))
end

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
