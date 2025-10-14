return {
  'rmagatti/auto-session',
  lazy = false,
  keys = {
    { '<leader>ss', '<cmd>SessionSave<CR>', desc = 'Save Session' },
    { '<leader>sR', '<cmd>SessionRestore<CR>', desc = 'Restore Session' },
    { '<leader>sl', '<cmd>SessionSearch<CR>', desc = 'List Sessions' },
    { '<leader>sD', '<cmd>SessionDelete<CR>', desc = 'Delete Session' },
    { '<leader>sx', '<cmd>SessionDisableAutoSave<CR>', desc = 'Stop Auto-Session' },
  },
  ---@module "auto-session"
  ---@type AutoSession.Config
  opts = {
    suppressed_dirs = { '~/', '~/Downloads', '/' },
    auto_restore = false,
    bypass_save_filetypes = { 'alpha' },
  },
}
