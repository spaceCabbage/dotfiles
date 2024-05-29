return {
	"akinsho/bufferline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	version = "*",
	opts = {
		options = {
			mode = "tabs",
			separator_style = "thin",
			indicator = "underline",
			always_show_bufferline = false,

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
