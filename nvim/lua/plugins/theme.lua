return {
  {
    'sainnhe/gruvbox-material',
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.gruvbox_material_enable_italic = true
      vim.g.gruvbox_material_better_performance = 1
      vim.g.gruvbox_material_transparent_background = 2
      vim.g.gruvbox_material_diagnostic_virtual_text = 'colored'
      vim.cmd.colorscheme 'gruvbox-material'

      local function apply_transparency()
        vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'none' })
        vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'none' })
      end

      apply_transparency()
      vim.api.nvim_create_autocmd('ColorScheme', {
        callback = apply_transparency,
      })
    end,
  },
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
      {
        ']t',
        function()
          require('todo-comments').jump_next()
        end,
        desc = 'Next Todo Comment',
      },
      {
        '[t',
        function()
          require('todo-comments').jump_prev()
        end,
        desc = 'Previous Todo Comment',
      },
    },
    opts = {
      signs = false,
    },
  },
}
