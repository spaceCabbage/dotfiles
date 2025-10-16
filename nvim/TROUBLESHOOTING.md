# Troubleshooting Guide

Solutions for common issues with this Neovim configuration.

## General Troubleshooting

### First Steps (Always Try These First!)

1. **Check health**
   ```
   :checkhealth
   ```
   Look for errors (marked with ✗)

2. **Sync plugins**
   ```
   :Lazy sync
   ```
   This reinstalls/updates all plugins

3. **Reload config**
   ```
   <leader>r
   ```
   Or manually: `:so %` or close and reopen Neovim

4. **Check error messages**
   ```
   :messages
   ```
   See any error messages from startup

---

## Installation & Setup Issues

### Issue: "nvim: command not found"

**Cause:** Neovim not installed

**Solution - macOS:**
```bash
brew install neovim
```

**Solution - Ubuntu/Debian:**
```bash
sudo apt-get update
sudo apt-get install neovim
```

**Solution - Arch:**
```bash
sudo pacman -S neovim
```

**Solution - Manual:**
Visit [neovim.io](https://neovim.io) for pre-built binaries

### Issue: Config not loading / blank screen

**Cause:** Plugins still installing on first run

**Solution:**
- Wait 2-3 minutes (first run is slow!)
- Watch for download progress
- Don't close Neovim during installation

**If still broken after 5 minutes:**
```
:Lazy sync
```

### Issue: "~/.config/nvim not found"

**Cause:** Config not properly linked/copied

**Solution:**
```bash
mkdir -p ~/.config
cp -r /path/to/nvim ~/.config/nvim

# Or symlink if using dotfiles
ln -s /path/to/dotfiles/nvim ~/.config/nvim
```

### Issue: Permissions error on first run

**Cause:** Write permissions issue

**Solution:**
```bash
# Check permissions
ls -la ~/.config/nvim

# Fix if needed
chmod -R u+w ~/.config/nvim
```

---

## Plugin Issues

### Issue: Plugins not installing

**Cause:** Lazy.nvim configuration issue

**Solutions:**

```
:Lazy sync              Force reinstall everything
:Lazy clean             Remove unused plugins
:Lazy health            Check Lazy status
```

**Check git:**
```bash
# Verify git is installed
git --version
```

### Issue: Some plugins not working

**Check if plugin loaded:**
```
:Lazy show plugin-name
```

Look for:
- Status: loaded/not loaded
- Reason if not loaded

**Force load:**
```
:Lazy load plugin-name
```

### Issue: Plugin gives errors on startup

**Diagnose:**
```
:messages
```

Look for error message mentioning the plugin.

**Solution:**
1. Find the plugin config (likely in `nvim/lua/`)
2. Check the error message
3. Fix the configuration
4. Reload: `<leader>r`

### Issue: Slow startup (>1 second)

**Check what's slow:**
```
:Lazy profile
```

**Typical causes:**
- Large plugin (like treesitter)
- Git operation in startup
- Mason installing servers

**Solutions:**
- Check plugin README for lazy-loading options
- Move plugin to lazy load: `event = 'VeryLazy'`
- Increase startup timeout

---

## LSP Issues

### Issue: LSP not working / "No LSP servers"

**Check what's installed:**
```
:Mason
```

Should show installed servers.

**If none installed:**
1. Open `:Mason`
2. Search for language server (e.g., "pyright" for Python)
3. Highlight it
4. Press `i` to install

**Check if attached to buffer:**
```
:LspInfo
```

Shows which servers are active for current file.

### Issue: Specific language has no LSP

**Example: Opening Go file, no LSP**

**Solution:**

1. Check available servers: `:Mason`
2. Install gopls: Search → highlight → `i`
3. Check LSP config: `nvim/lua/lsp.lua` has `gopls` in servers?
4. Add if missing:
   ```lua
   servers = {
     gopls = {},  -- Add this
   }
   ```
5. Reload: `<leader>r`

### Issue: LSP errors/warnings not showing

**Cause:** Diagnostics disabled or off

**Solution:**

```
:set diagnostics=true
```

Or check `nvim/lua/lsp.lua` diagnostics config.

**Manually trigger:**
```
<leader>d     Show error under cursor
<leader>xx    Show all errors
```

### Issue: Autocomplete not working

**Check completion enabled:**
```
:checkhealth
```

Look for "nvim_cmp" section.

**Try manual trigger:**
```
(in insert mode)
<C-Space>     Manually trigger completion
```

**If no suggestions:**
- LSP may not be attached (`:LspInfo`)
- Plugin may not be loaded (`:Lazy show nvim-cmp`)

### Issue: Rename broken / doesn't update all references

**Likely cause:** LSP doesn't support rename

**Check:**
```
:LspInfo
```

Check if server supports rename.

**Workaround:**
Use search & replace:
```
<leader>fg     Search all uses
:%s/old/new/g  Replace all
```

---

## Formatting Issues

### Issue: Code not formatting on save

**Check formatters:**
```
:ConformInfo
```

Shows formatters for current file type.

**If none available:**

1. Check `nvim/lua/formatting.lua`
2. Is your filetype listed?
3. Is formatter installed? `:Mason`
4. Add to ensure_installed in `lua/lsp.lua`

### Issue: Formatting takes too long

**Solutions:**

Edit `nvim/lua/formatting.lua`:

```lua
opts = {
  format_on_save = function(bufnr)
    return {
      timeout_ms = 5000,  -- Increase timeout
      lsp_format = 'fallback',
    }
  end,
}
```

**Or disable for large files:**

```lua
local file_size = vim.fn.getfsize(vim.fn.expand('%'))
if file_size > 1000000 then  -- 1MB
  return nil  -- Don't format
end
```

### Issue: Wrong formatter being used

**Check what's running:**
```
:ConformInfo
```

**Override for filetype:**

Edit `nvim/lua/formatting.lua`:

```lua
formatters_by_ft = {
  javascript = { 'prettier' },  -- Specify formatter
}
```

---

## Git Issues

### Issue: Gitsigns not showing

**Cause:** Not in a git repository

**Solution:**
```bash
git init
```

**Check gitsigns status:**
```
:checkhealth gitsigns
```

### Issue: Git blame shows wrong author

**Likely cause:** Git misconfiguration

**Fix:**
```bash
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
```

### Issue: Stage/reset hunks don't work

**Cause:** Git permissions or state

**Check:**
```bash
git status
```

**Try:**
```
<leader>gs     Stage hunk
<leader>gr     Reset hunk
```

**Manually stage:**
```bash
git add file.lua
```

### Issue: Can't switch branches (telescope git)

**Check:**
```bash
git branch -a
```

**Try:**
```
<leader>sgb    List branches
(select one)
Enter to checkout
```

**Manual:**
```bash
git checkout branch-name
```

---

## Search & Navigation Issues

### Issue: Find files returns no results

**Cause:** Ripgrep not installed or wrong directory

**Install ripgrep:**

```bash
brew install ripgrep        # macOS
sudo apt install ripgrep    # Linux
sudo pacman -S ripgrep      # Arch
```

**Verify:**
```bash
rg --version
```

### Issue: Flash navigation not working

**Cause:** Plugin not loaded

**Check:**
```
:Lazy show flash
```

**Try:**
```
<leader>sf    Explicitly press flash keymap
```

**If error:**
```
:messages
```

Check error output.

### Issue: Telescope slow or unresponsive

**Cause:** Large project or indexing

**Solutions:**

1. Add `.gitignore` entries for large directories
2. Use filters: `<leader>fw` instead of `<leader>fg`
3. Use ripgrep: `brew install ripgrep`

### Issue: Find in files searches wrong directory

**Solution:**

```
<leader>fg    Type search term
<C-c>         Cancel if needed
(uses cwd)
```

**Change working directory:**
```
:cd /path/to/directory
<leader>fg    Now searches there
```

---

## UI & Display Issues

### Issue: Icons/symbols showing as squares

**Cause:** Nerd font not installed or not set in terminal

**Solution:**

1. Install Nerd Font from [nerdfonts.com](https://www.nerdfonts.com)
2. Set as terminal font
3. Restart terminal
4. Restart Neovim

### Issue: Colors look wrong

**Cause:** Colorscheme not applied or terminal doesn't support colors

**Solution:**

```lua
-- In nvim/lua/theme.lua
vim.cmd.colorscheme 'gruvbox-material'

-- Or change to different theme
vim.cmd.colorscheme 'catppuccin'
```

Reload: `<leader>r`

### Issue: Terminal background color wrong

**Solution:**

In `nvim/lua/theme.lua`, add:

```lua
vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
```

### Issue: Line wrapping issues

**Toggle wrap:**
```
<leader>tw
```

**Settings in init.lua:**
```lua
vim.opt.wrap = false          -- Don't wrap by default
vim.opt.breakindent = true    -- Indent wrapped lines
```

### Issue: Line numbers not showing

**Toggle:**
```
<leader>tn
```

**Or in init.lua:**
```lua
vim.opt.number = true
```

---

## Keybinding Issues

### Issue: Keybinding not working

**Check if bound:**
```
<leader>shk    Search keybindings
(find your key)
```

**Or manually:**
```
:verbose map <leader>xx
```

Shows what's bound to that key.

**Check for conflicts:**
```bash
grep -r "<leader>xx" nvim/
```

Multiple definitions = conflict!

### Issue: Keybinding conflicts between plugins

**Find what's conflicting:**
```bash
grep -r "<leader>xx" nvim/lua/
```

**Solution:**
Change one in the lua file that defines it.

Reload: `<leader>r`

### Issue: Which-key menu not showing

**Cause:** Plugin not loaded

**Check:**
```
:Lazy show which-key
```

**Try manually:**
```
<leader>    Hold for which-key menu
```

**Enable explicitly:**
```
:WhichKey
```

---

## Performance Issues

### Issue: Neovim very slow

**Diagnose:**
```
:Lazy profile
```

Shows slowest plugins.

**Solutions:**

1. Check for slow plugins
2. Disable if not needed
3. Check virus scanner (common on Windows)

### Issue: Freezes when opening files

**Cause:** Large file or slow LSP

**Solution:**

1. Check file size
2. Try disabling syntax: `:set syntax=off`
3. Close LSP: `:LspStop`
4. Try in safe mode:
   ```bash
   nvim -u NONE file.lua
   ```

### Issue: Memory usage high

**Check:**
```
:Lazy show plugin
```

Look for memory-heavy plugins.

**Solutions:**

- Disable unused plugins
- Update all plugins: `:Lazy sync`
- Restart Neovim periodically

---

## Session/Workspace Issues

### Issue: Session not restoring

**Check:**
```
<leader>sl    List sessions
```

**Try:**
```
<leader>ss    Save session first
<leader>sR    Then restore
```

### Issue: Files always reopen from before

**This is auto-session feature (intended!)**

**To disable:**
```
<leader>sx    Stop auto-session
```

**Or temporarily:**
```
:e new-file.lua
```

Opens fresh file.

---

## Team/Collaboration Issues

### Issue: Different team members have different configs

**Solution:**

1. Commit `lazy-lock.json` to git
2. All team members pull it
3. Run `:Lazy sync`
4. Everyone has same plugins

```bash
git add nvim/lazy-lock.json
git commit -m "Update plugin lock"
```

### Issue: Team member's extensions not working

**Cause:** Dependencies not installed

**Solution:**

```bash
nvim
:Mason
# Install any missing servers/tools
```

Or run `:checkhealth` to identify missing dependencies.

### Issue: Custom keybinding not shared

**Solution:**

1. Add to shared config file
2. Document in README or comments
3. Commit and push
4. Team runs `<leader>r` to reload

---

## Getting More Help

### Check Official Docs

- [Neovim Docs](https://neovim.io/doc/user/)
- [LSPConfig GitHub](https://github.com/neovim/nvim-lspconfig)
- [Lazy.nvim GitHub](https://github.com/folke/lazy.nvim)

### Debug Commands

```
:checkhealth              Check everything
:Lazy show plugin         Check plugin status
:LspInfo                  Show LSP servers
:ConformInfo              Show formatters
:messages                 See all messages
:verbose set option       Check option source
```

### Create Minimal Reproduction

If reporting an issue:

```bash
# Test with minimal config
nvim -u minimal.lua file.lua
```

Where `minimal.lua` is a basic config with only the problematic plugin.

---

## Performance Monitoring

### Check Startup Time

```bash
nvim --startuptime /tmp/startup.log +q
cat /tmp/startup.log
```

Look for:
- Total time (should be <300ms)
- Plugins > 50ms (potential optimizations)

### Profile Plugins During Session

```
:Lazy profile
```

Shows plugins loaded and their load time.

---

## Last Resort

### Nuclear Option (Start Fresh)

```bash
# Backup current config
mv ~/.config/nvim ~/.config/nvim.backup

# Fresh install
cp -r /path/to/repo/nvim ~/.config/nvim

# Restart Neovim
nvim
```

### Verbose Output

For debugging, run:

```bash
nvim -V9mylog file.lua
cat mylog
```

Creates detailed log file.

---

## Still Having Issues?

1. Run `:checkhealth` - Start here!
2. Check [SETUP.md](./SETUP.md) - Installation issues
3. Check [ARCHITECTURE.md](./ARCHITECTURE.md) - How things work
4. Search GitHub issues for plugins
5. Ask in team Slack/Discord with `:messages` output

---

**Remember:** Most issues are plugin-related, not core config! The first step is always `:checkhealth` and `:Lazy sync`. 💪
