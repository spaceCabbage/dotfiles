vim.g.mapleader = " "
local builtin = require('telescope.builtin')

-- Whichkey Config
local mappings = {
  e = { "<cmd>Neotree<CR>", "Toggle Neotree" },

  f = {
      name = "+Find",
      f = {"<cmd>Telescope find_files<CR>", "Find Files"},
      g = {"<cmd>Telescope git_files<CR>", "Find Git Files"},
      b = {"<cmd>Telescope buffers<CR>", "Find Buffers"},
  },
  g = {
    name = "+Git",
  },

  n = {
      name = "+Notes",
      n = {"<cmd>Neorg workspace notes<CR>", "Open Neorg"},
      h = {"<cmd>h neorg<CR>", "Neorg help"},
  },

  c = {
    name = "+Code",
  },
  s = {
    name = "+Select",
    s = {name = "Start seletion"},
    i = {name = "Increment selection"},
    c = {name = "Select by scope"},
    d = {name = "Decrement selection"},
  }
}

-- Setup which-key
local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
  return
end

which_key.register(mappings, { prefix = "<leader>" })

