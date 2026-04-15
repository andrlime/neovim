return {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 100000,
  init = function()
    require('catppuccin').setup {
      integrations = { bufferline = true },
    }
    vim.cmd.colorscheme 'catppuccin-mocha'
    vim.cmd.hi 'Comment gui=none'

    -- Toggle between dark (mocha) and light (latte) with <leader>tt
    vim.keymap.set('n', '<leader>tt', function()
      if vim.g.colors_name == 'catppuccin-mocha' then
        vim.cmd.colorscheme 'catppuccin-latte'
      else
        vim.cmd.colorscheme 'catppuccin-mocha'
      end
    end, { desc = '[T]oggle [T]heme light/dark' })
  end,
}
