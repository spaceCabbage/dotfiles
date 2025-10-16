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

    -- Quick find files with <leader><leader>
    vim.keymap.set('n', '<leader><leader>', builtin.find_files, { desc = 'Find Files' })

    -- Command Palette with <leader>p
    vim.keymap.set('n', '<leader>p', function()
      require('command-palette').show()
    end, { desc = 'Command Palette' })

    -- Git keymaps under <leader>sg
    vim.keymap.set('n', '<leader>sgb', builtin.git_branches, { desc = 'Git Branches' })
    vim.keymap.set('n', '<leader>sgc', builtin.git_commits, { desc = 'Git Commits' })
    vim.keymap.set('n', '<leader>sgs', builtin.git_status, { desc = 'Git Status' })
    vim.keymap.set('n', '<leader>sgt', builtin.git_stash, { desc = 'Git Stash' })

    -- Search keymaps under <leader>sh (help, keymaps, etc.)
    vim.keymap.set('n', '<leader>shh', builtin.help_tags, { desc = 'Help Tags' })
    vim.keymap.set('n', '<leader>shk', builtin.keymaps, { desc = 'Keymaps' })
    vim.keymap.set('n', '<leader>shm', builtin.man_pages, { desc = 'Man Pages' })
    vim.keymap.set('n', '<leader>shr', builtin.registers, { desc = 'Registers' })

    -- Search other
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = 'Diagnostics' })
    vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = 'Resume Last Search' })
    vim.keymap.set('n', '<leader>st', builtin.builtin, { desc = 'Select Telescope' })
    vim.keymap.set('n', '<leader>sq', builtin.quickfix, { desc = 'Quickfix' })
    vim.keymap.set('n', '<leader>sl', builtin.loclist, { desc = 'Location List' })
  end,
}
