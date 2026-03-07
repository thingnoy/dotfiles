local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Font
config.font = wezterm.font("JetBrains Mono")
config.font_size = 14.0

-- Window
config.window_decorations = "RESIZE"
config.window_padding = { left = 12, right = 12, top = 12, bottom = 12 }
config.window_background_opacity = 0.95
config.macos_window_background_blur = 20

-- Tab bar
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true

-- Color scheme
config.color_scheme = "Catppuccin Mocha"

-- Cursor
config.default_cursor_style = "BlinkingBar"

-- Keys
config.keys = {
  { key = "d", mods = "CMD", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = "d", mods = "CMD|SHIFT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "w", mods = "CMD", action = wezterm.action.CloseCurrentPane({ confirm = true }) },
}

return config
