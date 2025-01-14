local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, {})
vim.keymap.set('n', '<leader>fw', builtin.grep_string, {})
vim.keymap.set('n', '<leader>fj', builtin.jumplist, {})
vim.keymap.set('n', '<leader>ss', builtin.spell_suggest, {})

local actions = require "telescope.actions"
require("telescope").setup {
  pickers = {
    buffers = {
      initial_mode = "insert",
      mappings = {
        n = {
          ["<C-d>"] = actions.delete_buffer + actions.move_to_top,
        }
      }
    },
    live_grep = {
      initial_mode = "insert"
    }
  },
  defaults = {
    initial_mode = "normal",
    layout_config = { prompt_position = "top" },
    sorting_strategy = "ascending"
  }
}
