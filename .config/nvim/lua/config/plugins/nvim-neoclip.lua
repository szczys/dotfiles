return {
  "AckslD/nvim-neoclip.lua",
  dependencies = {
    {'nvim-telescope/telescope.nvim'},
  },
  config = function()
    require('neoclip').setup({
      initial_mode = 'normal',
    })

    vim.keymap.set("n",  "<leader>o", "<cmd>Telescope neoclip<CR>", { desc = "Telescope Neoclip"})
  end,
}
