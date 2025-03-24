-- Toggle NeoTree
vim.keymap.set('n', '<C-n>', '<Cmd>Neotree toggle<CR>')

require("neo-tree").setup({
  filesystem = {
    use_libuv_file_watcher = true,
    filtered_items = {
      hide_dotfiles = false,
      hide_gitignored = true,
    },
  },
})
