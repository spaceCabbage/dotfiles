return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>cf',
      function()
        require('conform').format {
          async = true,
          lsp_format = 'fallback',
        }
      end,
      mode = { 'n', 'x' },
      desc = 'Format Buffer / Selection',
    },
    {
      '<leader>tf',
      function()
        vim.g.disable_autoformat = not vim.g.disable_autoformat
        local state = vim.g.disable_autoformat and 'Disabled' or 'Enabled'
        vim.notify('Format on Save: ' .. state, vim.log.levels.INFO)
      end,
      desc = 'Toggle Format on Save',
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      local disable_filetypes = { c = true, cpp = true }
      if disable_filetypes[vim.bo[bufnr].filetype] then
        return nil
      end
      return {
        timeout_ms = 500,
        lsp_format = 'fallback',
      }
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
      go = { 'goimports', 'gofumpt' },
      python = { 'ruff_organize_imports', 'ruff_format', 'isort', 'black', stop_after_first = false },
      javascript = { 'prettier', stop_after_first = true },
      typescript = { 'prettier', stop_after_first = true },
      javascriptreact = { 'prettier', stop_after_first = true },
      typescriptreact = { 'prettier', stop_after_first = true },
      vue = { 'prettier', stop_after_first = true },
      css = { 'prettier', stop_after_first = true },
      scss = { 'prettier', stop_after_first = true },
      html = { 'prettier', stop_after_first = true },
      json = { 'prettier', stop_after_first = true },
      yaml = { 'prettier', stop_after_first = true },
      markdown = { 'prettier', stop_after_first = true },
    },
  },
}
