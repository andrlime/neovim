require('lazy').setup({
  'tpope/vim-sleuth',
  { 'Bilal2453/luvit-meta', lazy = true },
  require('plugins.colorscheme'),
  require('plugins.conform'),
  require('plugins.git'),
  require('plugins.lazydev'),
  require('plugins.lsp'),
  require('plugins.misc'),
  require('plugins.bufferline'),
  require('plugins.flash'),
  require('plugins.indent'),
  require('plugins.telescope'),
  require('plugins.todocomments'),
  require('plugins.tree'),
  require('plugins.statusline'),
  require('plugins.whichkey'),
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘', config = '🛠', event = '📅', ft = '📂',
      init = '⚙', keys = '🗝', plugin = '🔌', runtime = '💻',
      require = '🌙', source = '📄', start = '🚀', task = '📌', lazy = '💤 ',
    },
  },
})
