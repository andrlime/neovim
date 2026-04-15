return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('bufferline').setup {
      options = {
        mode                    = 'buffers',
        separator_style         = 'slant',
        show_close_icon         = false,
        show_buffer_close_icons = true,
        diagnostics             = 'nvim_lsp',
        offsets = {
          { filetype = 'NvimTree', text = 'Files', highlight = 'Directory', padding = 1 },
        },
      },
    }
  end,
}
