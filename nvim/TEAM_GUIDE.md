# Team Setup & Onboarding Guide

Complete instructions for onboarding your team onto this Neovim configuration.

## For Team Leads

### Pre-Onboarding Checklist

- [ ] Read this entire guide
- [ ] Test config yourself on clean machine
- [ ] Create team setup script (optional, template below)
- [ ] Add config to team dotfiles repo
- [ ] Commit `lazy-lock.json` (ensures everyone gets same plugins)
- [ ] Schedule onboarding session (30 minutes)
- [ ] Prepare team machines (optional automated setup)

### Sharing the Configuration

#### Option 1: Part of Dotfiles Repo (Recommended)

```bash
# In your dotfiles repo
.
├── nvim/               # ← This config
├── terminal/
├── .bashrc
└── setup.sh            # ← Add team setup script

# Team members
git clone <team-repo>
./setup.sh             # Runs everything
```

#### Option 2: Standalone

```bash
# Share just the nvim folder
git subtree add --prefix nvim <this-repo-url> main
```

#### Option 3: Copy (Simplest)

```bash
# Send nvim/ folder directly
cp -r nvim ~/.config/nvim
```

---

## For New Team Members

### Onboarding Steps (30 minutes)

#### 1. Install Prerequisites (5 min)

**macOS:**
```bash
brew install neovim node python3 ripgrep fzf
```

**Ubuntu/Debian:**
```bash
sudo apt-get update
sudo apt-get install neovim nodejs python3 ripgrep fzf
```

**Arch:**
```bash
sudo pacman -S neovim nodejs python ripgrep fzf
```

**Windows (WSL recommended):** Use Ubuntu steps above

#### 2. Set Up Configuration (5 min)

**From team dotfiles:**
```bash
git clone <team-dotfiles>
./setup.sh                    # Runs everything
# or manual:
ln -s $(pwd)/nvim ~/.config/nvim
```

**Or direct copy:**
```bash
cp -r nvim ~/.config/nvim
```

#### 3. First Launch (5-10 min, automatic!)

```bash
nvim
```

This automatically:
- Downloads all plugins (~2 min)
- Installs LSP servers (~5 min)
- Sets up formatters
- Ready to code!

#### 4. Verify Setup (5 min)

```
:checkhealth
```

Should show:
- ✅ nvim health
- ✅ Plugins loaded
- ✅ No critical errors

#### 5. Learn the Basics (5 min)

Inside Neovim:
```
<leader>      Press spacebar, see all commands
<leader>ff    Try finding a file
:help         Get help on anything
```

### First Day Tasks

**Morning:**
1. Open project: `nvim`
2. Learn 5 essential keybindings:
   - `<leader>ff` - Find files
   - `gd` - Go to definition
   - `<leader>cf` - Format code
   - `<leader>xx` - Show errors
   - `<leader>gs` - Git stage

**Afternoon:**
1. Try git workflow: `]h` → `<leader>gp` → `<leader>gs`
2. Try formatting: `<leader>cf` on a file
3. Try code navigation: `gd` on a symbol

**End of day:**
1. Bookmark [KEYBINDINGS.md](./KEYBINDINGS.md)
2. Know where to find help
3. Ask questions!

---

## For Team Technical Lead

### Setting Up Team Tools

#### Create Team Setup Script

**File: `dotfiles/setup-nvim.sh`**

```bash
#!/bin/bash
set -e

echo "🚀 Setting up Neovim configuration..."

# Check Neovim
if ! command -v nvim &> /dev/null; then
    echo "❌ Neovim not installed"
    echo "   macOS: brew install neovim"
    echo "   Linux: sudo apt-get install neovim"
    exit 1
fi

# Check git
if ! command -v git &> /dev/null; then
    echo "❌ Git not installed"
    exit 1
fi

echo "✅ Neovim $(nvim --version | head -1)"

# Create config directory
mkdir -p ~/.config

# Backup existing config
if [ -d ~/.config/nvim ] && [ ! -L ~/.config/nvim ]; then
    echo "⚠️  Backing up existing config to ~/.config/nvim.backup"
    mv ~/.config/nvim ~/.config/nvim.backup
fi

# Create symlink
ln -sf "$(pwd)/nvim" ~/.config/nvim
echo "✅ Config linked"

# Show next steps
echo ""
echo "✨ Setup complete! Next steps:"
echo "1. Run: nvim"
echo "2. Wait for plugins to install (2-5 minutes)"
echo "3. Read: nvim/INDEX.md"
echo ""
echo "📚 Quick references:"
echo "   • SETUP.md - Detailed installation"
echo "   • QUICKSTART.md - Common tasks"
echo "   • KEYBINDINGS.md - All keybindings"
echo "   • TROUBLESHOOTING.md - Problem solutions"
echo ""
```

Make it executable:
```bash
chmod +x setup-nvim.sh
```

#### CI/CD Integration (Optional)

**GitHub Actions example:**

