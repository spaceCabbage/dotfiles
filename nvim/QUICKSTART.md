# Neovim Quickstart Guide

Get productive in 5 minutes with essential commands and workflows.

## Opening a Project

```bash
# Open current directory
nvim

# Open specific file
nvim file.go

# Open with multiple files
nvim file1.lua file2.lua
```

## Essential Commands (First Day)

### Finding Files

```
<leader>ff    Find files in project
<leader>fg    Search text in all files (grep)
<leader>fr    Recent files
<leader>fn    Find in Neovim config
```

**Example workflow:**
1. Press `<leader>ff`
2. Type "main"
3. See matching files
4. Arrow keys to select
5. Enter to open

### Editing Code

```
gd            Go to definition
<leader>cr    Rename symbol (changes everywhere!)
<leader>ca    Quick fixes / code actions
<leader>cf    Format code (auto-format)
K             Show documentation (hover)
```

**Example: Rename a variable**
```
1. Position cursor on variable name
2. <leader>cr
3. Type new name
4. Enter
5. All instances renamed!
```

### Git Operations

```
]h            Jump to next git change
[h            Jump to previous git change
<leader>gs    Stage this change
<leader>gb    Show who made this line
```

**Example: Review and stage changes**
```
1. ]h                    Jump to first change
2. <leader>gp            Preview what changed
3. <leader>gs            Stage it
4. ]h                    Jump to next
5. Repeat...
```

### Navigating Around

```
<leader>sf    Jump anywhere (Flash)
<leader>e     Open file tree
<C-h/j/k/l>   Move between windows
gd            Go to definition
```

**Flash is a game-changer:**
```
1. <leader>sf
2. You see letters on all visible text
3. Press a letter to jump there
Much faster than searching!
```

## Second Hour Features

### LSP Features

```
<leader>cd    Find definition
<leader>cR    Find all references
<leader>cS    Workspace symbols (search functions)
<leader>ca    Code actions (fixes available)
```

### Searching & Replacing

```
<leader>fg         Find text in project
zf                 Filter results (in quickfix)
Enter              Jump to result

For replace, use :s command or plugins
```

### Formatting & Quality

```
<leader>cf         Format file (auto-runs on save)
<leader>xx         Show all errors/warnings
]d / [d            Next/previous error
```

**Real workflow:**
```
1. <leader>xx       See all errors in workspace
2. j/k              Navigate to an error
3. Enter            Jump to it
4. Fix the issue
5. <leader>xx       Errors update automatically!
```

## Common Tasks

### Open Multiple Files

```
:e file.lua         Edit file in current window
:split file.lua     Edit in horizontal split
:vsplit file.lua    Edit in vertical split
C-w C-w             Switch between windows
<leader>wc          Close window
```

### Compare Two Files

```
:diffthis            Start diff on current
:split other-file
:diffthis            Diff with this too
diffget / diffput    Merge changes
:diffoff             Exit diff mode
```

### Search and Replace

```
/pattern            Find pattern
:s/old/new/         Replace in line
:%s/old/new/g       Replace all in file
```

### Terminal

```
<leader>tt          Open terminal (horizontal)
<leader>tv          Open terminal (vertical)
C-Escape Escape     Exit terminal mode
```

### Sessions

```
<leader>ss          Save current session
<leader>sR          Restore previous session
<leader>sl          List all sessions
```

## Quick Reference - Top Commands

| Goal | Command |
|------|---------|
| Open file | `<leader>ff` |
| Search text | `<leader>fg` |
| Jump to line | `:20` + Enter |
| Go to definition | `gd` |
| Rename | `<leader>cr` |
| Format | `<leader>cf` |
| See errors | `<leader>xx` |
| Git status | `<leader>sgs` |
| Git blame | `<leader>gb` |
| Stage hunk | `<leader>gs` |
| Comment line | `gcc` |
| Jump anywhere | `<leader>sf` |
| Save | `<C-s>` |

## Keybinding Reminder

**Don't memorize!** Just press `<leader>` (spacebar) and wait.

Which-key shows all available commands grouped by prefix:

```
<leader>a     AI commands
<leader>b     Buffer operations
<leader>c     Code/LSP commands
<leader>f     Find/search commands
<leader>g     Git commands
<leader>x     Error/diagnostic commands
... and more
```

## Common Mistakes (Avoid!)

### ❌ Don't: Use `:q!` without saving
```
✅ Instead:
:w          Save first
:q          Then quit
:wq         Or save and quit together
```

### ❌ Don't: Stage all changes without reviewing
```
✅ Instead:
]h                  Jump to change
<leader>gp          Preview it
<leader>gs          Stage only if good
```

