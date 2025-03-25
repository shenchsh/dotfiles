local gpu_adapters = require('utils.gpu-adapter')

return {
  max_fps = 120,
  front_end = 'WebGpu',
  webgpu_power_preference = 'HighPerformance',
  webgpu_preferred_adapter = gpu_adapters:pick_best(),
  -- webgpu_preferred_adapter = gpu_adapters:pick_manual('Dx12', 'IntegratedGpu'),
  -- webgpu_preferred_adapter = gpu_adapters:pick_manual('Gl', 'Other'),
  underline_thickness = '1pt',

  color_scheme = 'Tokyo Night (Gogh)',
  enable_scroll_bar = true,

  -- tab bar
  enable_tab_bar = true,
  hide_tab_bar_if_only_one_tab = false,
  tab_max_width = 25,
  show_tab_index_in_tab_bar = true,
  switch_to_last_active_tab_when_closing_tab = true,
}
