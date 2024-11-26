local wezterm = require("wezterm")

local function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return "Catppuccin Mocha"
	else
		return "Catppuccin Latte"
	end
end

local function tab_title(tab_info)
	local title = tab_info.tab_title
	-- if the tab title is explicitly set, take that
	if title and #title > 0 then
		return title
	end
	-- Otherwise, use the title from the active pane
	-- in that tab
	return tab_info.active_pane.title
end
-- The filled in variant of the < symbol
local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider

-- The filled in variant of the > symbol
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

return {
	color_scheme = scheme_for_appearance(wezterm.gui.get_appearance()),
	window_background_opacity = 0.9,
	window_background_image = "./beach.jpg",
	font = wezterm.font("Iosevka Nerd Font"),
	font_size = 22.0,
	enable_tab_bar = true,
	wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
		local edge_background = "#0b0022"
		local background = "#1b1032"
		local foreground = "#808080"

		if tab.is_active then
			background = "#2b2042"
			foreground = "#c0c0c0"
		elseif hover then
			background = "#3b3052"
			foreground = "#909090"
		end

		local edge_foreground = background

		local title = tab_title(tab)

		-- ensure that the titles fit in the available space,
		-- and that we have room for the edges.
		title = wezterm.truncate_right(title, max_width - 2)

		return {
			{ Background = { Color = edge_background } },
			{ Foreground = { Color = edge_foreground } },
			{ Text = SOLID_LEFT_ARROW },
			{ Background = { Color = background } },
			{ Foreground = { Color = foreground } },
			{ Text = title },
			{ Background = { Color = edge_background } },
			{ Foreground = { Color = edge_foreground } },
			{ Text = SOLID_RIGHT_ARROW },
		}
	end),
}
