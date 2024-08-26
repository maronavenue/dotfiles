local wezterm = require("wezterm")

return {
	-- system
	window_close_confirmation = "NeverPrompt",
	check_for_updates = false,
	automatically_reload_config = false,

	-- initial launch
	default_prog = { "wsl.exe", "--distribution", "Ubuntu-22.04" },
	default_cwd = "\\\\wsl$\\Ubuntu-22.04\\home\\mmontano",

	-- styling
	font = wezterm.font("Hack Nerd Font"),

	color_scheme = "Dracula+",
	-- this one is good too
	-- color_scheme = "Snazzy",

	window_background_opacity = 0.95,
	font_size = 10.0,

	default_cursor_style = "BlinkingBar",
	cursor_blink_rate = 400,
	cursor_thickness = "1pt",

	enable_tab_bar = true,
	use_fancy_tab_bar = true,
	hide_tab_bar_if_only_one_tab = true,
	tab_bar_at_bottom = false,

	-- https://github.com/wez/wezterm/issues/5138
	-- https://wezfurlong.org/wezterm/config/lua/config/front_end.html
	front_end = "WebGpu",
	-- otherwise, gpu renderer yields glitches on small window size
	initial_rows = 50,
	initial_cols = 150,
}
