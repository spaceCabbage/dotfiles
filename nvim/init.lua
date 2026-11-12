-- Modern, lean Neovim config for code editing, AI diff review & note-taking

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

-- Disable netrw (Snacks explorer handles file browsing)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- [[ Core Options ]]
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.showmode = false
vim.opt.termguicolors = true
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 200
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.confirm = true
vim.opt.autoread = true -- Automatically re-read files changed outside of Neovim (e.g. by AI agents)

-- Better diff options (crucial for reviewing code & AI changes)
vim.opt.diffopt:append {
  'internal',
  'filler',
  'closeoff',
  'context:12',
  'algorithm:histogram',
  'linematch:60',
  'indent-heuristic',
}

vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- [[ Auto-Reload Files Changed on Disk (AI Workflow) ]]
vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold', 'CursorHoldI' }, {
  group = vim.api.nvim_create_augroup('auto-reload-disk-changes', { clear = true }),
  callback = function()
    if vim.fn.mode() ~= 'c' and vim.bo.buftype == '' then
      vim.cmd 'silent! checktime'
    end
  end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- [[ Core Keymaps ]]
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Centered scrolling & search navigation
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Scroll down (centered)' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Scroll up (centered)' })
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Next search result (centered)' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Previous search result (centered)' })

-- Better indenting & line movement
vim.keymap.set('v', '<', '<gv', { desc = 'Indent left (keep selection)' })
vim.keymap.set('v', '>', '>gv', { desc = 'Indent right (keep selection)' })
vim.keymap.set('n', '<A-j>', '<cmd>m .+1<CR>==', { desc = 'Move line down' })
vim.keymap.set('n', '<A-k>', '<cmd>m .-2<CR>==', { desc = 'Move line up' })
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })
vim.keymap.set('n', 'J', 'mzJ`z', { desc = 'Join lines (keep cursor)' })

-- Clipboard & register helpers
vim.keymap.set('x', '<leader>P', [["_dP]], { desc = 'Paste without yanking' })
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y', { desc = 'Yank to system clipboard' })
vim.keymap.set('n', '<leader>Y', '"+Y', { desc = 'Yank line to system clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>D', '"_d', { desc = 'Delete without yanking' })

-- Quick save & quit
vim.keymap.set({ 'n', 'i', 'x', 's' }, '<C-s>', '<cmd>w<CR><esc>', { desc = 'Save file' })
vim.keymap.set('n', '<leader>qq', '<cmd>qa<CR>', { desc = 'Quit all' })

-- Window management (<leader>w)
vim.keymap.set('n', '<leader>wv', '<C-w>v', { desc = 'Split window vertically' })
vim.keymap.set('n', '<leader>wh', '<C-w>s', { desc = 'Split window horizontally' })
vim.keymap.set('n', '<leader>we', '<C-w>=', { desc = 'Equal window sizes' })
vim.keymap.set('n', '<leader>wc', '<cmd>close<CR>', { desc = 'Close current window' })
vim.keymap.set('n', '<leader>wo', '<cmd>only<CR>', { desc = 'Close other windows' })

-- Buffer navigation (<leader>b and [b / ]b)
vim.keymap.set('n', '[b', '<cmd>bprevious<CR>', { desc = 'Previous Buffer' })
vim.keymap.set('n', ']b', '<cmd>bnext<CR>', { desc = 'Next Buffer' })
vim.keymap.set('n', '<leader>bn', '<cmd>bnext<CR>', { desc = 'Next Buffer' })
vim.keymap.set('n', '<leader>bp', '<cmd>bprevious<CR>', { desc = 'Previous Buffer' })

-- Diagnostics
vim.keymap.set('n', '[d', function()
  vim.diagnostic.jump { count = -1, float = true }
end, { desc = 'Previous Diagnostic' })
vim.keymap.set('n', ']d', function()
  vim.diagnostic.jump { count = 1, float = true }
end, { desc = 'Next Diagnostic' })
vim.keymap.set('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Line Diagnostics (Float)' })

-- Quickfix (<leader>q and [q / ]q)
vim.keymap.set('n', '[q', '<cmd>cprev<CR>zz', { desc = 'Previous Quickfix' })
vim.keymap.set('n', ']q', '<cmd>cnext<CR>zz', { desc = 'Next Quickfix' })
vim.keymap.set('n', '<leader>qo', '<cmd>copen<CR>', { desc = 'Open Quickfix List' })
vim.keymap.set('n', '<leader>qc', '<cmd>cclose<CR>', { desc = 'Close Quickfix List' })
vim.keymap.set('n', '<leader>qd', vim.diagnostic.setloclist, { desc = 'Diagnostics to Location List' })

-- UI / Editor Toggles (<leader>t)
vim.keymap.set('n', '<leader>tn', '<cmd>set number!<CR>', { desc = 'Toggle Line Numbers' })
vim.keymap.set('n', '<leader>tr', '<cmd>set relativenumber!<CR>', { desc = 'Toggle Relative Numbers' })
vim.keymap.set('n', '<leader>tw', '<cmd>set wrap!<CR>', { desc = 'Toggle Line Wrap' })
vim.keymap.set('n', '<leader>ts', '<cmd>set spell!<CR>', { desc = 'Toggle Spell Check' })
vim.keymap.set('n', '<leader>tc', function()
  vim.wo.colorcolumn = (vim.wo.colorcolumn == '') and '100' or ''
end, { desc = 'Toggle Colorcolumn (100)' })

-- [[ Bootstrap lazy.nvim ]]
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end
---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  'tpope/vim-sleuth', -- Automatically detect shiftwidth and expandtab
  {
    'christoomey/vim-tmux-navigator',
    keys = {
      { '<C-h>', '<cmd>TmuxNavigateLeft<cr>', desc = 'Navigate Left (Tmux/Vim)' },
      { '<C-j>', '<cmd>TmuxNavigateDown<cr>', desc = 'Navigate Down (Tmux/Vim)' },
      { '<C-k>', '<cmd>TmuxNavigateUp<cr>', desc = 'Navigate Up (Tmux/Vim)' },
      { '<C-l>', '<cmd>TmuxNavigateRight<cr>', desc = 'Navigate Right (Tmux/Vim)' },
    },
  },

  { import = 'plugins' },
}, {
  ui = {
    border = 'rounded',
  },
  change_detection = {
    notify = false,
  },
})
