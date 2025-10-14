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

    -- Register group names for leader key
    wk.register({
      b = { name = ' Buffers' },
      c = { name = ' Code/LSP' },
      e = { name = ' Explorer' },
      f = { name = ' Find/Files' },
      g = { name = ' Git' },
      q = { name = ' Quickfix' },
      l = { name = ' Location List' },
      s = { name = ' Search/Session' },
      t = { name = ' Toggle/Terminal' },
      w = { name = ' Window' },
    }, { prefix = '<leader>' })

    -- Register other group prefixes
    wk.register({
      g = { name = 'Go to / Git' },
    }, { mode = 'n' })

    wk.register({
      gc = { name = '󰆉 Comment' },
    }, { mode = { 'n', 'v' } })
  end,
}
