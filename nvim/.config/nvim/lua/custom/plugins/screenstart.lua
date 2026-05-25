-- return {
--   {
--     'goolord/alpha-nvim',
--     dependencies = { 'echasnovski/mini.icons' },
--     config = function()
--       local dashboard = require 'alpha.themes.startify'
--       dashboard.section.header.val = {
--         '                                                     ',
--         '  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ',
--         '  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ',
--         '  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ',
--         '  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ',
--         '  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ',
--         '  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ',
--         '                                                     ',
--       }
--       -- Center the header
--       --Style
--       vim.cmd 'highlight AlphaHeader guifg=#AD8301 gui=bold'
--       dashboard.section.header.opts.hl = 'AlphaHeader'
--       dashboard.section.top_buttons.val = {}
--       dashboard.section.bottom_buttons.val = {}
--       require('alpha').setup(dashboard.config)
--     end,
--   },
-- }

local neovimHeader = {
  '                                                     ',
  '  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ',
  '  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ',
  '  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ',
  '  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ',
  '  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ',
  '  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ',
  '                                                     ',
}

local function header_color()
  local lines = {}
  for i, line in ipairs(neovimHeader) do
    table.insert(lines, {
      type = 'text',
      val = line,
      opts = {
        hl = 'NeovimHeader',
        shrink_margin = false,
        position = 'center',
      },
    })
  end

  local output = {
    type = 'group',
    val = lines,
    opts = { position = 'center' },
  }

  return output
end

local function configure()
  local theme = require 'alpha.themes.theta'
  local themeconfig = theme.config
  local dashboard = require 'alpha.themes.dashboard'
  local buttons = {
    type = 'group',
    val = {
      { type = 'text', val = 'Quick links', opts = { hl = 'SpecialComment', position = 'center' } },
      { type = 'padding', val = 1 },
      dashboard.button('e', '  New file', '<cmd>ene<CR>'),
      dashboard.button('SPC f', '  Find file'),
      dashboard.button('SPC F', '  Find text'),
      dashboard.button('u', '󱐥  Update Plugins', '<cmd>Lazy sync<CR>'),
      dashboard.button('q', '󰩈  Quit', '<cmd>qa<CR>'),
    },
    position = 'center',
  }

  themeconfig.layout[2] = header_color()
  themeconfig.layout[6] = buttons

  return themeconfig
end

return {
  'goolord/alpha-nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    -- Define the highlight group with the desired color
    vim.cmd 'highlight NeovimHeader guifg=#D2D2D2 gui=bold'
    require('alpha').setup(configure())
  end,
}
