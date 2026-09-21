-- https://github.com/folke/lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  {
    'christoomey/vim-tmux-navigator',
    config = function()
      vim.g.tmux_navigator_no_mappings = 1

      vim.api.nvim_set_keymap("n", "<C-h>", ":TmuxNavigateLeft<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<C-j>", ":TmuxNavigateDown<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<C-k>", ":TmuxNavigateUp<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<C-l>", ":TmuxNavigateRight<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<C-\\>", ":TmuxNavigatePrevious<CR>", { noremap = true, silent = true })
    end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      vim.cmd('colorscheme tokyonight')
    end
  },
  {
    "nvim-treesitter/nvim-treesitter",
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter').install({
        'python', 'rust', 'c', 'cpp', 'ocaml', 'ocaml_interface',
        'lua', 'vim', 'vimdoc', 'toml', 'json', 'yaml',
        'markdown', 'markdown_inline', 'bash', 'cmake', 'make',
        'javascript', 'typescript', 'tsx', 'html', 'css',
      })
      vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('SyntaxHighlight', { clear = true }),
        pattern = {
          'python', 'rust', 'c', 'cpp', 'ocaml', 'ocamlinterface',
          'lua', 'vim', 'help', 'toml', 'json', 'yaml',
          'markdown', 'sh', 'bash', 'cmake', 'make',
          'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'html', 'css',
        },
        callback = function(event)
          local lang = vim.api.nvim_buf_get_name(event.buf):match('%.mli$') and 'ocaml_interface' or nil
          -- Use built-in syntax until the parser finishes installing.
          pcall(vim.treesitter.start, event.buf, lang)
        end,
      })
    end
 },
 {
    "nvim-tree/nvim-web-devicons", lazy = true
  },
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = {'nvim-tree/nvim-web-devicons'},
    config = function()
      require("bufferline").setup({
        options = {
          always_show_bufferline = true,
          buffer_close_icon = '',
          separator_style = "slant",
          offsets = {
            {
              filetype = "NvimTree",
              text = "File Explorer",
              highlight = "Directory",
              text_align = "left",
              seperator = true,
            },
          },
        },
      })

      vim.api.nvim_set_keymap("n", "gn", ":BufferLineCycleNext<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "gp", ":BufferLineCyclePrev<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "gq", ":BufferLinePickClose<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "gh", ":BufferLinePick<CR>", { noremap = true, silent = true })
    end
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup {
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'branch', 'diff'},
          lualine_c = {'filename'},
          lualine_x = {'encoding', 'fileformat', 'filetype'},
          lualine_y = {'progress'},
          lualine_z = {'location'}
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {'filename'},
          lualine_x = {'location'},
          lualine_y = {},
          lualine_z = {}
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {}
      }
    end

  },
  {
    'nvim-telescope/telescope.nvim',
    dependencies =  {'nvim-lua/plenary.nvim'} ,
    config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', 'ff', builtin.find_files, {})
      vim.keymap.set('n', 'fg', builtin.live_grep, {})
      vim.keymap.set('n', 'fb', builtin.buffers, {})
      vim.keymap.set('n', 'fh', builtin.help_tags, {})
    end
  },
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local api = require('nvim-tree.api')
      vim.keymap.set('n', '<leader>e', api.tree.toggle, {})
      require("nvim-tree").setup {}
    end,
  },
  {
    'ggandor/lightspeed.nvim',
  },
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {} -- this is equalent to setup({}) function
  },

}

local opts = {
  lockfile = vim.g.dotfiles_nvim_dir .. '/lazy-lock.json',
  performance = {
    rtp = {
      reset = false, -- preserve runtime paths configured in options.lua
    },
  },
}

require("lazy").setup(plugins, opts)
