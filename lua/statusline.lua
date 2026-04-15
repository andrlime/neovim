-- Floating pill statusline — centered, never touching sides.
-- Mode block uses a per-mode color; a powerline '' separator creates a
-- smooth arrow transition into the surface0 body.

local api = vim.api
local fn  = vim.fn

local WIDTH_PCT = 0.52
local NS        = api.nvim_create_namespace('statusbar_hl')

-- ── mode ─────────────────────────────────────────────────────────────────────

local mode_labels = {
  n  = 'NORMAL',  no = 'N·PEND', nov = 'N·PEND',
  i  = 'INSERT',  ic = 'INSERT',
  R  = 'REPLACE', Rv = 'V·REPL',
  c  = 'COMMAND', cv = 'COMMAND',
  t  = 'TERM',
  ['!'] = 'SHELL',
}

local mode_hls = {
  n  = 'SBModeNormal',  no  = 'SBModeNormal',  nov = 'SBModeNormal',
  i  = 'SBModeInsert',  ic  = 'SBModeInsert',
  R  = 'SBModeReplace', Rv  = 'SBModeReplace',
  c  = 'SBModeCommand', cv  = 'SBModeCommand',
  t  = 'SBModeTerm',
}

local function mode_str()    return mode_labels[fn.mode()] or fn.mode():upper() end
local function cur_mode_hl() return mode_hls[fn.mode()]    or 'SBModeOther'     end

-- ── content ──────────────────────────────────────────────────────────────────

local function branch()
  local b = vim.b.gitsigns_head
  return b and (' ' .. b) or ''
end

local function filename()
  local name = fn.expand('%:t')
  if name == '' then return '[No Name]' end
  return name .. (vim.bo.modified and ' ●' or '')
end

local function diagnostics()
  local d = vim.diagnostic.count(0)
  local e = d[vim.diagnostic.severity.ERROR] or 0
  local w = d[vim.diagnostic.severity.WARN]  or 0
  local out = ''
  if e > 0 then out = out .. ' ' .. e end
  if w > 0 then out = out .. ' ' .. w end
  return out ~= '' and (out .. '  ') or ''
end

local function ft_icon()
  local ok, devicons = pcall(require, 'nvim-web-devicons')
  if not ok then return '' end
  local ft = vim.bo.filetype
  if ft == '' then return '' end
  local icon = devicons.get_icon_by_filetype(ft, { default = false })
  return icon and (icon .. '  ') or ''
end

local function location()
  return fn.line('.') .. ':' .. fn.col('.')
end

-- ── window ───────────────────────────────────────────────────────────────────

local state = { buf = nil, win = nil }

local function win_cfg()
  local w = math.max(30, math.floor(vim.o.columns * WIDTH_PCT))
  return {
    relative  = 'editor',
    width     = w,
    height    = 1,
    row       = vim.o.lines - 4,
    col       = math.floor((vim.o.columns - w) / 2),
    style     = 'minimal',
    focusable = false,
    zindex    = 5,
    border    = 'rounded',
  }
end

local function ensure_win()
  if state.buf and api.nvim_buf_is_valid(state.buf)
  and state.win and api.nvim_win_is_valid(state.win) then
    return
  end
  state.buf = api.nvim_create_buf(false, true)
  vim.bo[state.buf].buftype   = 'nofile'
  vim.bo[state.buf].bufhidden = 'wipe'
  vim.bo[state.buf].swapfile  = false
  state.win = api.nvim_open_win(state.buf, false, win_cfg())
  vim.wo[state.win].winhighlight = 'Normal:SBBody,FloatBorder:SBBorder'
end

-- ── rendering ────────────────────────────────────────────────────────────────

local function update()
  local ok, err = pcall(function()
    ensure_win()
    api.nvim_win_set_config(state.win, win_cfg())

    local mstr     = mode_str()
    -- Badge: ' NORMAL ' — the entire padded badge is highlighted, nothing else
    local badge    = ' ' .. mstr .. ' '
    local badge_len = #badge   -- ASCII only, byte len == display width

    local b      = branch()
    local div    = ' │ '
    local body_l = (b ~= '' and (b .. '  ') or '') .. filename()
    local body_r = diagnostics() .. ft_icon() .. location() .. ' '

    local w   = api.nvim_win_get_width(state.win)
    local pad = math.max(1, w
      - fn.strdisplaywidth(badge)
      - fn.strdisplaywidth(div)
      - fn.strdisplaywidth(body_l)
      - fn.strdisplaywidth(body_r))

    local line = badge .. div .. body_l .. string.rep(' ', pad) .. body_r
    api.nvim_buf_set_lines(state.buf, 0, -1, false, { line })

    -- Highlight only the badge; everything else inherits SBBody
    api.nvim_buf_clear_namespace(state.buf, NS, 0, -1)
    api.nvim_buf_set_extmark(state.buf, NS, 0, 0, {
      end_col  = badge_len,
      hl_group = cur_mode_hl(),
      priority = 200,
    })
  end)
  if not ok then
    vim.notify('statusline: ' .. tostring(err), vim.log.levels.WARN)
  end
end

-- ── highlights ───────────────────────────────────────────────────────────────

local function setup_hl()
  local ok, pal = pcall(require, 'catppuccin.palettes')
  if not ok then return end
  local p = pal.get_palette()

  api.nvim_set_hl(0, 'SBBody',   { bg = p.surface0, fg = p.text })
  api.nvim_set_hl(0, 'SBBorder', { bg = p.surface0, fg = p.overlay1 })

  -- Mode blocks (colored bg)
  api.nvim_set_hl(0, 'SBModeNormal',  { bg = p.blue,  fg = p.mantle, bold = true })
  api.nvim_set_hl(0, 'SBModeInsert',  { bg = p.green, fg = p.mantle, bold = true })
  api.nvim_set_hl(0, 'SBModeReplace', { bg = p.red,   fg = p.mantle, bold = true })
  api.nvim_set_hl(0, 'SBModeCommand', { bg = p.peach, fg = p.mantle, bold = true })
  api.nvim_set_hl(0, 'SBModeTerm',    { bg = p.teal,  fg = p.mantle, bold = true })
  api.nvim_set_hl(0, 'SBModeOther',   { bg = p.mauve, fg = p.mantle, bold = true })

end

-- ── autocmds ─────────────────────────────────────────────────────────────────

local grp = api.nvim_create_augroup('floating-statusbar', { clear = true })

api.nvim_create_autocmd({
  'ModeChanged', 'BufEnter', 'BufWritePost',
  'DiagnosticChanged', 'CursorMoved', 'CursorMovedI',
  'VimResized', 'WinResized',
}, { group = grp, callback = update })

api.nvim_create_autocmd('ColorScheme', {
  group = grp,
  callback = function() setup_hl(); update() end,
})

-- ── boot ─────────────────────────────────────────────────────────────────────

setup_hl()
vim.schedule(update)
