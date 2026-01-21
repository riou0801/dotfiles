-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- This is where you actually apply your config choices
config.default_prog = { '/usr/bin/bash', '-l' }
config.window_background_opacity = 0.9
config.enable_tab_bar = false

config.font = wezterm.font_with_fallback {
  '0xproto Nerd Font Mono',
  'Noto Sans CJK JP',
  'Noto Color Emoji'
}
config.font_size = 11.0
-- For example, changing the color scheme:
config.color_scheme = 'Catppuccin Mocha'

-- and finally, return the configuration to wezterm
return config
