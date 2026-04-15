return {
  'nvim-tree/nvim-tree.lua',
  version = '*',
  lazy = false,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('nvim-tree').setup {
      update_focused_file = {
        enable     = true,
        update_cwd = true,
      },
      view = {
        width = 30,
        side  = 'left',
      },
      renderer = {
        icons = {
          show = {
            file         = true,
            folder       = true,
            folder_arrow = true,
            git          = true,
          },
        },
      },
    }

    -- Auto-open tree when neovim opens a file
    vim.api.nvim_create_autocmd('VimEnter', {
      callback = function(data)
        local file = vim.fn.expand(data.file)
        if file ~= '' and vim.fn.filereadable(file) == 1 then
          require('nvim-tree.api').tree.open()
        end
      end,
    })

    -- Toggle with t
    vim.keymap.set('n', 't', ':NvimTreeToggle<CR>', { noremap = true, silent = true, desc = 'Toggle file tree' })

    -- When cwd changes, update the tree root to match
    vim.api.nvim_create_autocmd('DirChanged', {
      callback = function()
        require('nvim-tree.api').tree.change_root(vim.fn.getcwd())
      end,
    })
  end,
}
