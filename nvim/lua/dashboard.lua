return {
  'goolord/alpha-nvim',
  event = 'VimEnter',
  dependencies = {
    'rubiin/fortune.nvim',
  },
  config = function()
    require('fortune').setup { content_type = 'tips', display_format = 'mixed' }

    local alpha = require 'alpha'
    local dashboard = require 'alpha.themes.dashboard'

    dashboard.section.header.val = {
      [[                                                                       ]],
      [[                                                                     ]],
      [[       ████ ██████           █████      ██                     ]],
      [[      ███████████             █████                             ]],
      [[      █████████ ███████████████████ ███   ███████████   ]],
      [[     █████████  ███    █████████████ █████ ██████████████   ]],
      [[    █████████ ██████████ █████████ █████ █████ ████ █████   ]],
      [[  ███████████ ███    ███ █████████ █████ █████ ████ █████  ]],
      [[ ██████  █████████████████████ ████ █████ █████ ████ ██████ ]],
      [[                                                                       ]],
    }

    dashboard.section.buttons.val = {
      dashboard.button('f', ' Find File', ':Telescope find_files<CR>'),
      dashboard.button('e', ' New File', ':ene <BAR> startinsert<CR>'),
      dashboard.button('r', ' Resume Session', ':SessionRestore<CR>'),
      dashboard.button('s', '󰺄 Search Sessions', ':SessionSearch<CR>'),
      dashboard.button('c', ' Claude Code', '<cmd>ClaudeCode<CR>'),
      dashboard.button('q', '󰈆 Quit', ':qa<CR>'),
    }

    dashboard.section.footer.val = function()
      local tip = require('fortune').get_fortune()
      return tip or 'Have a productive day!'
    end
    dashboard.section.footer.opts.hl = 'Comment'

    local header_lines = #dashboard.section.header.val
    local button_lines = #dashboard.section.buttons.val
    local footer_lines = 1 -- Assuming get_fortune returns a single-line tip.
    local total_lines = header_lines + button_lines + footer_lines + 6 -- additional space between sections
    local margin_top = math.max(math.floor((vim.o.lines - total_lines) / 2), 0)

    dashboard.opts.layout = {
      { type = 'padding', val = margin_top },
      dashboard.section.header,
      { type = 'padding', val = 2 },
      dashboard.section.buttons,
      { type = 'padding', val = 2 },
      dashboard.section.footer,
    }

    alpha.setup(dashboard.opts)
  end,
}
