-- Git & Code Review Suite (Diffview + Gitsigns)
-- Built specifically for reviewing multi-file AI changes, staging hunks, and inspecting commit history

return {
  {
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'nvim-tree/nvim-web-devicons' },
    cmd = {
      'DiffviewOpen',
      'DiffviewClose',
      'DiffviewToggleFiles',
      'DiffviewFocusFiles',
      'DiffviewFileHistory',
      'DiffviewRefresh',
    },
    keys = {
      {
        '<leader>gd',
        function()
          local lib = require 'diffview.lib'
          if lib.get_current_view() then
            vim.cmd 'DiffviewClose'
          else
            vim.cmd 'DiffviewOpen'
          end
        end,
        desc = 'Toggle Diffview (Review Working Tree)',
      },
      { '<leader>gD', '<cmd>DiffviewOpen HEAD~1<CR>', desc = 'Diffview vs Previous Commit (HEAD~1)' },
      { '<leader>gm', '<cmd>DiffviewOpen main<CR>', desc = 'Diffview vs main' },
      { '<leader>gh', '<cmd>DiffviewFileHistory %<CR>', desc = 'Current File Git History' },
      { '<leader>gH', '<cmd>DiffviewFileHistory<CR>', desc = 'Repo Commit History' },
      { '<leader>ge', '<cmd>DiffviewToggleFiles<CR>', desc = 'Toggle Diffview File Tree' },
    },
    opts = function()
      local actions = require 'diffview.actions'
      return {
        enhanced_diff_hl = true,
        view = {
          default = {
            layout = 'diff2_horizontal',
            winbar_info = true,
          },
          merge_tool = {
            layout = 'diff3_mixed',
            disable_diagnostics = true,
            winbar_info = true,
          },
          file_history = {
            layout = 'diff2_horizontal',
            winbar_info = true,
          },
        },
        file_panel = {
          listing_style = 'tree', -- 'list' or 'tree' (toggleable with 'L' inside panel)
          tree_options = {
            flatten_dirs = true,
            folder_statuses = 'only_folded',
          },
          win_config = {
            position = 'left',
            width = 35,
          },
        },
        keymaps = {
          view = {
            { 'n', 'q', '<cmd>DiffviewClose<CR>', { desc = 'Close Diffview' } },
            { 'n', '<leader>e', actions.toggle_files, { desc = 'Toggle File Panel' } },
          },
          file_panel = {
            { 'n', 'q', '<cmd>DiffviewClose<CR>', { desc = 'Close Diffview' } },
            { 'n', '<leader>e', actions.toggle_files, { desc = 'Toggle File Panel' } },
          },
          file_history_panel = {
            { 'n', 'q', '<cmd>DiffviewClose<CR>', { desc = 'Close Diffview' } },
          },
        },
      }
    end,
  },
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      signs = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '' },
        topdelete = { text = '' },
        changedelete = { text = '▎' },
        untracked = { text = '▎' },
      },
      signs_staged = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '' },
        topdelete = { text = '' },
        changedelete = { text = '▎' },
      },
      current_line_blame_opts = {
        delay = 300,
      },
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Hunk Navigation
        map('n', ']h', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'Next Git Hunk' })

        map('n', '[h', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'Previous Git Hunk' })

        -- Hunk Actions (Review / Stage / Revert AI changes hunk-by-hunk)
        map('n', '<leader>gs', gitsigns.stage_hunk, { desc = 'Stage Hunk' })
        map('n', '<leader>gr', gitsigns.reset_hunk, { desc = 'Reset/Reject Hunk' })
        map('v', '<leader>gs', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'Stage Selected Hunk' })
        map('v', '<leader>gr', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'Reset/Reject Selected Hunk' })
        map('n', '<leader>gS', gitsigns.stage_buffer, { desc = 'Stage Entire Buffer' })
        map('n', '<leader>gR', gitsigns.reset_buffer, { desc = 'Reset Entire Buffer' })
        map('n', '<leader>gu', gitsigns.undo_stage_hunk, { desc = 'Undo Stage Hunk' })
        map('n', '<leader>gp', gitsigns.preview_hunk, { desc = 'Preview Hunk (Float)' })
        map('n', '<leader>gi', gitsigns.preview_hunk_inline, { desc = 'Preview Hunk Inline' })
        map('n', '<leader>gb', function()
          gitsigns.blame_line { full = true }
        end, { desc = 'Git Blame Line' })
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = 'Toggle Inline Git Blame' })

        -- Text object for hunk
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'Inside Git Hunk' })
      end,
    },
  },
}
