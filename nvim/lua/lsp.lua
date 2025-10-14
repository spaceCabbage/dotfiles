return {
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = { {
        path = '${3rd}/luv/library',
        words = { 'vim%.uv' },
      } },
    },
  },
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      {
        'williamboman/mason.nvim',
        opts = {},
      },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      {
        'j-hui/fidget.nvim',
        opts = {},
      },
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', {
          clear = true,
        }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, {
              buffer = event.buf,
              desc = 'LSP: ' .. desc,
            })
          end

          -- LSP keymaps with <leader>c prefix for code actions
          map('<leader>cr', vim.lsp.buf.rename, 'Rename Symbol')
          map('<leader>ca', vim.lsp.buf.code_action, 'Code Action', { 'n', 'x' })
          map('<leader>cd', require('telescope.builtin').lsp_definitions, 'Go to Definition')
          map('<leader>cD', vim.lsp.buf.declaration, 'Go to Declaration')
          map('<leader>ci', require('telescope.builtin').lsp_implementations, 'Go to Implementation')
          map('<leader>ct', require('telescope.builtin').lsp_type_definitions, 'Go to Type Definition')
          map('<leader>cR', require('telescope.builtin').lsp_references, 'Find References')
          map('<leader>cs', require('telescope.builtin').lsp_document_symbols, 'Document Symbols')
          map('<leader>cS', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Workspace Symbols')

          -- Keep classic vim keymaps for quick navigation
          map('gd', require('telescope.builtin').lsp_definitions, 'Go to Definition')
          map('gD', vim.lsp.buf.declaration, 'Go to Declaration')
          map('gr', require('telescope.builtin').lsp_references, 'Go to References')
          map('gI', require('telescope.builtin').lsp_implementations, 'Go to Implementation')
          map('K', vim.lsp.buf.hover, 'Hover Documentation')
          map('<leader>k', vim.lsp.buf.signature_help, 'Signature Help')

          ---@param client vim.lsp.Client
          ---@param method vim.lsp.protocol.Method
          ---@param bufnr? integer some lsp support methods only in specific files
          ---@return boolean
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, {
                bufnr = bufnr,
              })
            end
          end

          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', {
              clear = false,
            })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', {
                clear = true,
              }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds {
                  group = 'kickstart-lsp-highlight',
                  buffer = event2.buf,
                }
              end,
            })
          end

          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled {
                bufnr = event.buf,
              })
            end, '[T]oggle Inlay [H]ints')
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
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      }

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
      local servers = {
        gopls = {
          settings = {
            gopls = {
              analyses = {
                unusedparams = true,
              },
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
                diagnosticMode = 'workspace',
                useLibraryCodeForTypes = true,
              },
            },
          },
        },
        ts_ls = {},
        volar = {
          filetypes = { 'vue', 'typescript', 'javascript' },
        },
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },
        html = {},
        cssls = {},
        jsonls = {},
        tailwindcss = {},
        -- Config files
        dockerls = {},      -- Docker
        docker_compose_language_service = {},  -- Docker Compose
        bashls = {},        -- Bash
        taplo = {},         -- TOML
        yamlls = {},        -- YAML
        marksman = {},      -- Markdown
      }

      -- Mason package names (different from lspconfig names)
      local ensure_installed = {
        -- LSP Servers
        'gopls',                            -- Go
        'pyright',                          -- Python
        'typescript-language-server',       -- JS/TS (ts_ls in lspconfig)
        'vue-language-server',              -- Vue (volar in lspconfig)
        'lua-language-server',              -- Lua (lua_ls in lspconfig)
        'html-lsp',                         -- HTML
        'css-lsp',                          -- CSS (cssls in lspconfig)
        'json-lsp',                         -- JSON (jsonls in lspconfig)
        'tailwindcss-language-server',      -- Tailwind
        'dockerfile-language-server',       -- Docker (dockerls in lspconfig)
        'docker-compose-language-service',  -- Docker Compose
        'bash-language-server',             -- Bash (bashls in lspconfig)
        'taplo',                            -- TOML
        'yaml-language-server',             -- YAML (yamlls in lspconfig)
        'marksman',                         -- Markdown
        -- Formatters & Linters
        'stylua',                           -- Lua formatter
        'gofumpt',                          -- Go formatter
        'goimports',                        -- Go imports organizer
        'black',                            -- Python formatter
        'isort',                            -- Python import sorter
        'prettier',                         -- JS/TS/Vue/HTML/CSS formatter
        'eslint_d',                         -- JS/TS linter
      }
      require('mason-tool-installer').setup {
        ensure_installed = ensure_installed,
      }
      require('mason-lspconfig').setup {
        ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
        automatic_installation = false,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    opts = {
      ensure_installed = {
        'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc',
        'go', 'gomod', 'gosum', 'gowork',   -- Go
        'python',                           -- Python
        'javascript', 'typescript', 'tsx',  -- JS/TS
        'vue',                              -- Vue
        'css', 'scss', 'json', 'yaml',      -- Web
        'dockerfile',                       -- Docker
        'make',                             -- Makefile
        'toml',                             -- TOML config files
        'terraform',                        -- Infrastructure as code
        'graphql',                          -- GraphQL
        'regex',                            -- Regular expressions
        'sql',                              -- SQL
        'proto',                            -- Protobuf
        'gitignore', 'git_config', 'gitcommit',  -- Git
      },
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = {
        enable = true,
        disable = { 'ruby' },
      },
    },
  },
}
