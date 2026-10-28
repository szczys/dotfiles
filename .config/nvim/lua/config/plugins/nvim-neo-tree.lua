return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons", -- optional, but recommended
  },
  lazy = false,

  config = function ()
    require("neo-tree").setup({
      filesystem = {
        use_libuv_file_watcher = true, -- refresh on external disk changes
      },
    })
    vim.keymap.set("n", "<leader>ee", "<cmd>Neotree toggle<CR>", {desc = "Toggle file explorer"}) -- toggle file explorer
  end,
}
