return {
  'folke/flash.nvim',
  event = 'VeryLazy',
  opts  = {
    modes = {
      char = { enabled = false },  -- don't intercept t/f/T/F; keep t for tree toggle
    },
  },
  keys  = {
    { 's', function() require('flash').jump()       end, mode = { 'n', 'o' }, desc = 'Flash jump' },
    { 'S', function() require('flash').treesitter() end, mode = { 'n', 'o' }, desc = 'Flash treesitter' },
  },
}
