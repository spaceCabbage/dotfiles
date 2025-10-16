return {
  'folke/which-key.nvim',
  event = 'VimEnter',
  config = function()
    local wk = require 'which-key'
    wk.setup {
      delay = 400,
      icons = {
        mappings = vim.g.have_nerd_font,
        keys = {},
        group = '', -- Remove the '+' prefix from groups
      },
    }

    -- Register group names for leader key using new API
    wk.add {
      { '<leader>a', group = ' AI Assistant' },
      { '<leader>b', group = ' Buffers' },
      { '<leader>c', group = ' Code/LSP' },
      { '<leader>e', group = ' Explorer' },
      { '<leader>f', group = ' Find/Files' },
      { '<leader>g', group = ' Git' },
      { '<leader>p', group = ' Command Palette' },
      { '<leader>q', group = ' Quickfix' },
      { '<leader>l', group = ' Location List' },
      { '<leader>r', group = ' Reload Config' },
      { '<leader>s', group = ' Search' },
      { '<leader>sd', group = ' Diagnostics' },
      { '<leader>sf', group = ' Flash' },
      { '<leader>sg', group = ' Git' },
      { '<leader>sh', group = ' Help' },
      { '<leader>sl', group = ' Location' },
      { '<leader>sq', group = ' Quickfix' },
      { '<leader>st', group = ' Telescope' },
      { '<leader>t', group = ' Toggle/Terminal' },
      { '<leader>w', group = ' Window' },
      { '<leader>x', group = ' Diagnostics/Trouble' },
      { 'g', group = 'Go to', mode = 'n' },
      { 'gc', group = '󰆉 Comment', mode = { 'n', 'v' } },
    }
  end,
}
