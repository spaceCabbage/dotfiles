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
      { '<leader>s', group = ' Search/Session' },
      { '<leader>t', group = ' Toggle/Terminal' },
      { '<leader>w', group = ' Window' },
      { 'g', group = 'Go to', mode = 'n' },
      { 'gc', group = '󰆉 Comment', mode = { 'n', 'v' } },
    }
  end,
}
