return {
  'mrjones2014/legendary.nvim',
  priority = 10000,
  lazy = false,
  dependencies = {
    'folke/which-key.nvim',
  },
  config = function()
    local ok, legendary = pcall(require, 'legendary')
    if not ok then
      vim.notify('Failed to load legendary.nvim', vim.log.levels.ERROR)
      return
    end

    -- Check if legendary has setup function
    if type(legendary.setup) ~= 'function' then
      vim.notify('legendary.setup is not a function', vim.log.levels.ERROR)
      return
    end

    legendary.setup {
      extensions = {
        lazy_nvim = true,
        which_key = {
          auto_register = true,
          do_binding = false,
        },
      },
      select_prompt = ' Command Palette',
      include_builtin = true,
      include_legendary_cmds = true,
    }

    -- Set up keymap after legendary is loaded
    vim.keymap.set('n', '<leader>p', '<cmd>Legendary<CR>', { desc = 'Command Palette' })
  end,
}
