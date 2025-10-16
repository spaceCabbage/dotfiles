# Complete Keybindings Reference

Comprehensive guide to all keybindings in this Neovim configuration. Use this as your quick reference.

**Quick Tip:** Press `<leader>` (spacebar) and wait - which-key shows all available keybindings!

## Navigation & Movement

### Basic Movement

| Key | Action | Mode |
|-----|--------|------|
| `h` / `l` | Move left / right | Normal |
| `j` / `k` | Move down / up | Normal |
| `w` | Move word forward | Normal |
| `b` | Move word backward | Normal |
| `^` | Move to line start | Normal |
| `$` | Move to line end | Normal |
| `gg` | Go to file start | Normal |
| `G` | Go to file end | Normal |
| `C-d` | Scroll down (centered) | Normal |
| `C-u` | Scroll up (centered) | Normal |

### Window Navigation

| Key | Action | Mode |
|-----|--------|------|
| `C-h` | Focus left window | Normal |
| `C-l` | Focus right window | Normal |
| `C-j` | Focus lower window | Normal |
| `C-k` | Focus upper window | Normal |

### Smart Navigation - Flash

| Key | Action | Mode |
|-----|--------|------|
| `<leader>sf` | Flash jump to visible text | Normal/Visual/Operator |
| `<leader>sF` | Flash treesitter (code blocks) | Normal/Visual/Operator |
| `<leader>sr` | Remote flash (operator) | Operator |
| `<leader>sR` | Treesitter search (operator) | Operator |

**Example:** Press `<leader>sf`, see letters label visible text, press letter to jump.

### LSP Navigation

| Key | Action | Mode |
|-----|--------|------|
| `gd` | Go to definition | Normal |
| `gD` | Go to declaration | Normal |
| `gr` | Find references | Normal |
| `gI` | Find implementations | Normal |
| `<leader>cd` | Go to definition (Telescope) | Normal |
| `<leader>cD` | Go to declaration | Normal |
| `<leader>ci` | Find implementations | Normal |
| `<leader>ct` | Go to type definition | Normal |
| `<leader>cR` | Find references | Normal |
| `<leader>cs` | Document symbols | Normal |
| `<leader>cS` | Workspace symbols | Normal |

### Diagnostics Navigation

| Key | Action | Mode |
|-----|--------|------|
| `]d` | Next diagnostic | Normal |
| `[d` | Previous diagnostic | Normal |
| `<leader>d` | Show diagnostic under cursor | Normal |
| `<leader>q` | Open diagnostic quickfix list | Normal |

### Hunk Navigation (Git)

| Key | Action | Mode |
|-----|--------|------|
| `]h` | Next git hunk | Normal |
| `[h` | Previous git hunk | Normal |

---

## File & Search

### File/Buffer Navigation

| Key | Action | Mode |
|-----|--------|------|
| `<leader>ff` | Find files | Normal |
| `<leader>fr` | Recent files | Normal |
| `<leader>fn` | Find in Neovim config | Normal |
| `<leader><leader>` | Quick find files | Normal |
| `<leader>fb` | Find open buffers | Normal |
| `<leader>/` | Fuzzy find in current buffer | Normal |

### Grepping & Search

| Key | Action | Mode |
|-----|--------|------|
| `<leader>fg` | Grep in files (live) | Normal |
| `<leader>fw` | Find word under cursor | Normal |
| `<leader>fo` | Find in open files | Normal |
| `<leader>sr` | Resume last search | Normal |
| `<leader>st` | Select Telescope | Normal |

### Help & Documentation

| Key | Action | Mode |
|-----|--------|------|
| `<leader>shh` | Search help tags | Normal |
| `<leader>shk` | Search keymaps | Normal |
| `<leader>shm` | Search man pages | Normal |
| `<leader>shr` | Search registers | Normal |
| `<leader>sk` | Quick search keymaps | Normal |

### Quickfix & Location Lists

