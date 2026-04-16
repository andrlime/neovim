-- ── Visual mode: HARD DISABLED ──────────────────────────────────────────────
vim.keymap.set('n', 'v',     '<Nop>', { noremap = true })
vim.keymap.set('n', 'V',     '<Nop>', { noremap = true })
vim.keymap.set('n', '<C-v>', '<Nop>', { noremap = true })
vim.keymap.set('n', 'gv',    '<Nop>', { noremap = true })

-- ── Mouse: scroll only, all clicks/drags disabled ───────────────────────────
local mouse_nop_modes = { 'n', 'v', 'i' }
local mouse_nop_keys = {
  '<LeftMouse>', '<2-LeftMouse>', '<3-LeftMouse>', '<4-LeftMouse>',
  '<LeftDrag>', '<LeftRelease>',
  '<RightMouse>', '<RightDrag>', '<RightRelease>',
  '<MiddleMouse>',
}
for _, key in ipairs(mouse_nop_keys) do
  vim.keymap.set(mouse_nop_modes, key, '<Nop>', { noremap = true, silent = true })
end

-- ── Window navigation ────────────────────────────────────────────────────────
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus left' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus right' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus down' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus up' })
vim.keymap.set('n', '<C-Up>',    '<C-w>k', { noremap = true, silent = true })
vim.keymap.set('n', '<C-Down>',  '<C-w>j', { noremap = true, silent = true })
vim.keymap.set('n', '<C-Left>',  '<C-w>h', { noremap = true, silent = true })
vim.keymap.set('n', '<C-Right>', '<C-w>l', { noremap = true, silent = true })

-- ── Diagnostics ──────────────────────────────────────────────────────────────
vim.diagnostic.config {
  underline    = true,
  virtual_text = { prefix = '●', spacing = 2 },
  signs        = {
    text = {
      [vim.diagnostic.severity.ERROR] = ' ',
      [vim.diagnostic.severity.WARN]  = ' ',
      [vim.diagnostic.severity.INFO]  = ' ',
      [vim.diagnostic.severity.HINT]  = '󰌵 ',
    },
  },
  float        = { border = 'rounded', source = true },
  severity_sort = true,
}

-- Show full diagnostic message in a float when cursor rests on an error line
vim.api.nvim_create_autocmd('CursorHold', {
  callback = function()
    vim.diagnostic.open_float(nil, { focus = false, scope = 'cursor' })
  end,
})

-- ── Auto-save ────────────────────────────────────────────────────────────────
vim.api.nvim_create_autocmd({ 'InsertLeave', 'TextChanged' }, {
  callback = function()
    if vim.bo.modified and vim.bo.buftype == '' and vim.fn.expand('%') ~= '' then
      vim.cmd 'silent! write'
    end
  end,
})

-- ── Commands ─────────────────────────────────────────────────────────────────
-- :Q  — force quit all windows (like q! but global)
vim.api.nvim_create_user_command('Q', function() vim.cmd 'qa!' end, { desc = 'Force quit all' })

-- ── Comments ─────────────────────────────────────────────────────────────────
vim.keymap.set('n', '<C-/>', function()
  local start = vim.fn.line('.')
  local finish = start + math.max(vim.v.count1 - 1, 0)
  require('mini.comment').toggle_lines(start, finish)
end, { desc = 'Toggle comment [count lines]' })

-- ── General ──────────────────────────────────────────────────────────────────
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('', '<F1>', '<Nop>')
vim.keymap.set('i', '<F1>', '<Nop>')

-- ── Terminal mode ────────────────────────────────────────────────────────────
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
vim.keymap.set('t', '<Esc>',      '<C-\\><C-N>', { noremap = true, silent = true })

-- ── VS Code-style line operations ────────────────────────────────────────────
-- opt+up/down confirmed as <M-Up>/<M-Down> (\e[1;3A / \e[1;3B)
vim.keymap.set('n', '<M-Down>', ':m .+1<CR>==',       { noremap = true, silent = true, desc = 'Move line down' })
vim.keymap.set('n', '<M-Up>',   ':m .-2<CR>==',       { noremap = true, silent = true, desc = 'Move line up' })
vim.keymap.set('i', '<M-Down>', '<Esc>:m .+1<CR>==gi', { noremap = true, silent = true, desc = 'Move line down' })
vim.keymap.set('i', '<M-Up>',   '<Esc>:m .-2<CR>==gi', { noremap = true, silent = true, desc = 'Move line up' })

-- opt+shift+up/down = <M-S-Up>/<M-S-Down> (\e[1;4A / \e[1;4B)
vim.keymap.set('n', '<M-S-Down>', ':co .<CR>',          { noremap = true, silent = true, desc = 'Duplicate line down' })
vim.keymap.set('n', '<M-S-Up>',   ':co .-1<CR>',        { noremap = true, silent = true, desc = 'Duplicate line up' })
vim.keymap.set('i', '<M-S-Down>', '<Esc>:co .<CR>gi',   { noremap = true, silent = true, desc = 'Duplicate line down' })
vim.keymap.set('i', '<M-S-Up>',   '<Esc>:co .-1<CR>gi', { noremap = true, silent = true, desc = 'Duplicate line up' })

-- ── Buffer / tab navigation ──────────────────────────────────────────────────
vim.keymap.set('n', '<Tab>',   '<cmd>BufferLineCycleNext<CR>', { silent = true, desc = 'Next buffer' })
vim.keymap.set('n', '<S-Tab>', '<cmd>BufferLineCyclePrev<CR>', { silent = true, desc = 'Prev buffer' })
vim.keymap.set('n', '<leader>x', function()
  if vim.bo.buftype == 'terminal' then
    vim.cmd 'bdelete!'
  else
    vim.cmd 'bdelete'
  end
end, { silent = true, desc = 'Close buffer' })

-- ── Global search ────────────────────────────────────────────────────────────
-- <D-F> = Cmd+Shift+F (Kitty/Ghostty native; iTerm2 needs a key mapping set up)
vim.keymap.set('n', '<D-F>',   function() require('telescope.builtin').live_grep { cwd = vim.fn.getcwd() } end, { desc = 'Global search' })
-- Universal fallback (all terminals)
vim.keymap.set('n', '<C-S-f>', function() require('telescope.builtin').live_grep { cwd = vim.fn.getcwd() } end, { desc = 'Global search' })