```yaml
# .github/workflows/nvim-check.yml
name: Neovim Config Check

on: [push, pull_request]

jobs:
  check:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: neovim/nvim-appimage@master
      - run: nvim --version
      - run: mkdir -p ~/.config && ln -s $(pwd)/nvim ~/.config/nvim
      - run: nvim -u ~/.config/nvim/init.lua +checkhealth +q
```

### Managing Team Configuration

#### Lock File Discipline

Always commit `lazy-lock.json`:

```bash
# After updating plugins
:Lazy sync
git add nvim/lazy-lock.json
git commit -m "Update plugin lock file"
git push
```

This ensures **all team members get identical plugins**.

#### Version Control Best Practices

```bash
# Good - Reproducible
git add nvim/lazy-lock.json
git add nvim/init.lua
git add nvim/lua/

# Bad - Causes issues
# Don't add nvim/plugin/ folder
# Don't modify other team's keybindings without discussion
```

#### Handling Updates

```bash
# Lead updates plugins and commits
:Lazy sync
git add nvim/lazy-lock.json
git commit -m "Update plugins: fix X, add Y"
git push

# Team members just pull
git pull
# Plugins auto-update from lock file
```

### Team Communication

#### Share in Team Docs

Create team documentation:

```markdown
# Neovim Setup (Team Wiki)

## Quick Start
1. Run setup script: `./setup-nvim.sh`
2. Read [QUICKSTART.md](nvim/QUICKSTART.md)
3. Ask in #dev-tools

## Key Keybindings
- `<leader>ff` - Find files
- `gd` - Go to definition
- `<leader>cf` - Format code
- Press `<leader>` for full menu

## Resources
- [INDEX.md](nvim/INDEX.md) - Full documentation
- [TROUBLESHOOTING.md](nvim/TROUBLESHOOTING.md) - Problem solving
- [KEYBINDINGS.md](nvim/KEYBINDINGS.md) - Complete reference

## Common Issues
- "Plugins not loading" → Run `:Lazy sync`
- "LSP not working" → Run `:Mason` and install servers
- Still stuck? → [TROUBLESHOOTING.md](nvim/TROUBLESHOOTING.md)
```

#### Monthly Team Check-in

```markdown
# Monthly Neovim Maintenance

Every month:
1. **Update plugins**: :Lazy sync
2. **Check health**: :checkhealth
3. **Share improvements**: Team meeting

Questions? Post in #dev-tools!
```

---

## For Team Members - How to Get Help

### Help Hierarchy

**Level 1: Self-Help (2 minutes)**
```
1. Press <leader> in Neovim (see all commands)
2. Run :checkhealth (diagnose issues)
3. Run :Lazy sync (fix most issues)
```

**Level 2: Documentation (5 minutes)**
```
1. QUICKSTART.md - Common tasks
2. KEYBINDINGS.md - What each key does
3. TROUBLESHOOTING.md - Problem solutions
```

**Level 3: Ask the Team**
```
#dev-tools channel:
"I'm trying to [task], [error message]"
```

### Asking Good Questions

**Good:**
```
"I'm trying to rename a function but <leader>cr
isn't working. Error: 'LSP is not attached'.
How do I fix?"
```

**Bad:**
```
"It doesn't work"
```

### Getting Support

#### Self-diagnosis
```
In Neovim:
:checkhealth         See what's broken
:messages            See error messages
:Lazy show          Check plugins
:LspInfo            Check LSP
```

#### Share diagnostics
```bash
# When asking for help, share:
nvim --version
:checkhealth output
:messages output
:LspInfo output
```

---

## Onboarding Checklist for Teams

### Week 1: Setup
- [ ] All team members have Neovim installed
- [ ] Config linked/copied successfully
- [ ] `:checkhealth` passes for everyone
- [ ] Everyone can open a file

### Week 2: Basics
- [ ] All members know 5 essential keybindings
- [ ] Everyone used formatter: `<leader>cf`
- [ ] Everyone used git: `]h` + `<leader>gs`
- [ ] Everyone navigated code: `gd`

### Week 3: Workflows
- [ ] Git workflow standardized: `]h` → `<leader>gp` → `<leader>gs`
- [ ] Code quality: format on save works
- [ ] LSP errors visible to everyone
- [ ] Team comfortable asking for help

### Week 4+: Mastery
- [ ] Team shares custom keybindings
- [ ] Productivity improvements shared
- [ ] New members onboarded quickly
- [ ] Config updated with team feedback

---

## Custom Team Keybindings

### How to Share Custom Keybindings

**Add to `nvim/init.lua`:**

```lua
-- Team-specific keybindings
vim.keymap.set('n', '<leader>tt', function()
  print('Team time tracking command here!')
end, { desc = 'Team Command' })
```

**Document in team wiki:**
```
## Team Custom Keybindings

- `<leader>tt` - Team time tracking
- `<leader>jd` - Jump to deployment docs
```

### Avoiding Conflicts

Check before adding:
```bash
grep -r "<leader>XX" nvim/
```

If found, pick a different key or disable that plugin.

---

## Troubleshooting for Teams

### Common Team Setup Issues