| Key | Action | Mode |
|-----|--------|------|
| `<leader>qo` | Open quickfix list | Normal |
| `<leader>qc` | Close quickfix list | Normal |
| `]q` | Next quickfix item | Normal |
| `[q` | Previous quickfix item | Normal |
| `<leader>lo` | Open location list | Normal |
| `<leader>lc` | Close location list | Normal |
| `<leader>sq` | Quickfix via Telescope | Normal |
| `<leader>sl` | Location list via Telescope | Normal |

---

## Code Editing

### Code Actions & Refactoring

| Key | Action | Mode |
|-----|--------|------|
| `<leader>cr` | Rename symbol | Normal |
| `<leader>ca` | Code actions | Normal/Visual |
| `<leader>cf` | Format buffer | Normal/Visual |
| `<leader>th` | Toggle inlay hints | Normal |
| `K` | Hover documentation | Normal |
| `<leader>k` | Signature help | Normal |

### Completion

| Key | Action | Mode |
|-----|--------|------|
| `<C-Space>` | Complete | Insert |
| `<C-n>` | Next completion | Insert |
| `<C-p>` | Previous completion | Insert |
| `<Tab>` | Confirm completion | Insert |
| `<C-b>` | Scroll docs up | Insert |
| `<C-f>` | Scroll docs down | Insert |
| `<C-j>` | Snippet jump forward | Insert/Select |
| `<C-k>` | Snippet jump backward | Insert/Select |

### Commenting

| Key | Action | Mode |
|-----|--------|------|
| `gcc` | Toggle comment line | Normal |
| `gc` | Toggle comment (visual) | Visual |

### Text Manipulation

| Key | Action | Mode |
|-----|--------|------|
| `<leader>p` | Paste without yanking | Visual |
| `J` | Join lines (keep cursor) | Normal |
| `<A-j>` | Move line down | Normal |
| `<A-k>` | Move line up | Normal |
| `<A-j>` | Move selection down | Visual |
| `<A-k>` | Move selection up | Visual |
| `<` | Indent left (keep selection) | Visual |
| `>` | Indent right (keep selection) | Visual |

### Search Navigation

| Key | Action | Mode |
|-----|--------|------|
| `n` | Next search result (centered) | Normal |
| `N` | Previous search result (centered) | Normal |
| `<Esc>` | Clear search highlight | Normal |

---

## Buffer & Window Management

### Buffer Operations

| Key | Action | Mode |
|-----|--------|------|
| `<leader>ba` | Close all buffers | Normal |
| `<leader>bo` | Close other buffers | Normal |
| `<leader>bh` | Close buffers to left | Normal |
| `<leader>bl` | Close buffers to right | Normal |
| `<leader>bc` | Close current buffer | Normal |
| `<leader>bC` | Pick buffer to close | Normal |
| `<leader>bn` | Next buffer | Normal |
| `<leader>bp` | Previous buffer | Normal |
| `[b` | Previous buffer | Normal |
| `]b` | Next buffer | Normal |
| `<leader>bP` | Pick buffer | Normal |

### Window Operations

| Key | Action | Mode |
|-----|--------|------|
| `<leader>wv` | Split window vertically | Normal |
| `<leader>wh` | Split window horizontally | Normal |
| `<leader>we` | Make windows equal size | Normal |
| `<leader>wc` | Close current window | Normal |
| `<leader>wo` | Close other windows | Normal |
| `<leader>x` | Close buffer & window | Normal |

---

## Diagnostics & Debugging

### Trouble Diagnostics

| Key | Action | Mode |
|-----|--------|------|
| `<leader>xx` | Toggle all diagnostics | Normal |
| `<leader>xw` | Current buffer diagnostics | Normal |
| `<leader>xE` | Errors only | Normal |
| `<leader>xW` | Warnings only | Normal |
| `<leader>xs` | Document symbols | Normal |
| `<leader>xl` | LSP references | Normal |
| `<leader>xq` | Quickfix (Trouble) | Normal |
| `<leader>xL` | Location list (Trouble) | Normal |

**In Trouble panel:**
- `j`/`k` - Navigate
- `Enter` - Jump to error
- `Tab` - Expand/collapse
- `q` - Close

