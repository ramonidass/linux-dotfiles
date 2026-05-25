return {
  {
    'tpope/vim-fugitive',
    cmd = { 'G', 'Git', 'Gdiffsplit', 'Gvdiffsplit', 'Gread', 'Gwrite', 'Ggrep', 'GMove', 'GDelete', 'GBrowse' },
    keys = {
      -- { '<leader>gd', '<cmd>Gvdiff<CR>', desc = 'Git Diff Split' },
      { '<leader>gB', '<cmd>Git blame<CR>', desc = 'Git Blame' },
    },
  },
}
