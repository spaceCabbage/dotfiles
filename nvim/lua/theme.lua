return {
  { -- Color Scheme
    'sainnhe/gruvbox-material',
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.gruvbox_material_enable_italic = true
      vim.g.gruvbox_material_transparent_background = 2 -- 0=off, 1=partially transparent, 2=fully transparent
      vim.cmd.colorscheme 'gruvbox-material'
      vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
      vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'none' })
      vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'none' })
    end,
  },
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      signs = false,
    },
  },
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']h', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'Next Hunk' })

        map('n', '[h', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'Previous Hunk' })

        -- Actions
        map('n', '<leader>gs', gitsigns.stage_hunk, { desc = 'Stage Hunk' })
        map('n', '<leader>gr', gitsigns.reset_hunk, { desc = 'Reset Hunk' })
        map('v', '<leader>gs', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'Stage Hunk' })
        map('v', '<leader>gr', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'Reset Hunk' })
        map('n', '<leader>gS', gitsigns.stage_buffer, { desc = 'Stage Buffer' })
        map('n', '<leader>gu', gitsigns.undo_stage_hunk, { desc = 'Undo Stage Hunk' })
        map('n', '<leader>gR', gitsigns.reset_buffer, { desc = 'Reset Buffer' })
        map('n', '<leader>gp', gitsigns.preview_hunk, { desc = 'Preview Hunk' })
        map('n', '<leader>gb', function()
          gitsigns.blame_line { full = true }
        end, { desc = 'Blame Line' })
        map('n', '<leader>gB', gitsigns.toggle_current_line_blame, { desc = 'Toggle Line Blame' })
        map('n', '<leader>gd', gitsigns.diffthis, { desc = 'Diff This' })
        map('n', '<leader>gD', function()
          gitsigns.diffthis '~'
        end, { desc = 'Diff This ~' })

        -- Text object
        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'Inside Hunk' })
      end,
    },
  },
}
