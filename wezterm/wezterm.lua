local wezterm = require 'wezterm';

function merge_all(...)
	local ret = {}
	for _, tbl in ipairs({...}) do
	  for k, v in pairs(tbl) do
		ret[k] = v
	  end
	end
	return ret
end

local nord = {
	nord0 = "#2E3440",
	nord1 = "#3B4252",
	nord2 = "#434C5E",
	nord3 = "#4C566A",
	nord4 = "#D8DEE9",
	nord5 = "#E5E9F0",
	nord6 = "#ECEFF4",
	nord7 = "#8FBCBB",
	nord8 = "#88C0D0",
	nord9 = "#81A1C1",
	nord10 = "#5E81AC",
	nord11 = "#BF616A",
	nord12 = "#D08770",
	nord13 = "#EBCB8B",
	nord14 = "#A3BE8C",
	nord15 = "#B48EAD"
}

local base_config = {
	font = wezterm.font("Hack"),
	font_size = 14.0,
	color_scheme = "nord",

	initial_cols = 120,
	initial_rows = 30,

	window_close_confirmation = "NeverPrompt",
	keys = {
		{key="w", mods="CTRL|SHIFT", action=wezterm.action{CloseCurrentTab={confirm=false}}}
	},

	hide_tab_bar_if_only_one_tab = true,

	colors = {
		tab_bar = {
		  background = nord.nord0,

		  active_tab = {
			bg_color = nord.nord1,
			fg_color = nord.nord4,
		  },
		  inactive_tab = {
			bg_color = nord.nord0,
			fg_color = nord.nord4,
		  },
		  inactive_tab_hover = {
			bg_color = nord.nord1,
			fg_color = nord.nord4,
		  }
		}
	},

	window_padding = {
		left = 5,
		right = 5,
		top = 5,
		bottom = 5,
	}
}

-- Windows only config
local windows_config = {}
if wezterm.target_triple == "x86_64-pc-windows-msvc" then
	local wsl_domains = {
		{ name = "WSL:Ubuntu", distribution = "Ubuntu", default_cwd = "~" }
	}

	windows_config = {
		wsl_domains = wsl_domains,
		default_domain = "WSL:Ubuntu"
	}
end

local config = merge_all(base_config, windows_config)

return config
