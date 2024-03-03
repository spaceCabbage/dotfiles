return {
  { "ellisonleao/gruvbox.nvim},
  },

  {
    "LazyVim/lazyvim",
    opts = {
      colorscheme = "gruvbox",
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "python",
        "typescript",
        "yaml",
      },
    },
  },
}
