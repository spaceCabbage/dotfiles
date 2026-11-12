return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    options = {
      icons_enabled = true,
      theme = 'auto',
      globalstatus = true,
      section_separators = { left = '', right = '' },
      component_separators = { left = '', right = '' },
      disabled_filetypes = {
        statusline = { 'snacks_dashboard' },
      },
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = {
        'branch',
        'diff',
        { 'diagnostics', sources = { 'nvim_diagnostic' } },
      },
      lualine_c = {
        { 'filename', path = 1 },
      },
      lualine_x = {
        {
          function()
            local clients = vim.lsp.get_clients { bufnr = 0 }
            if #clients == 0 then
              return ''
            end
            local names = {}
            for _, c in ipairs(clients) do
              table.insert(names, c.name)
            end
            return ' ' .. table.concat(names, ',')
          end,
        },
        'filetype',
      },
      lualine_y = { 'progress' },
      lualine_z = { 'location' },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { { 'filename', path = 1 } },
      lualine_x = { 'location' },
      lualine_y = {},
      lualine_z = {},
    },
  },
}
