return {
	"ellisonleao/gruvbox.nvim",
	priority = 1000,
	config = function()
		require("gruvbox").setup({
			transparent_mode = true,
			-- dim_inactive = true,
		})
		vim.cmd("colorscheme gruvbox")
	end,
}
