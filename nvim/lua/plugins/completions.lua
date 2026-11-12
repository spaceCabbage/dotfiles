return {
  {
    'saghen/blink.cmp',
    event = 'InsertEnter',
    version = '1.*',
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = 'default',
        ['<Tab>'] = { 'select_and_accept', 'snippet_forward', 'fallback' },
        ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
        ['<CR>'] = { 'accept', 'fallback' },
        ['<C-n>'] = { 'select_next', 'fallback' },
        ['<C-p>'] = { 'select_prev', 'fallback' },
        ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
        ['<C-Space>'] = { 'show', 'show_documentation', 'hide_documentation' },
      },
      appearance = {
        nerd_font_variant = 'mono',
      },
      completion = {
        accept = {
          auto_brackets = { enabled = true },
        },
        menu = {
          border = 'rounded',
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = { border = 'rounded' },
        },
      },
      signature = {
        enabled = true,
        window = { border = 'rounded' },
      },
      sources = {
        default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer' },
        providers = {
          lazydev = {
            name = 'LazyDev',
            module = 'lazydev.integrations.blink',
            score_offset = 100,
          },
        },
      },
      fuzzy = {
        implementation = 'prefer_rust_with_warning',
      },
    },
    opts_extend = { 'sources.default' },
  },
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {},
  },
}
