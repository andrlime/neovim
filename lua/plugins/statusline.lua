return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons', 'catppuccin/nvim' },
  config = function()
    local function get_palette()
      local ok, pal = pcall(require, 'catppuccin.palettes')
      return ok and pal.get_palette() or nil
    end

    local function make_theme()
      local p = get_palette()
      if not p then return 'auto' end
      local bar = { fg = p.text, bg = p.surface0 }
      return {
        normal   = { a = { fg = p.mantle, bg = p.blue,  gui = 'bold' }, b = bar, c = bar },
        insert   = { a = { fg = p.mantle, bg = p.green, gui = 'bold' }, b = bar, c = bar },
        visual   = { a = { fg = p.mantle, bg = p.mauve, gui = 'bold' }, b = bar, c = bar },
        replace  = { a = { fg = p.mantle, bg = p.red,   gui = 'bold' }, b = bar, c = bar },
        command  = { a = { fg = p.mantle, bg = p.peach, gui = 'bold' }, b = bar, c = bar },
        terminal = { a = { fg = p.mantle, bg = p.teal,  gui = 'bold' }, b = bar, c = bar },
        inactive = { a = { fg = p.overlay0, bg = p.surface0 }, b = { fg = p.overlay0, bg = p.surface0 }, c = { fg = p.overlay0, bg = p.surface0 } },
      }
    end

    local L_CAP = '\u{E0B6}'
    local R_CAP = '\u{E0B4}'

    local function cap_color()
      local p = get_palette()
      if not p then return nil end
      local map = {
        n = p.blue,  no = p.blue,
        i = p.green, ic = p.green,
        R = p.red,   Rv = p.red,
        c = p.peach, cv = p.peach,
        v = p.mauve, V  = p.mauve,
        t = p.teal,
      }
      local m = vim.fn.mode(1)
      local mc = map[m:sub(1,2)] or map[m:sub(1,1)] or p.mauve
      return { fg = mc, bg = p.surface0 }
    end

    -- Shared cap components — reused on both left pill and right pill
    local lc = { function() return L_CAP end, color = cap_color, padding = { left = 2, right = 0 }, separator = { right = '' } }
    local rc = { function() return R_CAP end, color = cap_color, padding = { left = 0, right = 2 }, separator = { left  = '' } }
    local plain = { separator = { left = '', right = '' }, padding = { left = 0, right = 0 } }

    require('lualine').setup {
      options = {
        theme                = make_theme(),
        section_separators   = { left = '', right = '' },
        component_separators = { left = '│', right = '│' },
        globalstatus         = true,
      },
      sections = {
        lualine_a = { lc, vim.tbl_extend('force', { 'mode' },     plain), rc },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { { 'filename', path = 1 } },
        lualine_x = { 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { lc, vim.tbl_extend('force', { 'location' }, plain), rc },
      },
    }

    vim.api.nvim_create_autocmd('ColorScheme', {
      callback = function()
        require('lualine').setup { options = { theme = make_theme() } }
      end,
    })
  end,
}
