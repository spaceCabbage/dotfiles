-- Claude Code Neovim Integration
-- Seamlessly integrates Claude Code CLI into Neovim
-- Automatically reloads files modified by Claude Code
return {
  'greggh/claude-code.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  opts = {
    command = vim.fn.expand('~/.claude/local/claude'), -- Full path to claude CLI
    window = {
      position = 'botright vertical', -- Open in vertical split on the right
      split_ratio = 0.4, -- Take 40% of screen width
      enter_insert = true,
      hide_numbers = true,
      hide_signcolumn = true,
    },
  },
  config = function(_, opts)
    require('claude-code').setup(opts)

    -- Set up keymaps after setup
    vim.keymap.set({ 'n', 't' }, '<leader>aa', '<cmd>ClaudeCode<CR>', { desc = 'Claude Toggle' })
    vim.keymap.set({ 'n', 't' }, '<C-,>', '<cmd>ClaudeCode<CR>', { desc = 'Claude Toggle' })
    vim.keymap.set('n', '<leader>av', '<cmd>ClaudeCodeVerbose<CR>', { desc = 'Claude (Verbose)' })
    vim.keymap.set('n', '<leader>ac', '<cmd>ClaudeCodeContinue<CR>', { desc = 'Claude Continue' })
  end,
}
