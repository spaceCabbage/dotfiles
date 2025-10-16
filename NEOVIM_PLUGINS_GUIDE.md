# Neovim Plugins Guide - Flash, BQF, Trouble & Git

A comprehensive guide to using the three powerful new plugins and git integration in your Neovim setup.

---

## Table of Contents

1. [Flash.nvim - Smart Navigation](#flashnvim---smart-navigation)
2. [NVim-BQF - Better Quickfix](#nvim-bqf---better-quickfix)
3. [Trouble.nvim - Modern Diagnostics](#troublenvim---modern-diagnostics)
4. [Git Integration - Complete Workflow](#git-integration---complete-workflow)
5. [Quick Reference](#quick-reference)

---

## Flash.nvim - Smart Navigation

Flash lets you jump to any visible text on screen with 2-3 keystrokes instead of using search. It's a game-changer for code navigation.

### Basic Usage

#### `<leader>sf` - Flash Search (jump anywhere)

Jump to any visible text in your buffer with letter labels.

```lua
-- Example file content:
function hello()
  print("world")
  local x = 10
end

-- Workflow:
-- 1. Press: <leader>sf
-- 2. You see letter labels appear:
--    function hello() {a}
--      print("world") {b}
--      local x = 10 {c}
--    end {d}
-- 3. Press 'c' to jump to 'local x = 10'
```

**Why it's better than `/search`:**
- Instant visual feedback
- No need to type/verify search terms
- Jump in 2-3 keystrokes vs. 5+ with search
- Works across entire visible screen

#### `<leader>sF` - Flash Treesitter (jump to code blocks)

Jump to code structures like functions, classes, if statements, blocks, etc. Much smarter than character-level jumping.

```go
// Example Go code:
func parseFile() {          // {a}
  data := readFile()        // {b}
  result := transform(data) // {c}
  return result
}
```

Press `<leader>sF` then `a` to jump to the function declaration. Perfect for:
- Jumping between functions
- Jumping to class definitions
- Large structural jumps

#### `<leader>sr` - Remote Flash (operator mode)

Use flash as an operator with other vim commands.

```
Example:
d<leader>sr -- Delete to a location found by flash
y<leader>sr -- Yank to a location found by flash
```

#### `<leader>sR` - Treesitter Search (operator mode)

Same as remote flash but for code structures.

### When to Use Each

| Situation | Command | Why |
|-----------|---------|-----|
| Jump within function | `<leader>sf` | Fast horizontal jumps |
| Jump between functions | `<leader>sF` | Respects code structure |
| Quick edits nearby | `<leader>sr` | Use with operators (d, y, c) |
| Finding methods in class | `<leader>sF` | Treesitter understands scope |

### Tips & Tricks

- Flash only shows labels for **visible text** on screen
- Labels are shown in order they appear (left to right, top to bottom)
- Works in visual and operator mode too
- Combine with operators: `d<leader>sf` to delete to position

---

## NVim-BQF - Better Quickfix

The quickfix list shows search results, LSP diagnostics, grep results, etc. BQF makes it actually **usable** with filtering, sorting, and preview.

### When You Get a Quickfix List

You automatically get a quickfix list from:
- `<leader>fg` - Live grep (search in files)
- `<leader>fw` - Find word under cursor
- `<leader>cR` - LSP go to references
- `:grep` or `:make` commands
- LSP go to definition when multiple matches

### Opening & Using Quickfix

#### `<leader>qo` - Open quickfix

```
Result:
| file.lua:10:5   | undefined variable x
| file.lua:15:2   | unused import
| src/main.go:42  | cannot use string as int
```

#### Navigation

| Key | Action |
|-----|--------|
| `j`/`k` or `<C-n>`/`<C-p>` | Next/previous result |
| `Enter` or `o` | Jump to that location |
| `<C-s>` | Split window and jump |

#### `zf` - Filter Results

Narrow down results by pattern or filename:

```
1. <leader>qo              (open quickfix with 20 results)
2. zf                      (enter filter mode)
3. Type: lua               (filter by filename)
4. Shows only: *.lua files
```

Filter by content:
```
zf
Type: undefined            (only lines with "undefined")
```

#### `z` - Toggle Select All

Select/deselect all items at once. Useful for bulk operations.

#### Preview Commands

| Key | Action |
|-----|--------|
| `K` | Preview previous result (without jumping) |
| `J` | Preview next result (without jumping) |
| `p` | Toggle preview window |

### Real Workflow Example

```bash
Scenario: You refactored a function and want to see all uses

1. <leader>cR              (find all references - opens quickfix)
2. <leader>qo              (open quickfix window if not visible)
3. zf                      (filter results)
   Type: test              (see only uses in test files)
4. j/k                     (navigate filtered results)
5. Enter                   (jump to result)
6. Edit the code
7. Tab                     (go to next result)
```

### Power Features

- `<C-s>` splits and jumps to result
- `p` toggles preview mode (see results without jumping)
- Multiple filters stack (filter by file AND content)
- Works with both quickfix and location lists

---

## Trouble.nvim - Modern Diagnostics

Trouble shows all LSP errors/warnings in your workspace organized in a beautiful tree view. No more digging through quickfix lists.

### Opening Trouble

#### `<leader>xx` - Toggle all diagnostics

Shows **every error/warning** in your entire workspace:

```
 file.lua
   ❌ undefined variable (10:5)
   ⚠️  unused import (15:2)
 src/main.go
   ❌ cannot use string as int (42:10)
   ⚠️  missing error check (45:3)
 app/index.js
   ❌ 'console' is not defined (12:1)
```

Perfect for:
- Getting overview of all problems
- Working through errors systematically
- New projects (see what's broken)

#### `<leader>xw` - Current buffer diagnostics

Only show errors in the file you're editing:

```
 current_file.lua
   ❌ undefined variable (10:5)
   ⚠️  unused import (15:2)
```

Good for:
- Focused work on one file
- Quick cleanup before commit

#### `<leader>xE` - Errors only

Filter to show only error-level issues (not warnings):

```
 file.lua
   ❌ undefined variable (10:5)
 src/main.go
   ❌ cannot use string as int (42:10)
```

Useful when warnings are too noisy.

#### `<leader>xW` - Warnings only

Show only warnings (useful when errors are resolved):

```
 file.lua
   ⚠️  unused import (15:2)
 app/index.js
   ⚠️  unused variable 'temp' (8:5)
```

#### `<leader>xs` - Document symbols

Show all functions/classes/variables in current file:

```
 file.lua
   📦 parseConfig()
   📦 validateData()
   📦 outputResult()
```

Like LSP outline or goto symbol.

#### `<leader>xl` - LSP references

Show all places where a symbol is used (like `<leader>cR` but in Trouble):

```
 main.lua:5 - parseConfig()
 utils.lua:12 - parseConfig()
 test.lua:20 - parseConfig()
```

### Using Trouble

Once open:

| Key | Action |
|-----|--------|
| `j`/`k` | Navigate up/down |
| `Enter` | Jump to that error |
| `Tab` | Expand/collapse groups |
| `q` | Close trouble panel |
| `o` | Jump and focus |
| `R` | Refresh diagnostics |

### Workflow: Systematic Error Fixing

```bash
1. <leader>xx              (open trouble - see all problems)
2. k/j                     (navigate to first error)
3. Enter                   (jump to that error in editor)
4. Fix the issue
5. <leader>xx              (trouble auto-updates!)
6. Problem disappears from list ✓
7. Move to next error
```

### Pro Tips

- Use `<leader>xw` when you want to focus on one file
- Use `<leader>xx` to get motivated (see how many you've fixed!)
- `<leader>xE` is great when starting (ignore warnings, fix errors first)
- Trouble updates in real-time as you fix issues

---

## Git Integration - Complete Workflow

Your setup has two powerful git tools: **gitsigns** (inline git info) and **Telescope git integration** (search git history).

### A. Gitsigns - Inline Git Info

#### Navigating Changes

**`]h` - Next git hunk (next modified section)**

Jump to the next thing you changed in this file:

```lua
function processData() {
  local x = getData()    -- NEW (press ]h to jump here)
  print(x)               -- MODIFIED (press ]h again)
  return x               -- MODIFIED (press ]h again)
}
```

Useful for:
- Reviewing what you changed before committing
- Making sure you didn't accidentally modify something
- Testing code changes systematically

**`[h` - Previous git hunk**

Jump backwards through your changes.

#### Staging Changes (like `git add`)

**`<leader>gs` - Stage this hunk**

Stage only this specific change (not the whole file):

```lua
function test() {
  local x = 1    -- Press <leader>gs - only this gets staged
  local y = 2    -- Press <leader>gs - now this gets staged
  return x + y   -- Not staged yet
}
```

Then commit - only staged hunks go in!

**Visual mode staging:**
```
1. v (enter visual mode)
2. Select lines you want
3. <leader>gs (only selected lines staged)
```

**`<leader>gr` - Reset/undo this hunk**

Throw away changes in this section:

```lua
local x = oldValue  -- <leader>gr - reverts to original
```

**Whole file:**
- `<leader>gS` - Stage entire buffer
- `<leader>gR` - Reset entire buffer

#### Viewing Changes

**`<leader>gp` - Preview this hunk**

Shows what changed in a floating window:

```diff
- old code here
+ new code here
```

Helpful for:
- Reviewing changes before staging
- Understanding what broke

**`<leader>gb` - Git blame**

See who last changed each line and when:

```
abc1234 (John 2 hours ago) function test() {
def5678 (Jane 1 day ago)   return data
abc1234 (John 2 hours ago) }
```

Great for:
- Understanding why code exists
- Finding who to ask about a feature

**`<leader>gB` - Toggle line blame**

Turn blame on/off for the entire file.

**`<leader>gd` - Diff this file**

Opens a side-by-side diff:
- Left: original version
- Right: your changes

Perfect for thorough review before commit.

### B. Telescope Git Integration - Search & Browse Git

#### `<leader>sgb` - Git Branches

Browse all branches and switch:

```
main               (current - highlighted)
feature/auth       (type 'auth' to filter)
feature/new-ui
hotfix/bug-123
```

Press Enter on any branch to checkout.

**Use cases:**
- Quick branch switching
- See all available branches
- Search for old branches

#### `<leader>sgc` - Git Commits

Browse entire git history:

```
abc1234 Add new feature (2 hours ago)
def5678 Fix bug (1 day ago)
ghi9012 Update docs (3 days ago)
```

Press Enter to see commit details/actions.

**Use cases:**
- Find when a feature was added
- Look at old commits for reference
- Cherry-pick commits

#### `<leader>sgs` - Git Status

See all modified/untracked files:

```
M  src/main.go          (modified)
M  lua/config.lua       (modified)
?? new-file.txt         (untracked)
```

Jump directly to any file.

**Use cases:**
- Quick overview of what changed
- Jump to a file you forgot about
- See untracked files

#### `<leader>sgt` - Git Stash

Manage stashed changes:

```
WIP on main: abc1234 Add feature
WIP on feature: def5678 Work in progress
```

Select to pop (restore) or apply stash.

**Use cases:**
- Stash work in progress
- Switch branches without committing
- Recover old stashed work

### Complete Git Workflow Example

**Scenario: You're working on a feature, want to commit**

```bash
1. ]h / [h                 (review your changes)
2. <leader>gp              (preview what you changed)
3. <leader>gs              (stage the good parts)
4. <leader>gs              (stage more hunks)
5. <leader>gr              (undo accidental changes)
6. <leader>gS              (stage the whole file)
7. (open terminal or use git plugin)
   git commit -m "Your message"
8. <leader>sgc             (browse commits to see yours!)
```

**Scenario: Need to switch to another branch**

```bash
1. <leader>sgb             (see all branches)
2. (type 'auth')           (filter to 'auth' branches)
3. (select feature/auth)   (checkout instantly)
```

**Scenario: You broke something, need to find when**

```bash
1. <leader>gb              (show blame)
2. Find the broken line - see who changed it and when
3. <leader>sgc             (search commits around that time)
4. Understand the history
```

**Scenario: You have uncommitted work, need to switch branches**

```bash
1. <leader>sgt             (open git stash)
2. (create stash with :terminal or git CLI)
3. <leader>sgb             (switch to other branch)
4. Work on other branch
5. <leader>sgb             (switch back)
6. <leader>sgt             (restore stash)
```

---

## Quick Reference

### Flash Keybindings

| Key | Action |
|-----|--------|
| `<leader>sf` | Flash jump (to any visible text) |
| `<leader>sF` | Flash treesitter (to code blocks) |
| `<leader>sr` | Remote flash (operator mode) |
| `<leader>sR` | Treesitter search (operator mode) |

### BQF Keybindings

| Key | Action |
|-----|--------|
| `<leader>qo` | Open quickfix |
| `<leader>qc` | Close quickfix |
| `zf` | Filter results |
| `z` | Toggle select all |
| `K`/`J` | Preview up/down |
| `j`/`k` | Navigate results |
| `Enter` | Jump to result |
| `<C-s>` | Split and jump |
| `p` | Toggle preview |

### Trouble Keybindings

| Key | Action |
|-----|--------|
| `<leader>xx` | All diagnostics |
| `<leader>xw` | Buffer diagnostics |
| `<leader>xE` | Errors only |
| `<leader>xW` | Warnings only |
| `<leader>xs` | Symbols |
| `<leader>xl` | References |
| `j`/`k` | Navigate |
| `Tab` | Expand/collapse |
| `Enter` | Jump to error |
| `q` | Close |

### Git (Gitsigns) Keybindings

| Key | Action |
|-----|--------|
| `]h` / `[h` | Next/previous hunk |
| `<leader>gs` | Stage hunk |
| `<leader>gr` | Reset hunk |
| `<leader>gS` | Stage buffer |
| `<leader>gR` | Reset buffer |
| `<leader>gp` | Preview hunk |
| `<leader>gb` | Blame line |
| `<leader>gB` | Toggle blame |
| `<leader>gd` | Diff file |

### Git (Telescope) Keybindings

| Key | Action |
|-----|--------|
| `<leader>sgb` | Branches |
| `<leader>sgc` | Commits |
| `<leader>sgs` | Status |
| `<leader>sgt` | Stash |

---

## Pro Tips & Tricks

### Flash Tips
- Use `<leader>sf` for quick edits in same function
- Use `<leader>sF` to jump between functions
- Combine with operators: `d<leader>sf` to delete to a location
- Works great with visual selection: `v<leader>sf$<leader>sf` to select between two locations

### BQF Tips
- Filter by filename: `zf` then type `*.lua`
- Filter by content: `zf` then type the error message
- Use `K`/`J` to preview without jumping
- `<C-s>` to preview in split window

### Trouble Tips
- Start with `<leader>xE` to see only errors
- Use `<leader>xw` for focused work on one file
- Leave it open while coding - it updates in real-time
- `<leader>xs` is great for understanding file structure

### Git Tips
- Use `]h` / `[h` to review changes before staging
- Stage hunks with `<leader>gs` for atomic commits
- Use `<leader>gb` to understand code history
- Use `<leader>sgb` for quick branch switching
- `<leader>gd` before committing for final review

---

## Troubleshooting

### Flash not working?
- Make sure you're in normal, visual, or operator mode
- Try `<leader>sf` explicitly (not just `s`)
- Check which-key shows the binding: `<leader>s` then wait

### BQF not showing filters?
- Open quickfix first: `<leader>qo`
- Press `zf` to enter filter mode
- Type your filter pattern

### Trouble not showing diagnostics?
- Open all diagnostics first: `<leader>xx`
- Some languages need LSP installed (check `:Mason`)
- Run `:LspInfo` to see which LSPs are active

### Git keybindings not working?
- Make sure you're in a git repository
- Try `<leader>sgb` to test git integration
- Check that gitsigns is loaded: `:checkhealth gitsigns`

---

## Getting Help

Press `<leader>` and wait - which-key shows all available keybindings organized by prefix!

```
<leader>s          -- Shows all search/flash/git keybindings
<leader>s + f      -- Shows all flash keybindings
<leader>x          -- Shows all trouble keybindings
<leader>q          -- Shows quickfix keybindings
```

Need the exact command? Type `:` and telescope will help you search vim commands.
