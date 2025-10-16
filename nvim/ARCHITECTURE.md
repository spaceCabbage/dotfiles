# Neovim Configuration Architecture

Technical documentation of how this configuration is structured, organized, and works.

## Table of Contents

1. [High-Level Overview](#high-level-overview)
2. [Directory Structure](#directory-structure)
3. [Core Components](#core-components)
4. [Plugin System](#plugin-system)
5. [Configuration Flow](#configuration-flow)
6. [Extending the Config](#extending-the-config)

## High-Level Overview

This configuration follows a modular, plugin-based architecture using **Lazy.nvim** as the plugin manager.

```
init.lua (Main Entry Point)
    ├── Basic Settings (options, keymaps, autocmds)
    └── Lazy Setup
        └── Loads lua/
            ├── lsp.lua (Language servers)
            ├── completions.lua (Autocompletion)
            ├── search.lua (Telescope + keymaps)
            ├── formatting.lua (Code formatters)
            ├── theme.lua (UI plugins)
            ├── statusline.lua (Status bar)
            ├── whichkey.lua (Keymap documentation)
            ├── tabs.lua (Buffer tabs)
            ├── filetree.lua (File explorer)
            ├── sessions.lua (Session management)
            ├── dashboard.lua (Startup dashboard)
            ├── minis.lua (Mini utilities)
            ├── indents.lua (Indent visualization)
            ├── markdown.lua (Markdown support)
            ├── tailwind.lua (Tailwind CSS)
            ├── wakatime.lua (Time tracking)
            ├── ai-claude.lua (Claude integration)
            ├── trouble.lua (Diagnostics)
            ├── flash.lua (Smart navigation)
            └── bqf.lua (Better quickfix)
```

## Directory Structure

```
nvim/
├── init.lua                    # Main config file (150 lines)
│   ├── Global settings
│   ├── Keybindings (general use)
│   ├── Lazy.nvim setup
│   └── Plugin loading
│
├── lua/                        # Module directory (~20 files)
│   ├── lsp.lua                # LSP configuration (280 lines)
│   │   ├── Mason (package manager)
│   │   ├── LSP servers setup
│   │   ├── Diagnostics config
│   │   └── Treesitter config
│   │
│   ├── completions.lua        # Autocompletion (90 lines)
│   │   ├── nvim-cmp setup
│   │   ├── LuaSnip snippets
│   │   └── Autopairs
│   │
│   ├── search.lua             # Finding & grepping (65 lines)
│   │   ├── Telescope setup
│   │   └── Search keybindings
│   │
│   ├── formatting.lua         # Code formatting (50 lines)
│   │   └── Conform setup
│   │
│   ├── theme.lua              # UI & appearance (85 lines)
│   │   ├── Colorscheme
│   │   ├── gitsigns
│   │   └── todo-comments
│   │
│   ├── statusline.lua         # Status bar config
│   ├── whichkey.lua           # Keymap menus
│   ├── tabs.lua               # Bufferline setup
│   ├── filetree.lua           # Neo-tree setup
│   ├── sessions.lua           # Auto-session setup
│   ├── dashboard.lua          # Alpha dashboard
│   ├── minis.lua              # Mini.nvim modules
│   ├── indents.lua            # Indent-blankline
│   ├── markdown.lua           # Markdown rendering
│   ├── tailwind.lua           # Tailwind support
│   ├── wakatime.lua           # WakaTime tracking
│   ├── ai-claude.lua          # Claude integration
│   ├── trouble.lua            # Trouble diagnostics
│   ├── flash.lua              # Flash navigation
│   └── bqf.lua                # Better quickfix
│
├── lazy-lock.json             # Plugin lock file
├── SETUP.md                   # Setup guide
├── KEYBINDINGS.md            # All keybindings
├── ARCHITECTURE.md           # This file
└── QUICKSTART.md             # Quick tips
```

## Core Components

### 1. init.lua - Main Configuration

**Responsibilities:**
- Global Neovim settings (`vim.opt.*`)
- Core keybindings (window nav, save, search, etc.)
- Lazy.nvim initialization
- Auto-commands for general features

**Structure:**
```lua
-- 1. Welcome comment
-- 2. Leader key setup
-- 3. vim.opt settings (50+ settings)
-- 4. Basic keymaps (30+ keymaps)
-- 5. Auto-commands (highlight on yank)
-- 6. Lazy.nvim setup
-- 7. Plugin requires
```

**Key Settings:**
- `number = true` - Show line numbers
- `mouse = 'a'` - Mouse support
- `clipboard = 'unnamedplus'` - System clipboard
- `updatetime = 250` - LSP update speed
- Leader: `<Space>`

### 2. Plugin Architecture (Lazy.nvim)

Uses **Lazy.nvim** for lazy-loading:

```lua
-- Each lua/*.lua file returns a table describing a plugin
return {
  'github-user/plugin-name',
  event = 'VimEnter',           -- When to load
  cmd = 'PluginCommand',        -- Or load on command
  keys = { ... },               -- Or load on keymap
  dependencies = { ... },       -- Required plugins
  opts = { ... },               -- Default options
  config = function(_, opts)    -- Custom setup
    require('plugin').setup(opts)
  end,
}
```

**Benefits:**
- Lazy loading: Plugins load only when needed (~100ms startup)
- No conflicts: Each plugin in isolated config
- Easy to extend: Add new plugin file, add to init.lua

### 3. LSP System (lsp.lua)

**Components:**

```
Mason (Package Manager)
  ↓
Mason-lspconfig (Links Mason to LSP)
  ↓
nvim-lspconfig (Actual LSP setup)
  ↓
Treesitter (Syntax highlighting)
```

**Flow:**
```lua
1. Mason installs servers (gopls, pyright, ts_ls, etc.)
2. Mason-lspconfig maps package names to lspconfig names
3. nvim-lspconfig connects to servers
4. Keybindings attached when LSP attaches to buffer
5. Treesitter highlights syntax
```

**Adding a Server:**

```lua
-- lsp.lua - servers table
servers = {
  rust_analyzer = {
    settings = {
      ["rust-analyzer"] = { ... }
    }
  },
}

-- lsp.lua - ensure_installed
ensure_installed = {
  'rust-analyzer',
}
```

### 4. Completion System (completions.lua)

**Chain:**
```
User types → nvim-cmp triggers
  ↓
nvim-cmp sources:
  - LSP (from LSP server)
  - LuaSnip (snippets)
  - Path (file paths)
  - Signature help
  ↓
Shows menu with options
  ↓
User confirms with Tab
  ↓
LuaSnip expands snippet if needed
  ↓
Autopairs adds closing brackets
```

### 5. Search System (search.lua)

**Telescope keybindings:**
- File finding: `<leader>ff`
- Grepping: `<leader>fg`
- Git: `<leader>sg*`
- Help: `<leader>sh*`

All search results feed to Quickfix, which uses BQF.

### 6. Formatting System (formatting.lua)

**Flow:**
```
Buffer writes (BufWritePre event)
  ↓
Conform.nvim triggered
  ↓
Selects formatter based on filetype:
  lua → stylua
  go → goimports + gofumpt
  python → black + isort
  js → prettier
  ↓
Formats code (async)
  ↓
Save completes
```

Can disable for specific filetypes in `disable_filetypes`.

### 7. Git Integration (theme.lua + search.lua)

**Gitsigns (Inline):**
```
File opens in buffer
  ↓
Gitsigns checks git changes
  ↓
Shows + ~ - in left gutter
  ↓
User uses ]h/[h to navigate hunks
  ↓
User can stage/reset with <leader>g*
```

**Telescope Git:**
```
User presses <leader>sgb (git branches)
  ↓
Telescope lists git branches
  ↓
User selects one
  ↓
Branch is checked out
```

## Configuration Flow

### Startup Process

```
1. nvim starts
2. init.lua loaded
3. Settings applied (vim.opt)
4. Keybindings registered
5. Lazy.nvim initialized
6. Plugin specs loaded from lua/
7. Plugins with event='VimEnter' loaded
8. Dashboard appears
9. User opens file
10. LSP attaches (if supported file type)
11. Completion ready
12. Formatting auto-runs on save
```

### LSP Attachment

```
1. User opens file.go
2. Filetype detected as 'go'
3. Neovim looks for go LSP (gopls configured)
4. gopls starts via Mason
5. LspAttach autocmd fires
6. Keybindings bound to buffer:
   - gd (go to def)
   - <leader>cr (rename)
   - etc
7. Diagnostics enabled
8. Completion ready
```

### File Save Flow

```
1. User saves with <C-s>
2. BufWritePre event fires
3. Conform checks filetype
4. Selects appropriate formatter
5. Runs formatter (async)
6. File formatted in-place
7. LSP sees changes
8. Gitsigns updates git status
9. Save completes
```

## Extending the Config

### Adding a New Plugin

**Step 1: Create lua file**

```lua
-- nvim/lua/myplugin.lua
return {
  'author/myplugin',
  event = 'VimEnter',           -- When to load
  opts = {
    setting1 = true,
    setting2 = false,
  },
  config = function(_, opts)
    require('myplugin').setup(opts)
  end,
}
```

**Step 2: Add to init.lua**

```lua
require('lazy').setup {
  -- ... existing plugins ...
  require 'myplugin',  -- Add this line
  -- ...
}
```

**Step 3: Reload**

```
:Lazy sync
```

### Adding an LSP Server

**Step 1: Edit lua/lsp.lua**

```lua
-- In servers table
local servers = {
  my_language_server = {
    settings = {
      MyLanguage = {
        -- settings here
      }
    }
  },
}

-- In ensure_installed
local ensure_installed = {
  'my-language-server',  -- Note: different naming!
}
```

**Step 2: Install via Mason**

```
:Mason
```

Select the server and press `i` to install.

### Adding a Formatter

**Edit lua/formatting.lua**

```lua
formatters_by_ft = {
  my_language = { 'my-formatter' },
}
```

Install formatter via `:Mason`, then add to `ensure_installed` in `lua/lsp.lua`.

### Adding a Custom Keymap

**Edit init.lua or relevant lua/*.lua file**

```lua
-- In init.lua after existing keymaps
vim.keymap.set('n', '<leader>m', function()
  print('My custom command!')
end, { desc = 'My Custom Command' })
```

It will auto-appear in which-key!

### Customizing Color Scheme

**Edit lua/theme.lua**

```lua
-- Replace this line:
vim.cmd.colorscheme 'gruvbox-material'

-- With your theme:
vim.cmd.colorscheme 'catppuccin'  -- or 'nord', 'dracula', etc.
```

### Modifying Keybindings

**Find the keymap:**

```bash
grep -r "<leader>xx" nvim/lua/
```

**Edit it:**

```lua
-- Change from:
vim.keymap.set('n', '<leader>xx', builtin.function, { desc = 'Desc' })

-- To:
vim.keymap.set('n', '<leader>yy', builtin.function, { desc = 'Desc' })
```

**Reload:**

```
<leader>r
```

## Performance Optimization

### Startup Time Analysis

```bash
nvim --startuptime /tmp/startup.log +q
cat /tmp/startup.log
```

Look for plugins > 50ms.

### Lazy Loading Strategies

```lua
-- Load on specific event
event = 'VimEnter'
event = 'BufReadPre'
event = 'InsertEnter'

-- Load on specific command
cmd = 'MyCommand'
cmd = { 'Cmd1', 'Cmd2' }

-- Load on keymap
keys = { '<leader>f' }
keys = {
  { '<leader>a', function() ... end }
}

-- Load when needed as dependency
dependencies = { 'other-plugin' }
```

### Recommended Settings for Teams

```lua
-- In init.lua
vim.opt.updatetime = 250        -- LSP/git update speed
vim.opt.timeoutlen = 300        -- Keymap timeout
vim.opt.confirm = true          -- Confirm unsaved changes
vim.opt.autoread = true         -- Reload changed files
```

## Troubleshooting Architecture Issues

### Plugin not loading

**Check:**
1. Is it in init.lua require? `require 'pluginname'`
2. Is lua/pluginname.lua correct?
3. Run: `:Lazy show pluginname`
4. Run: `:Lazy profile`

### LSP not starting

**Check:**
1. `:Mason` - Is server installed?
2. `:LspInfo` - What servers are attached?
3. `:checkhealth` - Any errors?
4. File type supported? Check lua/lsp.lua

### Keybinding conflicts

**Find conflict:**
```bash
grep -r "<leader>xx" nvim/lua/ nvim/init.lua
```

**Resolve:**
- Change one binding
- Or disable plugin that provides it
- Check which-key: `<leader>xx` shows what's mapped

### Slow formatting

**Check:**
```
:ConformInfo
```

**Optimize:**
- Increase timeout: `timeout_ms = 5000`
- Disable for large files: Add to disable_filetypes
- Use async: `async = true`

## File-to-Feature Map

| Feature | File(s) | Key Plugins |
|---------|---------|------------|
| LSP / Completion | lsp.lua, completions.lua | nvim-lspconfig, Mason, nvim-cmp |
| Search / Find | search.lua | Telescope, fzf |
| Formatting | formatting.lua | Conform |
| Git | theme.lua, search.lua | gitsigns, Telescope |
| UI / Theme | theme.lua, statusline.lua, tabs.lua | gruvbox-material, lualine, bufferline |
| Navigation | flash.lua, filetree.lua | flash.nvim, neo-tree |
| Diagnostics | trouble.lua | trouble.nvim, BQF |
| Utilities | minis.lua, indents.lua, markdown.lua | mini.nvim, indent-blankline |
| AI | ai-claude.lua | claude-code.nvim |

---

**Questions?** Check the specific lua/*.lua file and read comments - everything is documented in-code!
