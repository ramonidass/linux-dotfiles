local function setup_floating_terminal()
  vim.keymap.set('t', '<leader>`', '<c-\\><c-n>', { noremap = true, silent = true }) -- Single Esc to go to Normal mode
  vim.keymap.set('t', '<leader>kt', '<c-\\><c-n>:lua KillFloatingTerminal()<CR>', { noremap = true, silent = true }) -- Double Esc to kill terminal
  local state = {
    floating = {
      buf = -1,
      win = -1,
    },
  }

  local function create_floating_window(opts)
    opts = opts or {}
    local width = opts.width or math.floor(vim.o.columns * 0.9)
    local height = opts.height or math.floor(vim.o.lines * 0.8)

    local col = math.floor((vim.o.columns - width) / 2)
    local row = math.floor((vim.o.lines - height) / 2.5)

    local buf = state.floating.buf
    if not vim.api.nvim_buf_is_valid(buf) then
      buf = vim.api.nvim_create_buf(false, true)
      state.floating.buf = buf
    end

    local win_config = {
      relative = 'editor',
      width = width,
      height = height,
      col = col,
      row = row,
      style = 'minimal',
      border = 'single',
    }

    local win = vim.api.nvim_open_win(buf, true, win_config)
    return { buf = buf, win = win }
  end

  local toggle_terminal = function()
    if not vim.api.nvim_win_is_valid(state.floating.win) then
      state.floating = create_floating_window()

      if vim.bo[state.floating.buf].buftype ~= 'terminal' then
        vim.api.nvim_set_current_buf(state.floating.buf)
        vim.cmd 'terminal'
      end

      -- Enter terminal insert mode automatically
      vim.cmd 'startinsert'
    else
      vim.api.nvim_win_hide(state.floating.win)
    end
  end

  function KillFloatingTerminal()
    -- Close the floating window if valid
    if vim.api.nvim_win_is_valid(state.floating.win) then
      vim.api.nvim_win_close(state.floating.win, true)
    end
    -- Delete the buffer if valid
    if vim.api.nvim_buf_is_valid(state.floating.buf) then
      vim.api.nvim_buf_delete(state.floating.buf, { force = true })
    end
    -- Reset the state
    state.floating = { buf = -1, win = -1 }
  end

  vim.api.nvim_create_user_command('Floaterminal', toggle_terminal, {})
  vim.keymap.set({ 'n', 't' }, '<leader>t', toggle_terminal)
  vim.keymap.set({ 'n', 't' }, '<Esc>', toggle_terminal)
end

return {
  setup = setup_floating_terminal,
}
