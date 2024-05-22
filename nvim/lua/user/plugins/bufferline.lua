return {
	"akinsho/bufferline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	version = "*",
	opts = {
		options = {
			mode = "tabs",
			separator_style = "thick",
			indicator = "underline",

			offsets = {
				{
					filetype = "NvimTree",
					text_align = "left",
					text = "Explorer",
				},
			},
		},
	},
}
