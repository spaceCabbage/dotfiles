-- Project & Buffer Search and Replace
-- 1. grug-far.nvim: Project-wide / multi-file ripgrep search & replace split panel
-- 2. nvim-rip-substitute: Sleek floating popup for current-file/selection ripgrep regex replace

return {
  {
    'MagicDuck/grug-far.nvim',
    cmd = { 'GrugFar', 'GrugFarWithin' },
    opts = {
      headerMaxWidth = 80,
      transient = true,
      keymaps = {
        close = { n = 'q' },
      },
    },
    keys = {
      {
        '<leader>sr',
        function()
          local grug = require 'grug-far'
          local ext = vim.bo.buftype == '' and vim.fn.expand '%:e'
          grug.open {
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= '' and '*.' .. ext or nil,
            },
          }
        end,
        mode = { 'n', 'x' },
        desc = 'Search & Replace in Project (GrugFar)',
      },
      {
        '<leader>sw',
        function()
          require('grug-far').open {
            transient = true,
            prefills = {
              search = vim.fn.expand '<cword>',
            },
          }
        end,
        mode = 'n',
        desc = 'Search & Replace Current Word (Project)',
      },
      {
        '<leader>sF',
        function()
          require('grug-far').open {
            transient = true,
            prefills = {
              paths = vim.fn.expand '%',
            },
          }
        end,
        mode = { 'n', 'x' },
        desc = 'Search & Replace in Current File (GrugFar Split)',
      },
    },
  },
  {
    'chrisgrieser/nvim-rip-substitute',
    cmd = 'RipSubstitute',
    opts = {
      popupWin = {
        border = 'rounded',
      },
    },
    keys = {
      {
        '<leader>sf',
        function()
          require('rip-substitute').sub()
        end,
        mode = { 'n', 'x' },
        desc = 'Search & Replace in File / Selection (RipSubstitute Popup)',
      },
    },
  },
}
