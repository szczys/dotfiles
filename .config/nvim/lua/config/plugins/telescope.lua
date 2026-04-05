return {
  'nvim-telescope/telescope.nvim', version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    -- optional but recommended
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  },

  config = function ()
    local actions = require "telescope.actions"
    require("telescope").setup {
      pickers = {
        buffers = {
          mappings = {
            n = {
              ["<C-d>"] = actions.delete_buffer + actions.move_to_top,
            }
          }
        },
      },
      defaults = {
        initial_mode = "insert",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending"
      }
    }

    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>fp', builtin.builtin, {})
    vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
    vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
    vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, {})
    vim.keymap.set('n', '<leader>fw', builtin.grep_string, {})
    vim.keymap.set('n', '<leader>fj', builtin.jumplist, {})
    vim.keymap.set('n', '<leader>ss', builtin.spell_suggest, {})

    -- Vim Navigator (Git) commands
    vim.keymap.set("n", "<leader>gg", "<CMD>G<CR>", { desc = "Show git status list in buffer" })
    vim.keymap.set("n", "<leader>gs", "<CMD>Telescope git_status<CR>", { desc = "Show git status in Telescope window" })
    vim.keymap.set("n", "<leader>gl", "<CMD>Telescope git_commits<CR>", { desc = "Show git commit titles in Telescope window" })
    vim.keymap.set("n", "<leader>gb", "<CMD>Telescope git_branches<CR>", { desc = "Show git branch list in Telescope window" })
    vim.keymap.set("n", "<leader>gt", "<CMD>Telescope git_stash<CR>", { desc = "Show git stash list in Telescope window" })
  end,
}