---

## Git Integration

### Gitsigns (Inline Git)

| Key | Action | Mode |
|-----|--------|------|
| `]h` | Next git hunk | Normal |
| `[h` | Previous git hunk | Normal |
| `<leader>gs` | Stage hunk | Normal/Visual |
| `<leader>gr` | Reset hunk | Normal/Visual |
| `<leader>gS` | Stage buffer | Normal |
| `<leader>gu` | Undo stage hunk | Normal |
| `<leader>gR` | Reset buffer | Normal |
| `<leader>gp` | Preview hunk | Normal |
| `<leader>gb` | Git blame line | Normal |
| `<leader>gB` | Toggle blame (whole file) | Normal |
| `<leader>gd` | Diff file | Normal |
| `<leader>gD` | Diff file (vs previous) | Normal |

### Telescope Git

| Key | Action | Mode |
|-----|--------|------|
| `<leader>sgb` | Browse branches | Normal |
| `<leader>sgc` | Browse commits | Normal |
| `<leader>sgs` | Show git status | Normal |
| `<leader>sgt` | Show git stash | Normal |

---

## UI & Settings

### File Explorer

| Key | Action | Mode |
|-----|--------|------|
| `<leader>e` | Toggle file explorer | Normal |
| `\\` (in tree) | Close explorer | Normal |

**In Neo-tree:**
- `a` - Add new file
- `d` - Delete
- `r` - Rename
- `c` - Copy
- `x` - Cut
- `p` - Paste
- `Enter` - Open file
- `R` - Refresh
- `<` - Navigate parent

### UI Toggles

| Key | Action | Mode |
|-----|--------|------|
| `<leader>tn` | Toggle line numbers | Normal |
| `<leader>tr` | Toggle relative numbers | Normal |
| `<leader>tw` | Toggle line wrap | Normal |
| `<leader>ts` | Toggle spell check | Normal |
| `<leader>tc` | Toggle color column | Normal |

### Terminal

| Key | Action | Mode |
|-----|--------|------|
| `<leader>tt` | Toggle terminal (horizontal) | Normal |
| `<leader>tv` | Toggle terminal (vertical) | Normal |
| `<leader>tf` | Toggle terminal (floating) | Normal |
| `<Esc><Esc>` | Exit terminal mode | Terminal |

### Sessions

| Key | Action | Mode |
|-----|--------|------|
| `<leader>ss` | Save session | Normal |
| `<leader>sR` | Restore session | Normal |
| `<leader>sl` | List sessions | Normal |
| `<leader>sD` | Delete session | Normal |
| `<leader>sx` | Stop auto-session | Normal |

### Command Palette

| Key | Action | Mode |
|-----|--------|------|
| `<leader>p` | Open command palette | Normal |

---

## Special

### Config Management

| Key | Action | Mode |
|-----|--------|------|
| `<leader>r` | Reload config | Normal |
| `<leader>fn` | Find in Neovim config | Normal |

### Saving & Exiting

| Key | Action | Mode |
|-----|--------|------|
| `<C-s>` | Save file | Normal/Insert |
| `:q` | Quit | Normal |
| `:q!` | Quit without saving | Normal |
| `:wq` | Save and quit | Normal |
| `:qa` | Quit all | Normal |

### Macro & Replay

| Key | Action | Mode |
|-----|--------|------|
| `q{char}` | Record macro in {char} | Normal |
| `@{char}` | Replay macro {char} | Normal |
| `Q` | Replay macro on selection | Visual |

---

## Quickfix (BQF) Shortcuts

When quickfix window is open:

| Key | Action |
|-----|--------|
| `zf` | Filter results |
| `z` | Toggle select all |
| `K`/`J` | Preview up/down |
| `j`/`k` | Navigate |
| `Enter` | Jump to result |
| `<C-s>` | Split and jump |
| `o` | Jump and close |
| `p` | Toggle preview |

---

## Which-Key Groups

Press these and which-key shows sub-menus:

