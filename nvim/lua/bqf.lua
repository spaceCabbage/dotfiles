return {
  'kevinhwang91/nvim-bqf',
  ft = 'qf',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
  },
  opts = {
    auto_enable = true,
    auto_resize_height = true,
    preview = {
      win_height = 12,
      win_vheight = 3,
      delay_syntax = 80,
      border = 'rounded',
      should_preview_command = function(bufnr, qwinid)
        local ret = true
        local bufname = vim.fn.bufname(bufnr)
        if bufname:match 'fugitive://' then
          ret = false
        end
        return ret
      end,
    },
    func_map = {
      vsplit = '',
      ptoggleup = 'K',
      ptoggledown = 'J',
      stoggleup = 'k',
      stoggledown = 'j',
      stogglezf = 'z',
      open = 'o',
      openc = 'O',
      drop = 'd',
      split = '<C-s>',
      tabdrop = '',
      tabc = '',
      tabvs = '',
      tabo = '',
      prevfile = '<C-p>',
      nextfile = '<C-n>',
      prevhist = '<',
      nexthist = '>',
      lastleave = "'\"",
      mhistory = '',
      qmenu = '',
      filter = 'zf',
      filterr = 'zF',
      fzffilter = '',
    },
    filter = {
      fzf = {
        action_for = { ['ctrl-splitkeep'] = 'split' },
        extra_opts = { '--bind', 'ctrl-o:toggle-all', '--delimiter', '│' },
      },
    },
  },
}
