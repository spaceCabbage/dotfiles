return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    preset = 'modern',
    delay = 250,
    win = {
      border = 'rounded',
      padding = { 1, 2 },
      title = true,
      title_pos = 'center',
    },
    layout = {
      spacing = 3,
      align = 'center',
    },
    icons = {
      mappings = vim.g.have_nerd_font,
    },
    spec = {
      {
        mode = { 'n', 'v' },
        { '<leader>b', group = 'Buffers' },
        { '<leader>c', group = 'Code / LSP' },
        { '<leader>f', group = 'Find / Files' },
        { '<leader>g', group = 'Git / Diff Review' },
        { '<leader>n', group = 'Notes / Markdown' },
        { '<leader>q', group = 'Quickfix / Quit' },
        { '<leader>s', group = 'Search / Replace' },
        { '<leader>t', group = 'Toggle / Terminal' },
        { '<leader>w', group = 'Windows' },
        { '<leader>x', group = 'Diagnostics / Trouble' },
        { '[', group = 'Prev' },
        { ']', group = 'Next' },
        { 'g', group = 'Goto' },
        { 'gs', group = 'Surround' },
        { 'z', group = 'Fold / View' },
      },
    },
  },
  keys = {
    {
      '<leader>?',
      function()
        require('which-key').show { global = false }
      end,
      desc = 'Buffer Local Keymaps (Which-Key)',
    },
  },
}
