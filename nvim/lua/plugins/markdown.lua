-- Markdown Reading, Writing & Note-Taking System (<leader>n)
-- Works seamlessly in any notes folder or inside project codebases

-- Toggle Markdown checkbox on the current line: `- [ ]` <-> `- [x]`, or turn bullet into `- [ ]`
local function toggle_checkbox()
  local line = vim.api.nvim_get_current_line()
  local updated
  if line:match '^%s*[-*+]%s+%[ %]' then
    updated = line:gsub('^(%s*[-*+]%s+)%[ %]', '%1[x]', 1)
  elseif line:match '^%s*[-*+]%s+%[[xX]%]' then
    updated = line:gsub('^(%s*[-*+]%s+)%[[xX]%]', '%1[ ]', 1)
  elseif line:match '^%s*[-*+]%s+' then
    updated = line:gsub('^(%s*[-*+]%s+)', '%1[ ] ', 1)
  else
    local indent = line:match '^(%s*)' or ''
    local rest = line:gsub('^%s*', '')
    updated = indent .. '- [ ] ' .. rest
  end
  vim.api.nvim_set_current_line(updated)
end

-- Create a new markdown note in the current project/folder
local function create_markdown_note()
  vim.ui.input({ prompt = 'New Markdown Note (e.g. notes/todo.md or docs/plan.md): ' }, function(input)
    if not input or input == '' then
      return
    end
    if not input:match '%.md$' and not input:match '%.mdx$' then
      input = input .. '.md'
    end
    local dir = vim.fn.fnamemodify(input, ':h')
    if dir ~= '.' and dir ~= '' then
      vim.fn.mkdir(dir, 'p')
    end
    vim.cmd('edit ' .. vim.fn.fnameescape(input))
  end)
end

return {
  'MeanderingProgrammer/render-markdown.nvim',
  ft = { 'markdown', 'quarto', 'rmd' },
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  keys = {
    -- Notes & Markdown (<leader>n)
    {
      '<leader>nf',
      function()
        Snacks.picker.files {
          title = 'Markdown Notes & Docs',
          args = { '--extension', 'md', '--extension', 'mdx', '--extension', 'txt' },
        }
      end,
      desc = 'Find Markdown Notes in Folder/Repo',
    },
    {
      '<leader>ng',
      function()
        Snacks.picker.grep {
          title = 'Grep in Markdown Notes',
          glob = { '*.md', '*.mdx', '*.txt' },
        }
      end,
      desc = 'Search Inside Markdown Notes',
    },
    {
      '<leader>nn',
      create_markdown_note,
      desc = 'New Markdown Note',
    },
    {
      '<leader>ns',
      function()
        Snacks.scratch()
      end,
      desc = 'Toggle Project Scratch Note',
    },
    {
      '<leader>nS',
      function()
        Snacks.scratch.select()
      end,
      desc = 'Select Scratch Note',
    },
    {
      '<leader>no',
      function()
        Snacks.picker.lsp_symbols { title = 'Markdown Outline / Headings' }
      end,
      desc = 'Note Headings / Outline',
    },
    {
      '<leader>nc',
      toggle_checkbox,
      desc = 'Toggle Markdown Checkbox',
    },
    {
      '<leader>nr',
      '<cmd>RenderMarkdown toggle<CR>',
      desc = 'Toggle Markdown Live Rendering',
    },
    {
      '<leader>nz',
      function()
        Snacks.zen()
      end,
      desc = 'Toggle Zen Reading/Writing Mode',
    },
    {
      '<leader>tm',
      '<cmd>RenderMarkdown toggle<CR>',
      desc = 'Toggle Markdown Rendering',
    },
  },
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {
    render_modes = { 'n', 'c', 't' }, -- Render in Normal mode, show raw markdown on active cursor line while editing
    anti_conceal = {
      enabled = true,
    },
    heading = {
      sign = false,
      position = 'inline',
      width = 'block',
      left_pad = 1,
      right_pad = 2,
      icons = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
    },
    code = {
      sign = false,
      width = 'block',
      right_pad = 2,
      left_pad = 2,
      border = 'thin',
    },
    checkbox = {
      enabled = true,
      unchecked = { icon = '󰄱 ' },
      checked = { icon = '󰱒 ' },
    },
    bullet = {
      icons = { '●', '○', '◆', '◇' },
    },
    pipe_table = {
      preset = 'round',
    },
  },
  init = function()
    -- Comfortable prose reading & writing experience for Markdown files
    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('markdown-prose-mode', { clear = true }),
      pattern = { 'markdown', 'mdx', 'text', 'gitcommit' },
      callback = function(event)
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true -- Wrap cleanly at word boundaries, not mid-word
        vim.opt_local.breakindent = true
        vim.opt_local.conceallevel = 2
        vim.opt_local.spell = true
        vim.opt_local.spelllang = 'en_us'

        -- Navigate wrapped lines naturally with j/k unless a count is given
        vim.keymap.set({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { buffer = event.buf, expr = true, silent = true })
        vim.keymap.set({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { buffer = event.buf, expr = true, silent = true })
      end,
    })
  end,
}
