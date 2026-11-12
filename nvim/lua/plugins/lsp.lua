return {
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
        { path = 'snacks.nvim', words = { 'Snacks' } },
      },
    },
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', opts = {} },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      'saghen/blink.cmp',
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = desc })
          end

          -- Fast LSP Navigation via Snacks Picker
          map('gd', function() Snacks.picker.lsp_definitions() end, 'Go to Definition')
          map('gD', function() Snacks.picker.lsp_declarations() end, 'Go to Declaration')
          map('gr', function() Snacks.picker.lsp_references() end, 'Find References')
          map('gI', function() Snacks.picker.lsp_implementations() end, 'Go to Implementation')
          map('gy', function() Snacks.picker.lsp_type_definitions() end, 'Go to Type Definition')
          map('K', vim.lsp.buf.hover, 'Hover Documentation')
          map('<leader>k', vim.lsp.buf.signature_help, 'Signature Help')

          -- Code / LSP menu (<leader>c)
          map('<leader>cr', vim.lsp.buf.rename, 'Rename Symbol')
          map('<leader>ca', vim.lsp.buf.code_action, 'Code Action', { 'n', 'x' })
          map('<leader>cD', vim.lsp.buf.declaration, 'Go to Declaration')
          map('<leader>ci', function() Snacks.picker.lsp_implementations() end, 'Go to Implementation')
          map('<leader>ct', function() Snacks.picker.lsp_type_definitions() end, 'Go to Type Definition')
          map('<leader>cR', function() Snacks.picker.lsp_references() end, 'Find References')
          map('<leader>cs', function() Snacks.picker.lsp_symbols() end, 'Document Symbols / Outline')
          map('<leader>cS', function() Snacks.picker.lsp_workspace_symbols() end, 'Workspace Symbols')

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, 'Toggle Inlay Hints')
          end
        end,
      })

      -- Diagnostic Config
      vim.diagnostic.config {
        severity_sort = true,
        float = {
          border = 'rounded',
          source = 'if_many',
        },
        underline = {
          severity = vim.diagnostic.severity.ERROR,
        },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
        },
      }

      local capabilities = require('blink.cmp').get_lsp_capabilities()

      local servers = {
        gopls = {
          settings = {
            gopls = {
              analyses = { unusedparams = true },
              staticcheck = true,
              gofumpt = true,
            },
          },
        },
        pyright = {
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                diagnosticMode = 'openFilesOnly',
                useLibraryCodeForTypes = true,
              },
            },
          },
        },
        ts_ls = {},
        vue_ls = {},
        lua_ls = {
          settings = {
            Lua = {
              completion = { callSnippet = 'Replace' },
            },
          },
        },
        html = {},
        cssls = {},
        jsonls = {},
        tailwindcss = {},
        dockerls = {},
        docker_compose_language_service = {},
        bashls = {},
        taplo = {},
        yamlls = {},
        marksman = {
          cmd_env = {
            DOTNET_SYSTEM_GLOBALIZATION_INVARIANT = '1',
          },
        }, -- Markdown LSP (provides heading outline, links, and TOC)
      }

      -- Configure servers using Neovim 0.11+ native vim.lsp.config API
      vim.lsp.config('*', {
        capabilities = capabilities,
      })
      for server_name, server_cfg in pairs(servers) do
        server_cfg.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server_cfg.capabilities or {})
        vim.lsp.config(server_name, server_cfg)
      end

      require('mason-tool-installer').setup {
        run_on_start = false, -- Don't block startup; run :MasonToolsInstall when needed
        ensure_installed = {
          'gopls',
          'pyright',
          'typescript-language-server',
          'vue-language-server',
          'lua-language-server',
          'html-lsp',
          'css-lsp',
          'json-lsp',
          'tailwindcss-language-server',
          'dockerfile-language-server',
          'docker-compose-language-service',
          'bash-language-server',
          'taplo',
          'yaml-language-server',
          'marksman',
          'stylua',
          'gofumpt',
          'goimports',
          'ruff',
          'prettier',
        },
      }

      require('mason-lspconfig').setup {
        ensure_installed = {},
        automatic_enable = true,
      }
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    lazy = false,
    config = function()
      -- Support both nvim-treesitter v1 (main branch, Neovim 0.11/0.12+) and legacy master branch
      local ok_configs, configs = pcall(require, 'nvim-treesitter.configs')
      if ok_configs then
        configs.setup {
          ensure_installed = {
            'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc',
            'go', 'gomod', 'gosum', 'gowork',
            'python', 'javascript', 'typescript', 'tsx', 'vue',
            'css', 'scss', 'json', 'yaml', 'dockerfile', 'make', 'toml', 'regex', 'sql',
            'gitignore', 'git_config', 'gitcommit',
          },
          auto_install = true,
          highlight = { enable = true },
          indent = { enable = true },
        }
      else
        require('nvim-treesitter').setup {}
        vim.api.nvim_create_autocmd('FileType', {
          group = vim.api.nvim_create_augroup('treesitter-start', { clear = true }),
          callback = function(ev)
            pcall(vim.treesitter.start, ev.buf)
          end,
        })
      end
    end,
  },
}
