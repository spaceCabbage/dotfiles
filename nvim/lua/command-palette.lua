local M = {}

-- Gather all available commands, keymaps, and plugin commands
local function gather_all_commands()
  local commands = {}

  -- 1. Get all user-defined keymaps with descriptions
  local keymaps = vim.api.nvim_get_keymap 'n'
  for _, keymap in ipairs(keymaps) do
    if keymap.desc and keymap.desc ~= '' then
      table.insert(commands, {
        name = keymap.desc,
        action = keymap.lhs,
        keybind = keymap.lhs,
        source = 'keymap',
        description = keymap.desc,
      })
    end
  end

  -- 2. Get all available commands using completion
  local all_cmds = vim.fn.getcompletion('', 'command')
  for _, name in ipairs(all_cmds) do
    -- Skip if we already have this from keymaps
    local already_exists = false
    for _, cmd in ipairs(commands) do
      if cmd.name == name then
        already_exists = true
        break
      end
    end

    if not already_exists then
      table.insert(commands, {
        name = name,
        action = ':' .. name,
        keybind = '',
        source = 'command',
        description = '',
      })
    end
  end

  -- 3. Add custom high-priority commands with better descriptions
  local custom_commands = {
    -- File Operations
    { name = 'Save All Files', action = ':wa', keybind = '', description = 'Write all modified buffers', icon = '' },
    { name = 'Quit All', action = ':qa', keybind = '', description = 'Quit all windows and buffers', icon = '' },
    { name = 'Force Quit', action = ':qa!', keybind = '', description = 'Force quit without saving', icon = '' },
    { name = 'Reload Config', action = ':source $MYVIMRC', keybind = '', description = 'Source nvim config', icon = '' },

    -- LSP Actions
    { name = 'Format Document', action = vim.lsp.buf.format, keybind = '', description = 'Format current buffer with LSP', icon = '' },
    { name = 'Rename Symbol', action = vim.lsp.buf.rename, keybind = '<leader>cr', description = 'Rename symbol under cursor', icon = '' },
    { name = 'Code Action', action = vim.lsp.buf.code_action, keybind = '<leader>ca', description = 'Show available code actions', icon = '' },

    -- Git
    { name = 'Git Status', action = ':!git status', keybind = '', description = 'Show git status', icon = '' },
    { name = 'Git Diff', action = ':!git diff', keybind = '', description = 'Show git diff', icon = '' },

    -- Toggles
    {
      name = 'Toggle Line Numbers',
      action = function()
        vim.opt.number = not vim.opt.number:get()
      end,
      keybind = '<leader>tn',
      description = 'Toggle line numbers on/off',
      icon = '',
    },
    {
      name = 'Toggle Relative Numbers',
      action = function()
        vim.opt.relativenumber = not vim.opt.relativenumber:get()
      end,
      keybind = '<leader>tr',
      description = 'Toggle relative line numbers',
      icon = '',
    },
    {
      name = 'Toggle Colorcolumn',
      action = function()
        if vim.wo.colorcolumn == '' then
          vim.wo.colorcolumn = '80'
        else
          vim.wo.colorcolumn = ''
        end
      end,
      keybind = '<leader>tc',
      description = 'Toggle colorcolumn at 80 chars',
      icon = '',
    },
  }

  -- Add custom commands at the beginning
  for _, cmd in ipairs(custom_commands) do
    table.insert(commands, 1, {
      name = (cmd.icon or '') .. ' ' .. cmd.name,
      action = cmd.action,
      keybind = cmd.keybind,
      source = 'custom',
      description = cmd.description,
    })
  end

  return commands
end

-- Show the command palette using Telescope
function M.show()
  local pickers = require 'telescope.pickers'
  local finders = require 'telescope.finders'
  local conf = require('telescope.config').values
  local actions = require 'telescope.actions'
  local action_state = require 'telescope.actions.state'
  local entry_display = require 'telescope.pickers.entry_display'

  -- Create displayer for 3-column layout: Name | Keybind | Description
  local displayer = entry_display.create {
    separator = ' │ ',
    items = {
      { width = 40 }, -- Command name
      { width = 20 }, -- Keybind
      { remaining = true }, -- Description
    },
  }

  local function make_display(entry)
    return displayer {
      entry.value.name,
      { entry.value.keybind or '', 'TelescopeResultsIdentifier' },
      { entry.value.description or '', 'TelescopeResultsComment' },
    }
  end

  local all_commands = gather_all_commands()

  pickers
    .new({}, {
      prompt_title = ' Command Palette - ' .. #all_commands .. ' commands',
      finder = finders.new_table {
        results = all_commands,
        entry_maker = function(entry)
          return {
            value = entry,
            display = make_display,
            ordinal = entry.name .. ' ' .. (entry.keybind or '') .. ' ' .. (entry.description or ''),
          }
        end,
      },
      sorter = conf.generic_sorter {},
      previewer = false,
      layout_strategy = 'vertical',
      layout_config = {
        width = 0.95,
        height = 0.95,
      },
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          if selection then
            local action = selection.value.action

            -- Execute based on action type
            if type(action) == 'function' then
              -- Lua function
              vim.schedule(function()
                action()
              end)
            elseif type(action) == 'string' then
              if action:sub(1, 1) == ':' then
                -- Vim command
                vim.schedule(function()
                  vim.cmd(action:sub(2))
                end)
              else
                -- Keymap
                vim.schedule(function()
                  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(action, true, false, true), 'n', true)
                end)
              end
            end
          end
        end)
        return true
      end,
    })
    :find()
end

return M
