return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    quickfile = { enabled = true },
    indent = {
      enabled = true,
      animate = { enabled = false },
    },
    input = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 3000,
    },
    words = { enabled = true },
    statuscolumn = { enabled = true },
    scratch = {
      enabled = true,
      ft = 'markdown',
    },
    zen = {
      enabled = true,
      toggles = {
        dim = false,
        git_signs = false,
        diagnostics = false,
      },
      win = {
        width = 100,
      },
    },
    explorer = {
      enabled = true,
      replace_netrw = true,
    },
    picker = {
      enabled = true,
      ui_select = true,
      sources = {
        explorer = {
          hidden = true,
          ignored = false,
          layout = { layout = { position = 'left', width = 34 } },
        },
      },
    },
    dashboard = {
      enabled = true,
      preset = {
        keys = {
          { icon = ' ', key = 'f', desc = 'Find File', action = ':lua Snacks.picker.files()' },
          { icon = ' ', key = 'g', desc = 'Find Text (Grep)', action = ':lua Snacks.picker.grep()' },
          { icon = ' ', key = 'd', desc = 'Review Changes (Diffview)', action = ':DiffviewOpen' },
          { icon = '󰠮 ', key = 'n', desc = 'Project Notes & Docs', action = ":lua Snacks.picker.files({ args = { '-e', 'md', '-e', 'mdx', '-e', 'txt' } })" },
          { icon = '󱞁 ', key = 's', desc = 'Project Scratch Note', action = ':lua Snacks.scratch()' },
          { icon = ' ', key = 'r', desc = 'Recent Files', action = ':lua Snacks.picker.recent()' },
          { icon = ' ', key = 'c', desc = 'Neovim Config', action = ":lua Snacks.picker.files({ cwd = vim.fn.stdpath('config') })" },
          { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
        },
      },
      sections = {
        { section = 'header' },
        { section = 'keys', gap = 1, padding = 1 },
        { section = 'startup' },
      },
    },
  },
  keys = {
    -- Top-level quick access
    { '<leader><leader>', function() Snacks.picker.smart() end, desc = 'Smart Find Files' },
    { '<leader>,', function() Snacks.picker.buffers() end, desc = 'Switch Buffer' },
    { '<leader>/', function() Snacks.picker.lines() end, desc = 'Find in Current Buffer' },
    { '<leader>:', function() Snacks.picker.command_history() end, desc = 'Command History' },
    { '<leader>p', function() Snacks.picker.commands() end, desc = 'Command Palette' },
    { '<leader>e', function() Snacks.explorer() end, desc = 'Toggle File Explorer' },

    -- Find (<leader>f)
    { '<leader>ff', function() Snacks.picker.files() end, desc = 'Find Files' },
    { '<leader>fg', function() Snacks.picker.grep() end, desc = 'Grep in Files' },
    { '<leader>fw', function() Snacks.picker.grep_word() end, desc = 'Grep Word / Selection', mode = { 'n', 'x' } },
    { '<leader>fb', function() Snacks.picker.buffers() end, desc = 'Find Buffers' },
    { '<leader>fr', function() Snacks.picker.recent() end, desc = 'Recent Files' },
    { '<leader>fc', function() Snacks.picker.files { cwd = vim.fn.stdpath 'config' } end, desc = 'Find in Neovim Config' },
    { '<leader>fp', function() Snacks.picker.projects() end, desc = 'Projects' },

    -- Search / Inspect (<leader>s)
    { '<leader>sb', function() Snacks.picker.grep_buffers() end, desc = 'Grep Open Buffers' },
    { '<leader>sd', function() Snacks.picker.diagnostics() end, desc = 'Workspace Diagnostics' },
    { '<leader>sD', function() Snacks.picker.diagnostics_buffer() end, desc = 'Buffer Diagnostics' },
    { '<leader>sh', function() Snacks.picker.help() end, desc = 'Help Pages' },
    { '<leader>sk', function() Snacks.picker.keymaps() end, desc = 'Search Keymaps' },
    { '<leader>sm', function() Snacks.picker.marks() end, desc = 'Marks' },
    { '<leader>sn', function() Snacks.picker.notifications() end, desc = 'Notification History' },
    { '<leader>sq', function() Snacks.picker.qflist() end, desc = 'Quickfix List' },
    { '<leader>s.', function() Snacks.picker.resume() end, desc = 'Resume Last Picker' },
    { '<leader>su', function() Snacks.picker.undo() end, desc = 'Undo History Tree' },

    -- Buffers (<leader>b)
    { '<leader>bd', function() Snacks.bufdelete() end, desc = 'Delete Buffer' },
    { '<leader>bo', function() Snacks.bufdelete.other() end, desc = 'Delete Other Buffers' },
    { '<leader>bb', function() Snacks.picker.buffers() end, desc = 'Pick Buffer' },

    -- Git Pickers (<leader>g)
    { '<leader>gg', function() Snacks.lazygit() end, desc = 'Lazygit' },
    { '<leader>gl', function() Snacks.picker.git_log() end, desc = 'Git Log (Picker)' },
    { '<leader>gf', function() Snacks.picker.git_log_file() end, desc = 'Git File History (Picker)' },
    { '<leader>gst', function() Snacks.picker.git_status() end, desc = 'Git Status Files (Picker)' },
    { '<leader>gB', function() Snacks.gitbrowse() end, desc = 'Open in Git Browser', mode = { 'n', 'v' } },

    -- Terminal & Zen (<leader>t)
    { '<leader>tt', function() Snacks.terminal() end, desc = 'Toggle Terminal' },
    { '<leader>tz', function() Snacks.zen() end, desc = 'Toggle Zen Mode' },

    -- Reference jump
    { ']]', function() Snacks.words.jump(vim.v.count1) end, desc = 'Next Reference', mode = { 'n', 't' } },
    { '[[', function() Snacks.words.jump(-vim.v.count1) end, desc = 'Prev Reference', mode = { 'n', 't' } },
  },
}
