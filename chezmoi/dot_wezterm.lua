local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- Font — Nerd Font for icons + ligatures
config.font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Medium" })
config.font_size = 14.0
config.line_height = 1.2

-- Window
config.window_decorations = "RESIZE"
config.window_padding = { left = 16, right = 16, top = 16, bottom = 16 }
config.window_background_opacity = 0.92
config.macos_window_background_blur = 30
config.native_macos_fullscreen_mode = false

-- Color scheme
config.color_scheme = "Catppuccin Mocha"

-- Tab bar — fancy style
config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = true
config.tab_max_width = 28
config.window_frame = {
  font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Bold" }),
  font_size = 11.0,
  active_titlebar_bg = "#1e1e2e",
  inactive_titlebar_bg = "#181825",
}

config.colors = {
  tab_bar = {
    active_tab = {
      bg_color = "#1e1e2e",
      fg_color = "#cdd6f4",
    },
    inactive_tab = {
      bg_color = "#181825",
      fg_color = "#6c7086",
    },
    inactive_tab_hover = {
      bg_color = "#313244",
      fg_color = "#cdd6f4",
    },
    new_tab = {
      bg_color = "#181825",
      fg_color = "#6c7086",
    },
    new_tab_hover = {
      bg_color = "#313244",
      fg_color = "#cdd6f4",
    },
  },
}

-- Cursor
config.default_cursor_style = "BlinkingBar"
config.cursor_blink_rate = 500
config.cursor_blink_ease_in = "EaseIn"
config.cursor_blink_ease_out = "EaseOut"

-- Inactive pane dimming
config.inactive_pane_hsb = {
  saturation = 0.8,
  brightness = 0.7,
}

-- Smooth scrolling & visual bell
config.enable_scroll_bar = false
config.scrollback_lines = 10000
config.visual_bell = {
  fade_in_duration_ms = 75,
  fade_out_duration_ms = 150,
  target = "CursorColor",
}
config.audible_bell = "Disabled"
config.window_close_confirmation = "NeverPrompt"

-- Unix domain (session persistence — survives WezTerm close)
config.unix_domains = {
  { name = "unix" },
}

-- Auto-connect to unix domain on launch
config.default_gui_startup_args = { "connect", "unix" }

-- Hammerspoon handles quake-mode positioning, no need for startup fullscreen

-- Keys
config.keys = {
  { key = "d", mods = "CMD", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = "d", mods = "CMD|SHIFT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "w", mods = "CMD", action = wezterm.action.CloseCurrentPane({ confirm = false }) },
  { key = "q", mods = "CTRL", action = wezterm.action.QuitApplication },
  { key = "Enter", mods = "CMD", action = wezterm.action.ToggleFullScreen },
  -- Pane navigation
  { key = "[", mods = "CMD", action = wezterm.action.ActivatePaneDirection("Prev") },
  { key = "]", mods = "CMD", action = wezterm.action.ActivatePaneDirection("Next") },
  { key = "LeftArrow", mods = "CMD|ALT", action = wezterm.action.ActivatePaneDirection("Left") },
  { key = "RightArrow", mods = "CMD|ALT", action = wezterm.action.ActivatePaneDirection("Right") },
  { key = "UpArrow", mods = "CMD|ALT", action = wezterm.action.ActivatePaneDirection("Up") },
  { key = "DownArrow", mods = "CMD|ALT", action = wezterm.action.ActivatePaneDirection("Down") },
}

return config
