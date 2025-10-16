return {
  'akinsho/bufferline.nvim',
  event = 'BufWinEnter',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  keys = {
    { '<leader>bn', '<cmd>BufferLineCycleNext<CR>', desc = 'Next Buffer' },
    { '<leader>bp', '<cmd>BufferLineCyclePrev<CR>', desc = 'Previous Buffer' },
    { '<leader>bc', '<cmd>bdelete<CR>', desc = 'Close Buffer' },
    { '<leader>bC', '<cmd>BufferLinePickClose<CR>', desc = 'Pick & Close Buffer' },
    { '<leader>bP', '<cmd>BufferLinePick<CR>', desc = 'Pick Buffer' },
    { '[b', '<cmd>BufferLineCyclePrev<CR>', desc = 'Previous Buffer' },
    { ']b', '<cmd>BufferLineCycleNext<CR>', desc = 'Next Buffer' },
  },
  config = function()
    local buff = require 'bufferline'
    buff.setup {
      options = {
        close_command = 'bdelete! %d',
        left_mouse_command = 'buffer %d',
        indicator = {
          icon = '▎',
          style = 'icon',
        },
        tab_size = 18,
        diagnostics = 'nvim_lsp',
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
          local s = ' '
          for e, n in pairs(diagnostics_dict) do
            local sym = e == 'error' and ' ' or (e == 'warning' and ' ' or ' ')
            s = s .. n .. sym
          end
          return s
        end,
        custom_filter = function(buf_number, buf_numbers)
          -- Get the buffer's file type and name
          local filetype = vim.bo[buf_number].filetype
          local bufname = vim.api.nvim_buf_get_name(buf_number)

          -- Filter out special buffers
          if filetype == 'neo-tree' or filetype == 'alpha' then
            return false
          end

          -- Filter out Claude Code buffers
          if bufname:match 'claude%-code' then
            return false
          end

          return true
        end,
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = true,
        show_tab_indicators = true,
        persist_buffer_sort = true,
        separator_style = 'thick',
        enforce_regular_tabs = false,
        always_show_bufferline = false,
        offsets = { { filetype = 'neo-tree', text = 'Explorer', padding = 1, text_align = 'left' } },
      },
    }
  end,
}
