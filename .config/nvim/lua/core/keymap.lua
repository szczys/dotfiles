vim.keymap.set('i', 'kj', '<Esc>', { desc = "Use 'kj' keys in quick succession for ESC" })

-- remap pane navigation
vim.keymap.set('n', '<C-j>', '<C-W>j', { desc = "Move to left pane" })
vim.keymap.set('n', '<C-k>', '<C-W>k', { desc = "Move to upper pane" })
vim.keymap.set('n', '<C-h>', '<C-W>h', { desc = "Move to lower pane" })
vim.keymap.set('n', '<C-l>', '<C-W>l', { desc = "Move to right pane" })

-- Paste without overwriting register
vim.keymap.set("v", "p", '"_dP', { desc = "Paste without overwriting register"})

-- Copy text to " register
vim.keymap.set({"n", "v"}, "<leader>y", "\"+y", { desc = "Yank into \" register" })
vim.keymap.set("n", "<leader>Y", "\"+Y", { desc = "Yank into \" register" })

-- Delete text to " register
vim.keymap.set("n", "<leader>d", "\"_d", { desc = "Delete into \" register" })
vim.keymap.set("v", "<leader>d", "\"_d", { desc = "Delete into \" register" })

-- Keep window centered when going up/down
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-f>", "<C-f>zz")
vim.keymap.set("n", "<C-b>", "<C-b>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("n", "<space><space>", "<cmd> :noh<CR>", { desc = "Clear search highlighting" })

vim.keymap.set("n", "<leader>t", function()
   vim.cmd("cd %:p:h")
   vim.cmd("belowright split | terminal")
   vim.cmd("startinsert")
end, { desc = "Open terminal in folder of current file"})
