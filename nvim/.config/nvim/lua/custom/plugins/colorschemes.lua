return {
  -- {
  --   'vague-theme/vague.nvim',
  --   lazy = false, -- Make sure we load this during startup
  --   priority = 1000, -- Make sure to load this before all the other plugins config = function()
  --     -- You can add options to setup() if you want to customize the theme
  --     require('vague').setup {
  --       -- transparent = true, -- for example
  --     }
  --     vim.cmd 'colorscheme vague'
  --   end,
  -- },
  -- {
  --   'KijitoraFinch/nanode.nvim',
  --   priority = 1000,
  --   config = function()
  --     require('nanode').setup {
  --       transparent = false,
  --     }
  --     vim.cmd.colorscheme 'nanode'
  --   end,
  -- },
  -- {
  --   'Mofiqul/adwaita.nvim',
  --   lazy = false,
  --   priority = 1000,
  --
  --   -- configure and set on startup
  --   config = function()
  --     vim.g.adwaita_darker = true -- for darker version
  --     vim.g.adwaita_disable_cursorline = true -- to disable cursorline
  --     vim.g.adwaita_transparent = true -- makes the background transparent
  --     vim.cmd 'colorscheme adwaita'
  --   end,
  -- },
  -- {
  --   'Kaikacy/Lemons.nvim',
  --   version = '*', -- for stable release
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     vim.cmd.colorscheme 'lemons'
  --     -- or
  --     -- require("lemons").load()
  --     -- there is no difference between these two
  --   end,
  -- },
  {
    'craftzdog/solarized-osaka.nvim',
    lazy = false, -- Set to false for automatic loading
    priority = 1000,
    opts = function()
      return {
        transparent = true,
        -- styles = {
        --   comments = { italic = true },
        --   keywords = { italic = true },
        --   functions = {},
        --   variables = {},
        --   sidebars = 'dark',
        --   floats = 'dark',
        -- },
      }
    end,
    config = function()
      vim.cmd 'colorscheme solarized-osaka'
    end,
  },
  -- Put this in your init.lua or lazy.nvim spec
  -- {
  --   'rose-pine/neovim',
  --   name = 'rose-pine',
  --   priority = 1000,
  --   opts = {
  --     variant = 'moon', -- keeps the nicer highlights he actually uses
  --     disable_italics = true,
  --   },
  --   config = function()
  --     require('rose-pine').setup {
  --       variant = 'moon',
  --       disable_italics = true,
  --
  --       highlight_groups = {
  --         ColorColumn = { bg = '#000000' },
  --         CursorLine = { bg = '#000000' },
  --         Normal = { bg = '#000000' }, -- forces the dark purple base
  --         NormalFloat = { bg = '#000000' },
  --         SignColumn = { bg = '#000000' },
  --       },
  --     }
  --
  --     vim.cmd.colorscheme 'rose-pine'
  --   end,
  -- },
  -- {
  --   'scottmckendry/cyberdream.nvim',
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     vim.cmd.colorscheme 'cyberdream'
  --   end,
  -- },
  -- {
  --   'tjdevries/colorbuddy.nvim',
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --     -- vim.cmd.colorscheme 'tokyonight'
  --     -- vim.cmd.colorscheme 'gruvbuddy'
  --     -- vim.cmd.colorscheme 'ayu-dark'
  --     vim.cmd.colorscheme 'flexoki-dark'
  --   end,
  -- },
  -- 'rktjmp/lush.nvim',
  -- 'tckmn/hotdog.vim',
  -- 'dundargoc/fakedonalds.nvim',
  -- 'craftzdog/solarized-osaka.nvim',
  -- { 'rose-pine/neovim', name = 'rose-pine' },
  -- 'eldritch-theme/eldritch.nvim',
  -- 'jesseleite/nvim-noirbuddy',
  -- 'miikanissi/modus-themes.nvim',
  -- 'rebelot/kanagawa.nvim',
  -- 'gremble0/yellowbeans.nvim',
  -- 'rockyzhang24/arctic.nvim',
  -- 'folke/tokyonight.nvim',
  -- 'Shatur/neovim-ayu',
  -- 'RRethy/base16-nvim',
  -- 'xero/miasma.nvim',
  -- 'cocopon/iceberg.vim',
  { 'kepano/flexoki-neovim', name = 'loco' },
  -- 'ntk148v/komau.vim',
  -- { 'catppuccin/nvim', name = 'catppuccin' },
  -- 'uloco/bluloco.nvim',
  -- 'LuRsT/austere.vim',
  -- 'ricardoraposo/gruvbox-minor.nvim',
  -- 'NTBBloodbath/sweetie.nvim',
  -- 'vim-scripts/MountainDew.vim',
  -- 'mcauley-penney/techbase.nvim',
  -- { 'aktersnurra/no-clown-fiesta.nvim', name = 'nohomo' },
  {
    -- 'maxmx03/fluoromachine.nvim',
    -- config = function()
    --   local fm = require "fluoromachine"
    --   fm.setup { glow = true, theme = "fluoromachine" }
    -- end,
  },
}
