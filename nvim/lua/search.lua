return {
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },
    {
      'nvim-tree/nvim-web-devicons',
      enabled = vim.g.have_nerd_font,
    },
  },
  config = function()
    require('telescope').setup {
      extensions = {
        ['ui-select'] = { require('telescope.themes').get_dropdown() },
      },
    }

    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    local builtin = require 'telescope.builtin'

    -- File/Find keymaps under <leader>f
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find Files' })
    vim.keymap.set('n', '<leader>fr', builtin.oldfiles, { desc = 'Recent Files' })
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Grep in Files' })
    vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = 'Find Word' })
    vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find Buffers' })
    vim.keymap.set('n', '<leader>fn', function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = 'Find in Neovim Config' })
    vim.keymap.set('n', '<leader>fo', function()
      builtin.live_grep { grep_open_files = true, prompt_title = 'Grep in Open Files' }
    end, { desc = 'Find in Open Files' })
    vim.keymap.set('n', '<leader>/', function()
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = 'Find in Buffer' })

    -- Command Palette (better layout and formatting)
    vim.keymap.set('n', '<leader><leader>', function()
      builtin.commands {
        layout_strategy = 'vertical',
        layout_config = {
          width = 0.8,
          height = 0.9,
          preview_height = 0.4,
        },
      }
    end, { desc = 'Command Palette' })

    -- Search keymaps under <leader>s (help, keymaps, diagnostics, etc.)
    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = 'Search Help' })
    vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = 'Search Keymaps' })
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = 'Search Diagnostics' })
    vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = 'Resume Last Search' })
    vim.keymap.set('n', '<leader>st', builtin.builtin, { desc = 'Select Telescope' })
  end,
}