#### Issue: Team member's setup fails

**Check:**
1. Do they have prerequisites? `node --version`, `git --version`
2. Did plugins finish installing? (May take 5-10 min)
3. Run: `:Lazy sync`

**If still broken:**
1. Back up: `mv ~/.config/nvim ~/.config/nvim.backup`
2. Fresh install: `cp -r nvim ~/.config/nvim`
3. Run: `nvim` (wait for install)

#### Issue: Different team members have different plugins

**Cause:** Didn't commit `lazy-lock.json`

**Fix:**
```bash
# Lead commits lock file
git add nvim/lazy-lock.json
git commit -m "Lock plugin versions"
git push

# Team pulls and updates
git pull
nvim    # Auto-updates to match
```

#### Issue: Someone customized config, broke it for team

**Prevention:**
1. **Communicate changes**: Post in team chat first
2. **Document changes**: Add comment in code
3. **Test**: Run `:checkhealth` before committing
4. **Review**: Have tech lead review changes

**Recovery:**
```bash
git log -p nvim/    # See what changed
git revert <commit> # Undo the change
```

---

## Team Configuration Standards

### Recommended Standards

```lua
-- In nvim/init.lua, document standards:

-- ✅ Team Code Style
vim.opt.expandtab = true       -- Spaces, not tabs
vim.opt.tabstop = 2            -- 2 spaces (adjust per team)
vim.opt.shiftwidth = 2         -- Indent 2 spaces

-- ✅ Format on Save
-- All team members have this enabled
-- Changes standardized across codebase

-- ✅ LSP Diagnostics
-- Errors shown inline
-- Team members fix as they code

-- ✅ Git Hunks
-- Team uses <leader>gs to stage carefully
-- Ensures clean commit history
```

### Documenting Standards

Add to team wiki:

```markdown
# Neovim Team Standards

## Code Style
- Spaces: 2 spaces per indent
- Format on save: ENABLED
- Formatter: Prettier for JS/TS, Black for Python

## Git Workflow
1. Review changes: `]h` + `<leader>gp`
2. Stage carefully: `<leader>gs` (per hunk)
3. Commit with message
4. Push

## LSP Standards
- All errors must be shown inline
- Fix as you code, not at end
- Never ignore linting issues

## Team Keybindings
- Don't override without team discussion
- Document custom keybindings in wiki
- Keep <leader>c* for code, <leader>g* for git

## Updating Config
1. Make changes on branch
2. Test: `:checkhealth` passes
3. Create PR for team review
4. Merge to main
5. Team pulls and syncs
```

---

## Scaling to Large Teams

### For 5-10 People
- Shared config works great
- Monthly sync meetings
- Shared #dev-tools channel

### For 10-50 People
- Create team "config owners" (2-3 people)
- Review all config changes
- Rotating "config update" responsibility
- Monthly documentation updates

### For 50+ People
- Dedicated devops/tools team manages config
- Annual "config audit" to remove unused plugins
- Formal change request process
- Staging environment for testing

---

## After Onboarding

### Support Resources

**For team members:**
- Bookmark: `nvim/INDEX.md`
- Know: #dev-tools channel
- Use: `:checkhealth` when stuck

**For tech lead:**
- Monitor: `git log nvim/` for changes
- Review: PRs to nvim config
- Update: documentation when adding features

### Continuous Improvement

**Monthly:**
- Ask team: What's annoying?
- Share: Productivity hacks
- Update: Documentation

**Quarterly:**
- `:Lazy update` and test
- Share: New LSP features
- Discuss: Config improvements

**Annually:**
- Review unused plugins
- Update LSP servers
- Refresh documentation

---

## Success Metrics

Your Neovim setup is successful when:

- ✅ 80% of team uses it daily
- ✅ New features adopted within 1 week
- ✅ Issues resolved in #dev-tools within 1 day
- ✅ Zero "I can't use Neovim" complaints
- ✅ Team suggests improvements

---

## Final Checklist

### Before Team Rollout
- [ ] Config tested on fresh machine
- [ ] All documentation complete
- [ ] Setup script tested
- [ ] Lock file committed
- [ ] Team lead trained
- [ ] Help channel ready

### Day 1 (Team Kickoff)
- [ ] Walkthrough with team
- [ ] Everyone runs setup script
- [ ] Verify `:checkhealth` passes
- [ ] Q&A session
- [ ] Document answers in wiki

### Week 1 Follow-up
- [ ] Check in with each person
- [ ] Fix any setup issues
- [ ] Share productivity tips
- [ ] Celebrate first commits!

---

## Questions?

**Still setting up?** → [SETUP.md](./SETUP.md)

**How do I...?** → [QUICKSTART.md](./QUICKSTART.md)

**It's broken** → [TROUBLESHOOTING.md](./TROUBLESHOOTING.md)

**Want details?** → [INDEX.md](./INDEX.md)

---

**Welcome to the team Neovim setup!** 🚀

Your team is now set up for productive, consistent development with professional-grade tools. Happy coding! 💪