### ❌ Don't: Rename without checking references
```
✅ Instead:
<leader>cR          Find all references first
Check the list
Then <leader>cr to rename
```

### ❌ Don't: Search all files for a big project
```
✅ Instead:
Use <leader>fw      Find word under cursor
Or <leader>sg*      Git + telescope filters
```

## Getting Help

### Built-in Help

```
<leader>shh         Search help documentation
<leader>shk         Search keybindings
K                   Hover docs for symbol
```

### Diagnose Issues

```
:checkhealth        Check everything
:Lazy show plugin   Show plugin status
:LspInfo            Show LSP servers
:ConformInfo        Show formatters
```

### View Keybindings

```
<leader>           Show all commands (which-key)
<leader>sk         Search for keymap
:verbose map       Show all maps
```

## First Project Setup

1. **Open project directory**
   ```bash
   nvim
   ```

2. **Open a file**
   ```
   <leader>ff  type filename, Enter
   ```

3. **See errors**
   ```
   <leader>xx  to open diagnostics panel
   ```

4. **Fix code**
   ```
   <leader>cf  to format
   j/k         to navigate errors
   Enter       to jump to error
   ```

5. **Review and commit**
   ```
   ]h          navigate git changes
   <leader>gp  preview
   <leader>gs  stage
   ```

6. **Save session**
   ```
   <leader>ss  save for next time
   ```

7. **Next time**
   ```
   nvim        opens with saved session!
   <leader>sR  if you closed, restore
   ```

## Tips for Speed

### Shortcuts for Speed

```
<leader><leader>    Find files (same as <leader>ff)
<leader>/           Find in current file
<leader>p           Command palette (search for :commands)
.                   Repeat last command (native vim)
%                   Jump to matching bracket
*                   Find word under cursor
```

### Movement Speed

```
Flash (<leader>sf)      Jump anywhere visible
5j                      Move 5 lines down
{                       Jump to prev paragraph
}                       Jump to next paragraph
C-d / C-u              Scroll half page
```

### Editing Speed

```
<C-a>                   Increment number
<C-x>                   Decrement number
A                       Go to end of line, insert
I                       Go to start of line, insert
ciw                     Change inner word
dap                     Delete around paragraph
```

## Customizing for Your Team

### Change a Keybinding

In `nvim/init.lua` or relevant `nvim/lua/*.lua`:

```lua
-- Find the binding you want to change
-- Example: change <leader>ff to <leader>f
vim.keymap.set('n', '<leader>f', builtin.find_files, { desc = 'Find Files' })
```

Then reload:
```
<leader>r
```

### Add Team Requirement

Add to `nvim/lua/lsp.lua` ensure_installed:

```lua
'rust-analyzer',  -- Add Rust support
```

Then in Mason install it: `:Mason`

### Update Formatters

In `nvim/lua/formatting.lua`:

```lua
formatters_by_ft = {
  rust = { 'rustfmt' },  -- Add your language
}
```

## Performance Tips

### If Neovim Feels Slow

```
:Lazy profile          Show slowest plugins
<leader>r              Reload config (clears cache)
:checkhealth           Check for issues
```

### Large Files

Disable some features:
```lua
-- In init.lua
if vim.fn.getfsize(vim.fn.expand('%')) > 1000000 then
  vim.opt.syntax = 'off'  -- Disable syntax
end
```

## Next Steps

1. **Read [KEYBINDINGS.md](./KEYBINDINGS.md)** - Learn all keybindings
2. **Explore [NEOVIM_PLUGINS_GUIDE.md](./NEOVIM_PLUGINS_GUIDE.md)** - Master the plugins
3. **Check [ARCHITECTURE.md](./ARCHITECTURE.md)** - Understand how it works
4. **Reference [SETUP.md](./SETUP.md)** - Installation troubleshooting

## Vim Movement Basics (If New to Vim)

```
h j k l              Move left/down/up/right
w b                  Move by word
^ $                  Start/end of line
gg G                 Start/end of file
:20                  Go to line 20
/pattern             Find pattern
n N                  Next/prev search
u C-r                Undo/redo
```

## Common Patterns

### Edit Config and Reload

```
<leader>fn          Find neovim config files
(edit file)
<leader>r           Reload config
```

### Search for TODO

```
<leader>fg          Grep files
Type: TODO
See all TODOs highlighted!
```

### Find and Rename

```
<leader>cR          Find all references
(review list)
<leader>cr          Rename symbol
Type new name, Enter
(all updated!)
```

---

**You're ready!** Open a project and start coding. Remember: press `<leader>` when you forget what to do! 🚀