| Key | Group | Contains |
|-----|-------|----------|
| `<leader>a` | AI Assistant | Claude Code |
| `<leader>b` | Buffers | Buffer operations |
| `<leader>c` | Code/LSP | All LSP operations |
| `<leader>e` | Explorer | File tree |
| `<leader>f` | Find/Files | File finding & searching |
| `<leader>g` | Git | Git operations |
| `<leader>l` | Location List | Location list |
| `<leader>p` | Command Palette | Commands |
| `<leader>q` | Quickfix | Quickfix operations |
| `<leader>r` | Reload | Reload config |
| `<leader>s` | Search | All search operations |
| `<leader>sd` | Search Diagnostics | Diagnostic search |
| `<leader>sf` | Search Flash | Flash navigation |
| `<leader>sg` | Search Git | Git search/browse |
| `<leader>sh` | Search Help | Help search |
| `<leader>t` | Toggle/Terminal | Toggles & terminal |
| `<leader>w` | Window | Window management |
| `<leader>x` | Diagnostics/Trouble | Trouble diagnostics |
| `g` | Go to | LSP navigation |
| `gc` | Comment | Commenting |

---

## Tips & Tricks

### Power User Combos

**Comment a function:**
```
5gcc  -- Comment 5 lines starting from current
```

**Stage and review git changes:**
```
]h           -- Jump to next change
<leader>gp   -- Preview what changed
<leader>gs   -- Stage it
]h           -- Jump to next
```

**Find and rename:**
```
<leader>cR      -- Find all references
<leader>xx      -- See in Trouble
<leader>cr      -- Rename (LSP does all at once!)
```

**Navigate search results:**
```
<leader>fg      -- Grep in files
zf              -- Filter results (in quickfix)
Enter           -- Jump to result
j/k             -- Next result
Enter           -- Jump
```

### Vim Modal Tips

**Visual mode:**
- `v` - Enter visual (character)
- `V` - Enter visual (line)
- `C-v` - Enter visual (block)

**Operator mode:**
- `d` + motion = delete
- `c` + motion = change
- `y` + motion = yank
- `<leader>sf` + motion = flash jump

Example: `d<leader>sf` then press letter to delete to that location!

---

## Default Vim Keybindings

These standard Vim keybindings still work:

| Key | Action |
|-----|--------|
| `/` | Search forward |
| `?` | Search backward |
| `:` | Command mode |
| `u` | Undo |
| `C-r` | Redo |
| `v` | Visual select |
| `V` | Visual line |
| `C-v` | Visual block |
| `d` | Delete |
| `c` | Change |
| `y` | Yank |
| `p` | Paste |
| `.` | Repeat last command |
| `~` | Toggle case |

---

## Cheat Sheet (Printable)

### Top 20 Most-Used

1. `<leader>ff` - Find files
2. `<leader>fg` - Grep in project
3. `gd` - Go to definition
4. `<leader>cr` - Rename symbol
5. `<leader>ca` - Code actions
6. `<leader>cf` - Format code
7. `]h` / `[h` - Navigate git changes
8. `<leader>gs` - Stage git hunk
9. `<leader>gb` - Git blame
10. `<leader>sf` - Flash jump
11. `<leader>xx` - Show diagnostics
12. `<leader>e` - Toggle file tree
13. `<leader>qo` - Open quickfix
14. `<leader>p` - Command palette
15. `gcc` - Comment line
16. `<C-h/j/k/l>` - Navigate windows
17. `<leader>r` - Reload config
18. `<leader>sgb` - Switch branch
19. `<leader>sgc` - Browse commits
20. `<leader>d` - Show error details

---

## Customizing Keybindings

To change a keybinding:

1. Edit `nvim/init.lua` or relevant `nvim/lua/*.lua` file
2. Find the `vim.keymap.set()` call
3. Change the key and/or function
4. Reload: `<leader>r`

Example:
```lua
-- Before
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find Files' })

-- After
vim.keymap.set('n', '<leader>f f', builtin.find_files, { desc = 'Find Files' })
```

---

**Quick Access:** Press `<leader>` and wait to see all keybindings in which-key! 🎯
