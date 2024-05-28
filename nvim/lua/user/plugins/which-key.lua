return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 500

		local wk = require("which-key")
		wk.register({
			c = { name = "Code" },
			e = { name = "Explorer" },
			f = { name = "Find" },
			n = { name = "Notes" },
			g = {
				name = "Git",
				h = { name = "hunk" },
			},
			l = { name = "LSP" },
			s = { name = "Splits" },
			t = { name = "Tabs" },
			w = { name = "Workspace" },
			x = { name = "Trouble" },
		}, { prefix = "<leader>" })
	end,
	opts = {},
}
