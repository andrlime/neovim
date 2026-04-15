return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', opts = {} },
      'williamboman/mason-lspconfig.nvim',
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      -- Attach keymaps when an LSP connects to a buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach-keymaps', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end
          local telescope = require 'telescope.builtin'

          map('gd',        vim.lsp.buf.definition,      'Go to [D]efinition')
          map('gD',        vim.lsp.buf.declaration,     'Go to [D]eclaration')
          map('gvd', function()
            vim.cmd 'vsplit'
            vim.lsp.buf.definition()
          end, 'Go to definition in [V]split')
          map('gr',        telescope.lsp_references,         'Go to [R]eferences')
          map('gI',        telescope.lsp_implementations,    'Go to [I]mplementation')
          map('<leader>D', telescope.lsp_type_definitions,   'Type [D]efinition')
          map('<leader>ds', telescope.lsp_document_symbols,  '[D]ocument [S]ymbols')
          map('<leader>ws', telescope.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
          map('<leader>rn', vim.lsp.buf.rename,              '[R]e[n]ame')
          map('<leader>ca', vim.lsp.buf.code_action,         '[C]ode [A]ction')
          map('K',          vim.lsp.buf.hover,               'Hover Docs')
        end,
      })

      -- Advertise nvim-cmp capabilities to all servers
      local capabilities = vim.tbl_deep_extend(
        'force',
        vim.lsp.protocol.make_client_capabilities(),
        require('cmp_nvim_lsp').default_capabilities()
      )

      -- nvim 0.11+ API: vim.lsp.config sets per-server overrides,
      -- vim.lsp.enable activates them (lspconfig provides default filetypes/root patterns).
      vim.lsp.config('clangd', {
        capabilities = vim.tbl_deep_extend('force', capabilities, {
          offsetEncoding = { 'utf-16' },
        }),
        cmd = { 'clangd', '--background-index', '--header-insertion=iwyu' },
      })

      -- ocamllsp: installed via opam, not Mason.
      -- Run: opam install ocaml-lsp-server ocamlformat
      vim.lsp.config('ocamllsp', { capabilities = capabilities })

      -- Mason installs clangd; ocamllsp comes from opam
      require('mason-lspconfig').setup { ensure_installed = { 'clangd' } }

      -- Enable both servers — they attach automatically when a matching filetype opens
      vim.lsp.enable { 'clangd', 'ocamllsp' }
    end,
  },

  -- Completion engine
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
    },
    config = function()
      local cmp     = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-n>']     = cmp.mapping.select_next_item(),
          ['<C-p>']     = cmp.mapping.select_prev_item(),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>']      = cmp.mapping.confirm { select = true },
          ['<C-e>']     = cmp.mapping.abort(),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        },
        sources = cmp.config.sources {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'buffer' },
          { name = 'path' },
        },
      }
    end,
  },
}
