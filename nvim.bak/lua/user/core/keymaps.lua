vim.g.mapleader = " "
local km = vim.keymap

km.set("i", "kj", "<esc>", { desc = "Exit insert mode with kj" })
km.set("n", "<leader>fx", ":nohl<CR>", { desc = "Clear search highlights" })

-- incrementing nums
km.set("n", "<leader>+", "<C-a>", { desc = "Increment" })
km.set("n", "<leader>-", "<C-x>", { desc = "Decrement" })

-- window management
km.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
km.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
km.set("n", "<leader>se", "<C-w>=", { desc = "Make windows equal" })
km.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split " })

km.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "New tab" })
km.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
km.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
km.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
km.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })
