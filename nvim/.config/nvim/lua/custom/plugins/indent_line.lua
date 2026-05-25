-- return {
--   { -- Add indentation guides even on blank lines
--     'lukas-reineke/indent-blankline.nvim',
--     -- Enable `lukas-reineke/indent-blankline.nvim`
--     -- See `:help ibl`
--     main = 'ibl',
--     ---@module "ibl"
--     ---@type ibl.config
--     opts = {
--       --   char = '▏', -- Character used for indentation lines
--       --   char_highlight = 'IndentBlanklineChar', -- Highlight group for the character
--     },
--   },
-- }
-- return {
--   'lukas-reineke/indent-blankline.nvim',
--   -- Or "lukas-reineke/indent-blankline.nvim" if it's pulling the new ibl code
--   event = { 'BufReadPre', 'BufNewFile' },
--   config = function()
--     local hooks = require 'ibl.hooks'
--
--     -- Register a hook that sets up your custom highlight group every time colorscheme changes
--     hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
--       -- Pick a TokyoNight-ish blue (typical is #7AA2F7)
--       vim.api.nvim_set_hl(0, 'MyIndentColor', { fg = '#7AA2F7' })
--     end)
--
--     -- Now set up ibl with a single highlight group
--     require('ibl').setup {
--       indent = {
--         char = '│', -- or another symbol like "┊"
--         highlight = { 'MyIndentColor' },
--       },
--       scope = {
--         enabled = false, -- turn off scope lines if you only want indent lines
--       },
--     }
--   end,
-- }
return {
  {
    'lukas-reineke/indent-blankline.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      -- 1) Require the hooks
      local hooks = require 'ibl.hooks'

      -- 2) Register a hook to set up your custom highlight
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        -- Pick a “Tokyo Blue” color. Some popular choices:
        --   #7AA2F7 (TokyoNight) or #61AFEF (OneDark/VSCode-ish)
        -- vim.api.nvim_set_hl(0, 'MyBlueIndent', { fg = '#24EAF7' })
        -- vim.api.nvim_set_hl(0, 'OneDark', { fg = '#61AFEF' })
        vim.api.nvim_set_hl(0, 'OneDark', { fg = '#4a4a4a' })
      end)

      -- 3) Set up ibl with a thicker character and single highlight
      require('ibl').setup {
        indent = {
          -- This character is thicker than the standard "│"
          -- char = '┃',
          char = '│',

          highlight = { 'OneDark' },
        },
        scope = {
          -- Turn off scope lines if you only want indent lines
          enabled = false,
        },
      }
    end,
  },
}
