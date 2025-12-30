-- Welcome to my newest attempy at a nvim config

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true
vim.opt.number = true
vim.opt.mouse = 'a'
vim.opt.showmode = false
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)
vim.opt.termguicolors = true
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.confirm = true
vim.opt.relativenumber = true

-- [[ Basic Keymaps ]]
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic quickfix list' })
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Window navigation handled by vim-tmux-navigator plugin (see lazy.setup below)

-- Better scrolling (center cursor)
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Scroll down (centered)' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Scroll up (centered)' })
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Next search result (centered)' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Previous search result (centered)' })

-- Better indenting
vim.keymap.set('v', '<', '<gv', { desc = 'Indent left (keep selection)' })
vim.keymap.set('v', '>', '>gv', { desc = 'Indent right (keep selection)' })

-- Move lines up/down
vim.keymap.set('n', '<A-j>', '<cmd>m .+1<CR>==', { desc = 'Move line down' })
vim.keymap.set('n', '<A-k>', '<cmd>m .-2<CR>==', { desc = 'Move line up' })
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

-- Better paste (don't replace clipboard)
vim.keymap.set('x', '<leader>p', [["_dP]], { desc = ' Paste without yanking' })

-- Quick save
vim.keymap.set('n', '<C-s>', '<cmd>w<CR>', { desc = 'Save file' })
vim.keymap.set('i', '<C-s>', '<Esc><cmd>w<CR>a', { desc = 'Save file' })

-- Window management
vim.keymap.set('n', '<leader>wv', '<C-w>v', { desc = 'Split window vertically' })
vim.keymap.set('n', '<leader>wh', '<C-w>s', { desc = 'Split window horizontally' })
vim.keymap.set('n', '<leader>we', '<C-w>=', { desc = 'Equal window sizes' })
vim.keymap.set('n', '<leader>wc', '<cmd>close<CR>', { desc = 'Close window' })
vim.keymap.set('n', '<leader>wo', '<cmd>only<CR>', { desc = 'Close other windows' })

-- Diagnostic navigation
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous Diagnostic' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next Diagnostic' })
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Show Diagnostic' })

-- Quickfix & Location list
vim.keymap.set('n', '[q', '<cmd>cprev<CR>', { desc = 'Previous Quickfix' })
vim.keymap.set('n', ']q', '<cmd>cnext<CR>', { desc = 'Next Quickfix' })
vim.keymap.set('n', '<leader>qo', '<cmd>copen<CR>', { desc = 'Open Quickfix' })
vim.keymap.set('n', '<leader>qc', '<cmd>cclose<CR>', { desc = 'Close Quickfix' })
vim.keymap.set('n', '<leader>lo', '<cmd>lopen<CR>', { desc = ' Open Location List' })
vim.keymap.set('n', '<leader>lc', '<cmd>lclose<CR>', { desc = ' Close Location List' })

-- Buffer management
vim.keymap.set('n', '<leader>ba', '<cmd>%bd|e#<CR>', { desc = 'Close All Buffers' })
vim.keymap.set('n', '<leader>bo', '<cmd>%bd|e#|bd#<CR>', { desc = 'Close Other Buffers' })
vim.keymap.set('n', '<leader>bh', '<cmd>BufferLineCloseLeft<CR>', { desc = 'Close Buffers to Left' })
vim.keymap.set('n', '<leader>bl', '<cmd>BufferLineCloseRight<CR>', { desc = 'Close Buffers to Right' })

-- Toggle options
vim.keymap.set('n', '<leader>tn', '<cmd>set number!<CR>', { desc = 'Toggle Line Numbers' })
vim.keymap.set('n', '<leader>tr', '<cmd>set relativenumber!<CR>', { desc = 'Toggle Relative Numbers' })
vim.keymap.set('n', '<leader>tw', '<cmd>set wrap!<CR>', { desc = 'Toggle Line Wrap' })
vim.keymap.set('n', '<leader>ts', '<cmd>set spell!<CR>', { desc = 'Toggle Spell Check' })
vim.keymap.set('n', '<leader>tc', function()
  if vim.wo.colorcolumn == '' then
    vim.wo.colorcolumn = '80'
  else
    vim.wo.colorcolumn = ''
  end
end, { desc = 'Toggle Colorcolumn' })

-- Terminal toggles (using vim's built-in terminal)
vim.keymap.set('n', '<leader>tt', '<cmd>split | terminal<CR>i', { desc = 'Toggle Terminal (Horizontal)' })
vim.keymap.set('n', '<leader>tv', '<cmd>vsplit | terminal<CR>i', { desc = 'Toggle Terminal (Vertical)' })
vim.keymap.set('n', '<leader>tf', '<cmd>terminal<CR>i', { desc = 'Toggle Floating Terminal' })

-- Misc useful keymaps
vim.keymap.set('n', '<leader>x', '<cmd>bd<CR><cmd>close<CR>', { desc = ' Close Buffer & Window' })
vim.keymap.set({ 'n', 'v' }, '<leader>y', '"+y', { desc = ' Yank to Clipboard' })
vim.keymap.set('n', '<leader>Y', '"+Y', { desc = ' Yank Line to Clipboard' })
vim.keymap.set({ 'n', 'v' }, '<leader>D', '"_d', { desc = ' Delete Without Yank' })
vim.keymap.set('n', 'J', 'mzJ`z', { desc = 'Join lines (keep cursor)' })
vim.keymap.set('v', 'Q', ':norm @q<CR>', { desc = 'Replay macro on selection' })

-- Config reload
vim.keymap.set('n', '<leader>r', function()
  for name, _ in pairs(package.loaded) do
    if name:match '^user' or name:match '^config' then
      package.loaded[name] = nil
    end
  end
  dofile(vim.fn.stdpath 'config' .. '/init.lua')
  vim.notify('Config reloaded!', vim.log.levels.INFO)
end, { desc = 'Reload config' })

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

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

require('lazy').setup {
  'tpope/vim-sleuth',
  {
    'christoomey/vim-tmux-navigator',
    keys = {
      { '<C-h>', '<cmd>TmuxNavigateLeft<cr>' },
      { '<C-j>', '<cmd>TmuxNavigateDown<cr>' },
      { '<C-k>', '<cmd>TmuxNavigateUp<cr>' },
      { '<C-l>', '<cmd>TmuxNavigateRight<cr>' },
    },
  },
  ui = {
    icons = {},
  },

  -- [[ Plugins ]]
  require 'lsp',
  require 'theme',
  require 'statusline',
  require 'whichkey',
  require 'minis',
  require 'formatting',
  require 'search',
  require 'sessions',
  require 'completions',
  require 'dashboard',
  require 'tailwind',
  require 'filetree',
  require 'markdown',
  require 'indents',
  require 'tabs',
  require 'wakatime',
  require 'ai-claude',
  require 'trouble',
  require 'flash',
  require 'bqf',
  -- require 'hints',
}
