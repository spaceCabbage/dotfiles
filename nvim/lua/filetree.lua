return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    {
      '<leader>e',
      function()
        local git_root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
        if git_root and git_root ~= '' then
          require('neo-tree.command').execute { toggle = true, reveal = true, dir = git_root }
        else
          require('neo-tree.command').execute { toggle = true, reveal = true }
        end
      end,
      desc = 'Toggle [E]xplorer',
      silent = true,
    },
  },
  opts = {
    filesystem = {
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
    },
    default_component_configs = {
      icon = {
        folder_closed = '',
        folder_open = '',
        default = '*',
        highlight = 'Directory',
      },
      name = {
        trailing_slash = true,
        highlight = 'Normal',
      },
      git_status = {
        symbols = {
          added = '+',
          modified = '~',
          deleted = '-',
          renamed = '➜',
          untracked = '?',
          ignored = '◌',
          unstaged = '✗',
          staged = '✓',
          conflict = '',
        },
        highlight = 'GitSignsAdd',
      },
    },
  },
  config = function()
    -- Basic highlight overrides:
    vim.api.nvim_set_hl(0, 'NeoTreeNormal', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'NeoTreeNormalNC', { bg = 'none' })
    vim.api.nvim_set_hl(0, 'NeoTreeEndOfBuffer', { bg = 'none' })
    -- Optionally clear the separator if it's causing a grey line:
    vim.api.nvim_set_hl(0, 'NeoTreeWinSeparator', { bg = 'none', fg = 'none' })

    -- In case your colorscheme changes, reapply these settings:
    vim.api.nvim_create_autocmd('ColorScheme', {
      callback = function()
        vim.api.nvim_set_hl(0, 'NeoTreeNormal', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'NeoTreeNormalNC', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'NeoTreeEndOfBuffer', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'NeoTreeWinSeparator', { bg = 'none', fg = 'none' })
      end,
    })

    -- Open file tree on startup with dashboard
    vim.api.nvim_create_autocmd('VimEnter', {
      group = vim.api.nvim_create_augroup('neo-tree-auto-open', { clear = true }),
      callback = function()
        -- Only open if no file arguments were passed
        if vim.fn.argc() == 0 then
          vim.schedule(function()
            local git_root = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
            if git_root and git_root ~= '' then
              require('neo-tree.command').execute { toggle = true, reveal = true, dir = git_root }
            else
              require('neo-tree.command').execute { toggle = true, reveal = true }
            end
          end)
        end
      end,
    })
  end,
}
