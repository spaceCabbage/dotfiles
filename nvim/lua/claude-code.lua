-- Claude Code Neovim Integration
-- Seamlessly integrates Claude Code CLI into Neovim
-- Automatically reloads files modified by Claude Code
return {
  'greggh/claude-code.nvim',
  lazy = false, -- Load on startup for auto-reload to work
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  keys = {
    -- Primary toggle - works in normal and terminal mode
    { '<leader>ac', '<cmd>ClaudeCodeToggle<CR>', desc = 'Claude Code Toggle', mode = { 'n', 't' } },
    { '<C-,>', '<cmd>ClaudeCodeToggle<CR>', desc = 'Claude Code Toggle', mode = { 'n', 't' } },

    -- Start new sessions with different options
    { '<leader>aa', '<cmd>ClaudeCode<CR>', desc = 'Claude Code Start', mode = 'n' },
    { '<leader>av', '<cmd>ClaudeCode --verbose<CR>', desc = 'Claude Code (Verbose)', mode = 'n' },
    { '<leader>ar', '<cmd>ClaudeCode --continue<CR>', desc = 'Claude Code Continue', mode = 'n' },
  },
}
