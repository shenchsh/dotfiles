local wezterm = require('wezterm')
-- local platform = require('utils.platform')

-- local mod = {}

-- if platform.is_mac then
--   mod.SUPER = 'SUPER'
--   mod.SUPER_REV = 'SUPER|CTRL'
-- elseif platform.is_win or platform.is_linux then
--   mod.SUPER = 'ALT' -- to not conflict with Windows key shortcuts
--   mod.SUPER_REV = 'ALT|CTRL'
-- end


local keys = {
  { key = 'a', mods = "LEADER|CTRL",  action=wezterm.action{SendString="\x02"}},
  { key = '%', mods = "LEADER",       action=wezterm.action{SplitVertical={domain="CurrentPaneDomain"}}},
  { key = '"',mods = "LEADER",       action=wezterm.action{SplitHorizontal={domain="CurrentPaneDomain"}}},
  { key = 'o', mods = "LEADER",       action="TogglePaneZoomState" },
  { key = 'z', mods = "LEADER",       action="TogglePaneZoomState" },
  { key = 'c', mods = "LEADER",       action=wezterm.action{SpawnTab="CurrentPaneDomain"}},
  { key = 'h', mods = "LEADER",       action=wezterm.action{ActivatePaneDirection="Left"}},
  { key = 'j', mods = "LEADER",       action=wezterm.action{ActivatePaneDirection="Down"}},
  { key = 'k', mods = "LEADER",       action=wezterm.action{ActivatePaneDirection="Up"}},
  { key = 'l', mods = "LEADER",       action=wezterm.action{ActivatePaneDirection="Right"}},
  { key = 'H', mods = "LEADER|SHIFT", action=wezterm.action{AdjustPaneSize={"Left", 5}}},
  { key = 'J', mods = "LEADER|SHIFT", action=wezterm.action{AdjustPaneSize={"Down", 5}}},
  { key = 'K', mods = "LEADER|SHIFT", action=wezterm.action{AdjustPaneSize={"Up", 5}}},
  { key = 'L', mods = "LEADER|SHIFT", action=wezterm.action{AdjustPaneSize={"Right", 5}}},
  { key = '1', mods = "LEADER",       action=wezterm.action{ActivateTab=0}},
  { key = '2', mods = "LEADER",       action=wezterm.action{ActivateTab=1}},
  { key = '3', mods = "LEADER",       action=wezterm.action{ActivateTab=2}},
  { key = '4', mods = "LEADER",       action=wezterm.action{ActivateTab=3}},
  { key = '5', mods = "LEADER",       action=wezterm.action{ActivateTab=4}},
  { key = '6', mods = "LEADER",       action=wezterm.action{ActivateTab=5}},
  { key = '7', mods = "LEADER",       action=wezterm.action{ActivateTab=6}},
  { key = '8', mods = "LEADER",       action=wezterm.action{ActivateTab=7}},
  { key = '9', mods = "LEADER",       action=wezterm.action{ActivateTab=8}},
  { key = '&', mods = "LEADER|SHIFT", action=wezterm.action{CloseCurrentTab={confirm=true}}},
  { key = 'x', mods = "LEADER",       action=wezterm.action{CloseCurrentPane={confirm=true}}},
}

local key_tables = {}
local mouse_binds = {}

return {
  -- disable_default_key_bindings = true,
  -- debug_key_events = true,
  leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 2000 },
  -- keys = {
  --   {
  --     key = '|',
  --     mods = 'LEADER|SHIFT',
  --     action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
  --   },
  --   -- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
  --   {
  --     key = 'a',
  --     mods = 'LEADER|CTRL',
  --     action = wezterm.action.SendKey { key = 'a', mods = 'CTRL' },
  --   },
  -- }
  -- disable_default_mouse_bindings = true,
  keys = keys,
  --  key_tables = key_tables,
  --  mouse_bindings = mouse_bindings,
}
