vim.keymap.set('i', 'kj', '<Esc>', { desc = "Use 'kj' keys in quick succession for ESC" })

-- remap pane navigation
vim.keymap.set('n', '<C-j>', '<CMD>NavigatorDown<CR>', { desc = "Move to down pane" })
vim.keymap.set('n', '<C-k>', '<CMD>NavigatorUp<CR>', { desc = "Move to up pane" })
vim.keymap.set('n', '<C-h>', '<CMD>NavigatorLeft<CR>', { desc = "Move to left pane" })
vim.keymap.set('n', '<C-l>', '<CMD>NavigatorRight<CR>', { desc = "Move to right pane" })

-- Paste without overwriting register
vim.keymap.set("v", "p", '"_dP', { desc = "Paste without overwriting register"})

-- Copy text to " register
vim.keymap.set({"n", "v"}, "<leader>y", "\"+y", { desc = "Yank into \" register" })
vim.keymap.set("n", "<leader>Y", "\"+Y", { desc = "Yank into \" register" })

-- Delete text to " register
vim.keymap.set("n", "<leader>d", "\"_d", { desc = "Delete into \" register" })
vim.keymap.set("v", "<leader>d", "\"_d", { desc = "Delete into \" register" })

-- Move lines up or down when in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

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

-- Find and replace visual selection using CTRL-r
vim.keymap.set("v", "<C-r>", "\"hy:%s/<C-r>h//gc<left><left><left>")
