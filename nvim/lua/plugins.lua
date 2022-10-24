-- Only required if you have packer configured as `opt`
-- vim.cmd [[packadd packer.nvim]]

-- Run PackerCompile whenever we edit this file with `nvim`.
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use {
    'EdenEast/nightfox.nvim',
    run = ":NightfoxCompile",
    config = function()
      local options = {
        styles = {
          comments = "italic",
          keywords = "bold",
          types = "italic,bold",
        }
      }

      require('nightfox').setup({
        options = options
      })

      local colorscheme = "nightfox"
      -- local colorscheme = "nordfox"
      vim.cmd('colorscheme ' .. colorscheme)
    end,
  }

  use {
    'akinsho/bufferline.nvim',
    tag = "v3.*",
    requires = 'nvim-tree/nvim-web-devicons',
    config = function()

      require("bufferline").setup({
        options = {
          always_show_bufferline = true,
          indicator = {
            style = 'underline'
          },
          diagnostics = 'nvim_lsp',
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
  }


  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true },
    config = function()
      require('lualine').setup {
        sections = {
          lualine_a = {'mode'},
          lualine_b = {'branch', 'diff', 'diagnostics'},
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
  }

  use({
    "mhinz/vim-signify",
    -- after = "tokyonight.nvim",
    config = function()
      --local colors = require("tokyonight.colors").setup({})
      --local util = require("tokyonight.util")

      --util.highlight("SignifySignAdd", { link = "GitSignsAdd" })
      --util.highlight("SignifySignChange", { link = "GitSignsChange" })
      --util.highlight("SignifySignChangeDelete", { link = "GitSignsChange" })
      --util.highlight("SignifySignDelete", { link = "GitSignsDelete" })
      --util.highlight("SignifySignDeleteFirstLine", { link = "GitSignsDelete" })
    end,
  })

  use {
    'christoomey/vim-tmux-navigator',
    config = function()
      vim.g.tmux_navigator_no_mappings = 1

      vim.api.nvim_set_keymap("n", "<C-h>", ":TmuxNavigateLeft<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<C-j>", ":TmuxNavigateDown<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<C-k>", ":TmuxNavigateUp<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<C-l>", ":TmuxNavigateRight<CR>", { noremap = true, silent = true })
      vim.api.nvim_set_keymap("n", "<C-\\>", ":TmuxNavigatePrevious<CR>", { noremap = true, silent = true })
    end,
  }

  use {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup({})
      -- local wk = require("which-key")
      -- As an example, we will create the following mappings:
      --  * <leader>ff find files
      --  * <leader>fr show recent files
      --  * <leader>fb Foobar
      -- we'll document:
      --  * <leader>fn new file
      --  * <leader>fe edit file
      -- and hide <leader>1

      --wk.register({
      --  f = {
      --    name = "file", -- optional group name
      --    n = { "New File" }, -- just a label. don't create any mapping
      --    e = "Edit File", -- same as above
      --    ["1"] = "which_key_ignore",  -- special label to hide it in the popup
      --    b = { function() print("bar") end, "Foobar" } -- you can also pass functions!
      --  },
      --}, { prefix = "<leader>" })
    end
  }

  use 'ggandor/lightspeed.nvim'

  use {
    -- g? for help
    'nvim-tree/nvim-tree.lua',
    requires = {
      'nvim-tree/nvim-web-devicons', -- optional, for file icons
    },
    tag = 'nightly', -- optional, updated every week. (see issue #1193)
    config = function()
      require("nvim-tree").setup({
        open_on_tab = false,
        sort_by = "case_sensitive",
        view = {
          adaptive_size = true,
          float = {
            quit_on_focus_loss = false,
          }
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = true,
        },
        git = {
          enable = true, --disable this in case of slowness
          ignore = true,
          show_on_dirs = true,
          timeout = 400,
        },
        on_attach = function(bufnr)
          local inject_node = require("nvim-tree.utils").inject_node
          vim.keymap.set("n", "<leader>n", inject_node(function(node)
            if node then
              print(node.absolute_path)
            end
          end), { buffer = bufnr, noremap = true })
        end
      })

      vim.api.nvim_set_keymap("n", "<C-n>", ":NvimTreeToggle<CR>", {noremap = true, silent = true})
    end,
  }

  use {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.0',
    requires = { {'nvim-lua/plenary.nvim'} },
    config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', 'ff', builtin.find_files, {})
      vim.keymap.set('n', 'fg', builtin.live_grep, {})
      vim.keymap.set('n', 'fb', builtin.buffers, {})
      vim.keymap.set('n', 'fh', builtin.help_tags, {})
    end
  }

  use {
    'neovim/nvim-lspconfig',
    config = function()
      -- Mappings.
      -- See `:help vim.diagnostic.*` for documentation on any of the below functions
      local opts = { noremap=true, silent=true }
      vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
      vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

      -- Use an on_attach function to only map the following keys
      -- after the language server attaches to the current buffer
      local on_attach = function(client, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local bufopts = { noremap=true, silent=true, buffer=bufnr }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', 'gh', vim.lsp.buf.hover, bufopts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
        vim.keymap.set('n', '<space>wl', function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, bufopts)
        vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
        vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
        vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
      end

      require('lspconfig').rust_analyzer.setup{
        on_attach = on_attach,
      }

      require('lspconfig').clangd.setup{
        on_attach = on_attach,
      }
    end
  }

  use({
    "nvim-treesitter/nvim-treesitter",
    run = ':TSUpdate',
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "rust", "cmake", "cpp", "css", "diff", "html", "javascript", "typescript", "yaml" },
        highlight = {
          enable = true,
        },
        indent = {
          enable = true,
        },
      })
    end,
  })

  use {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup {}
    end
  }
end)
