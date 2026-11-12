return {
  'echasnovski/mini.nvim',
  event = 'VeryLazy',
  config = function()
    -- Better Around/Inside textobjects (e.g. va), yinq, ci', daf)
    require('mini.ai').setup {
      n_lines = 500,
    }

    -- Fast surround actions using gs prefix (avoids conflict with s/S in vim/flash)
    require('mini.surround').setup {
      mappings = {
        add = 'gsa',            -- Add surrounding in Normal and Visual modes
        delete = 'gsd',         -- Delete surrounding
        find = 'gsf',           -- Find surrounding (to the right)
        find_left = 'gsF',      -- Find surrounding (to the left)
        highlight = 'gsh',      -- Highlight surrounding
        replace = 'gsr',        -- Replace surrounding
        update_n_lines = 'gsn', -- Update `n_lines`
      },
    }
  end,
}
