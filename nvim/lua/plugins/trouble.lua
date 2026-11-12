return {
  'folke/trouble.nvim',
  cmd = 'Trouble',
  keys = {
    { '<leader>xx', '<cmd>Trouble diagnostics toggle<CR>', desc = 'Diagnostics (Trouble)' },
    { '<leader>xw', '<cmd>Trouble diagnostics toggle filter.buf=0<CR>', desc = 'Buffer Diagnostics (Trouble)' },
    { '<leader>xW', '<cmd>Trouble diagnostics toggle filter.severity=vim.diagnostic.severity.WARN<CR>', desc = 'Warnings (Trouble)' },
    { '<leader>xE', '<cmd>Trouble diagnostics toggle filter.severity=vim.diagnostic.severity.ERROR<CR>', desc = 'Errors (Trouble)' },
    { '<leader>xs', '<cmd>Trouble symbols toggle focus=false<CR>', desc = 'Symbols (Trouble)' },
    { '<leader>xl', '<cmd>Trouble lsp toggle focus=false win.position=right<CR>', desc = 'LSP References (Trouble)' },
    { '<leader>xq', '<cmd>Trouble quickfix toggle<CR>', desc = 'Quickfix (Trouble)' },
    { '<leader>xL', '<cmd>Trouble loclist toggle<CR>', desc = 'Location List (Trouble)' },
  },
  opts = {
    focus = true,
    multiline = true,
    max_items = 200,
    indent_guides = true,
    win = {
      type = 'split',
      relative = 'win',
      position = 'bottom',
      size = 0.3,
    },
  },
}
