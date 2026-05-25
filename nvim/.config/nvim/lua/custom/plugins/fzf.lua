return {
  'ibhagwan/fzf-lua',
  dependencies = { 'echasnovski/mini.icons' },
  opts = function()
    local actions = require('fzf-lua').actions
    return {
      winopts = {
        height = 0.9,
        width = 0.9,
        row = 0.35,
        col = 0.70,
        border = 'rounded',
      },
      files = {
        cmd = "fd --type f --hidden --exclude .git --exclude node_modules --exclude '*.jpg' --exclude '*.jpeg' --exclude '*.png' --exclude '*.gif' --exclude '*.svg' --exclude '*.ico' --exclude '*.webp' --exclude package-lock.json --exclude yarn.lock",
      },
      grep = {
        rg_opts = [[--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -g "!*.jpg" -g "!*.jpeg" -g "!*.png" -g "!*.gif" -g "!*.svg" -g "!*.ico" -g "!*.webp" -g "!package-lock.json" -g "!yarn.lock" -e]],
      },
      actions = {
        files = {
          ['default'] = actions.file_edit_or_qf,
          ['ctrl-h'] = actions.file_vsplit,
        },
      },
    }
  end,
  keys = {
    {
      '<leader>ff',
      function()
        -- Check if the current buffer is inside a git repository
        local is_in_git_repo = vim.fn.finddir('.git', '.;') ~= ''

        if is_in_git_repo then
          require('fzf-lua').git_files()
        else
          require('fzf-lua').files()
        end
      end,
      desc = 'Find Files (Project/CWD)',
    },
    {
      '<leader>fg',
      function()
        local is_in_git_repo = vim.fn.finddir('.git', '.;') ~= ''

        if is_in_git_repo then
          require('fzf-lua').grep_project()
        else
          require('fzf-lua').live_grep()
        end
      end,
      desc = 'Live Grep (Project/CWD)',
    },
    {
      '<leader>fc',
      function()
        require('fzf-lua').files { cwd = vim.fn.stdpath 'config' }
      end,
      desc = 'Find in neovim configuration',
    },
    {
      '<leader>fh',
      function()
        require('fzf-lua').helptags()
      end,
      desc = '[F]ind [H]elp',
    },
    {
      '<leader>fk',
      function()
        require('fzf-lua').keymaps()
      end,
      desc = '[F]ind [K]eymaps',
    },
    {
      '<leader>fb',
      function()
        require('fzf-lua').builtin()
      end,
      desc = '[F]ind [B]uiltin FZF',
    },
    {
      '<leader>fw',
      function()
        require('fzf-lua').grep_cword()
      end,
      desc = '[F]ind current [W]ord',
    },
    {
      '<leader>fW',
      function()
        require('fzf-lua').grep_cWORD()
      end,
      desc = '[F]ind current [W]ORD',
    },
    {
      '<leader>fd',
      function()
        require('fzf-lua').diagnostics_document()
      end,
      desc = '[F]ind [D]iagnostics',
    },
    {
      '<leader>fr',
      function()
        require('fzf-lua').resume()
      end,
      desc = '[F]ind [R]esume',
    },
    {
      '<leader>fo',
      function()
        require('fzf-lua').oldfiles()
      end,
      desc = '[F]ind [O]ld Files',
    },
    {
      '<leader><leader>',
      function()
        require('fzf-lua').buffers()
      end,
      desc = '[,] Find existing buffers',
    },
    {
      '<leader>/',
      function()
        require('fzf-lua').lgrep_curbuf()
      end,
      desc = '[/] Live grep the current buffer',
    },
  },
}
