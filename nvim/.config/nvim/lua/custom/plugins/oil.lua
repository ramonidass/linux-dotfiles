return {
  {
    'stevearc/oil.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local oil = require 'oil'
      oil.setup {
        default_file_explorer = true, -- Oil replaces netrw
        columns = { 'icon' },

        -- Buffer options
        buf_options = {
          buflisted = false,
          bufhidden = 'hide',
        },

        -- Window options
        win_options = {
          wrap = false,
          signcolumn = 'no',
          cursorcolumn = false,
          foldcolumn = '0',
          spell = false,
          list = false,
          conceallevel = 3,
          concealcursor = 'nvic',
        },

        -- File operations settings
        delete_to_trash = true,
        skip_confirm_for_simple_edits = false,
        prompt_save_on_select_new_entry = true,
        cleanup_delay_ms = 2000,

        -- LSP integration for file operations
        lsp_file_methods = {
          enabled = true,
          timeout_ms = 1000,
          autosave_changes = false,
        },

        constrain_cursor = 'editable',
        watch_for_changes = false,

        -- Key mappings for Oil buffer
        keymaps = {
          ['g?'] = { 'actions.show_help', mode = 'n' },
          ['<CR>'] = 'actions.select',
          ['<C-h>'] = { 'actions.select', opts = { vertical = true } }, -- Open in vertical split
          ['<C->>'] = { 'actions.select', opts = { horizontal = true } }, -- Open in horizontal split
          ['<C-t>'] = { 'actions.select', opts = { tab = true } }, -- Open in new tab
          ['<C-p>'] = 'actions.preview',
          -- ['<Esc>'] = { 'actions.close', mode = 'n' },
          ['<C-l>'] = 'actions.refresh',
          ['-'] = { 'actions.parent', mode = 'n' },
          ['_'] = { 'actions.open_cwd', mode = 'n' },
          ['`'] = { 'actions.cd', mode = 'n' },
          ['~'] = { 'actions.cd', opts = { scope = 'tab' }, mode = 'n' },
          ['gs'] = { 'actions.change_sort', mode = 'n' },
          ['gx'] = 'actions.open_external',
          ['g.'] = { 'actions.toggle_hidden', mode = 'n' },
          ['g\\'] = { 'actions.toggle_trash', mode = 'n' },
        },

        -- Sorting and hidden files
        view_options = {
          show_hidden = true,
          is_hidden_file = function(name, _)
            return name:match '^%.' ~= nil
          end,
          is_always_hidden = function(name, _)
            local hidden_folders = { 'dev-tools.locks', 'dune.lock', '_build' }
            return vim.tbl_contains(hidden_folders, name)
          end,
          natural_order = 'fast',
          case_insensitive = false,
          sort = {
            { 'type', 'asc' },
            { 'name', 'asc' },
          },
        },

        -- Floating window config
        float = {
          padding = 2,
          max_width = 0.9,
          max_height = 0.8,
          border = 'rounded',
          win_options = {
            winblend = 0,
          },
          preview_split = 'auto',
          override = function(conf)
            return conf
          end,
        },

        -- Preview window settings
        preview_win = {
          update_on_cursor_moved = true,
          preview_method = 'fast_scratch',
          disable_preview = function()
            return false
          end,
          win_options = {},
        },
      }

      -- Keymap: Press ESC twice to close Oil
      vim.keymap.set('n', '<Esc>', function()
        if vim.bo.filetype == 'oil' then
          vim.cmd 'q'
        end
      end, { desc = 'Close Oil with ESC ESC' })

      -- Open Oil.nvim
      -- vim.keymap.set('n', 'space>n', '<CMD>oil<CR>', { desc = 'Open parent directory' })

      -- Open Oil.nvim in floating window
      -- vim.keymap.set('n', '<space>n', require('oil').toggle_float)
      vim.keymap.set('n', '<space>n', function()
        oil.toggle_float()

        -- Wait until oil has opened, for a maximum of 1 second.
        vim.wait(1000, function()
          return oil.get_cursor_entry() ~= nil
        end)
        if oil.get_cursor_entry() then
          oil.open_preview()
        end
      end)
    end,
  },
}
