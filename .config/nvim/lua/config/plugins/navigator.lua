return {
  'numToStr/Navigator.nvim',
  config = function ()
	  require('Navigator').setup()

	  -- remap pane navigation
	  vim.keymap.set('n', '<C-j>', '<CMD>NavigatorDown<CR>', { desc = "Move to down pane" })
	  vim.keymap.set('n', '<C-k>', '<CMD>NavigatorUp<CR>', { desc = "Move to up pane" })
	  vim.keymap.set('n', '<C-h>', '<CMD>NavigatorLeft<CR>', { desc = "Move to left pane" })
	  vim.keymap.set('n', '<C-l>', '<CMD>NavigatorRight<CR>', { desc = "Move to right pane" })
  end,
}
