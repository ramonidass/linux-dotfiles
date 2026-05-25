return {
  'ibhagwan/fzf-lua',
  dependencies = { 'echasnovski/mini.icons' },
  config = function()
    require('fzf-lua').setup {
      winopts = {
        height = 0.85,
        width = 0.75,
        row = 0.35,
        col = 0.50,
        border = 'rounded',
      },
      -- Global settings: always search from git root
      global_git_icons = false,
      global_file_icons = true,
      -- Global file filtering (excludes images, packages, etc.)
      files = {
        cwd_prompt = true,
        cwd_prompt_shorten_len = 32,
        git_icons = false,
        -- This tells fzf-lua to search from git root by default
        cmd = "git ls-files --cached --others --exclude-standard || fd --type f --hidden --exclude .git --exclude node_modules --exclude '*.jpg' --exclude '*.jpeg' --exclude '*.png' --exclude '*.gif' --exclude '*.svg' --exclude '*.ico' --exclude '*.webp' --exclude package-lock.json --exclude yarn.lock",
        fd_opts = [[--color=never --hidden --type f --type l --exclude .git --exclude node_modules --exclude '*.jpg' --exclude '*.jpeg' --exclude '*.png' --exclude '*.gif' --exclude '*.svg' --exclude '*.ico' --exclude '*.webp' --exclude package-lock.json --exclude yarn.lock]],
        rg_opts = [[--color=never --hidden --files --follow -g "!.git" -g "!node_modules" -g "!*.jpg" -g "!*.jpeg" -g "!*.png" -g "!*.gif" -g "!*.svg" -g "!*.ico" -g "!*.webp" -g "!package-lock.json" -g "!yarn.lock"]],
      },
      grep = {
        rg_opts = [[--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -g "!*.jpg" -g "!*.jpeg" -g "!*.png" -g "!*.gif" -g "!*.svg" -g "!*.ico" -g "!*.webp" -g "!package-lock.json" -g "!yarn.lock" -e]],
      },
    }
  end,
  keys = {
    {
      '<leader>ff',
      function()
        -- Use git_files if in a git repo, otherwise use regular files
        local is_git = vim.fn.system('git rev-parse --is-inside-work-tree 2>/dev/null'):match 'true'
        if is_git then
          require('fzf-lua').git_files()
        else
          require('fzf-lua').files()
        end
      end,
      desc = 'Find Files (git-aware)',
    },
    {
      '<leader>fg',
      function()
        require('fzf-lua').live_grep()
      end,
      desc = 'Live grep in current directory',
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
