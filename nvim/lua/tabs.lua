return {
  'akinsho/bufferline.nvim',
  event = 'BufWinEnter', -- Load before buffers are actually read. You can tweak this as needed.
  dependencies = { 'nvim-tree/nvim-web-devicons' }, -- Optional: For file icons
  config = function()
    local buff = require 'bufferline'
    buff.setup {
      options = {
        close_command = 'bdelete! %d', -- Command to close a buffer
        left_mouse_command = 'buffer %d', -- Left-click to navigate to buffer
        indicator = {
          icon = '▎', -- Customize the indicator icon
          style = 'icon',
        },
        tab_size = 18,
        diagnostics = 'nvim_lsp',
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
          local s = ' '
          for e, n in pairs(diagnostics_dict) do
            local sym = e == 'error' and ' ' or (e == 'warning' and ' ' or ' ')
            s = s .. n .. sym
          end
          return s
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
  vim.keymap.set('n', '<leader>n', ':BufferLineCycleNext<CR>', { desc = '[N]ext Tab' }),
  vim.keymap.set('n', '<leader>p', ':BufferLineCyclePrev<CR>', { desc = '[P]rev Tab' }),
}
