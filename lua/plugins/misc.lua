return {
  'echasnovski/mini.nvim',
  config = function()
    require('mini.ai').setup { n_lines = 500 }
    require('mini.surround').setup()
    require('mini.comment').setup()   -- gcc = toggle line comment, gc<motion>
    require('mini.pairs').setup()     -- auto-close () [] {} '' ""
  end,
}
