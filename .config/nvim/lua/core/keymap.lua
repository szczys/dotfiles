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

-- Format Markdown table (use `vip` to select table first)
vim.keymap.set('v', '<leader>f', '!pandoc -t markdown-simple_tables<CR>',
  { silent = true, desc = 'Align selected md table using pandoc; use `vip` to select table' })

-- Vim Navigator (Git) commands
vim.keymap.set("n", "<leader>gg", "<CMD>G<CR>", { desc = "Show git status list in buffer" })
vim.keymap.set("n", "<leader>gs", "<CMD>Telescope git_status<CR>", { desc = "Show git status in Telescope window" })
vim.keymap.set("n", "<leader>gl", "<CMD>Telescope git_commits<CR>", { desc = "Show git commit titles in Telescope window" })
vim.keymap.set("n", "<leader>gb", "<CMD>Telescope git_branches<CR>", { desc = "Show git branch list in Telescope window" })
vim.keymap.set("n", "<leader>gt", "<CMD>Telescope git_stash<CR>", { desc = "Show git stash list in Telescope window" })
vim.keymap.set("n", "<leader>gri", function()
    local rebase_branch = vim.fn.input("Enter branch to rebase on: ")
    vim.cmd("Git rebase -i " .. rebase_branch)
end, { desc = "Run git rebase interactive. You will be prompted for the branch to rebase onto." })
vim.keymap.set("n", "<leader>gra", "<CMD>G rebase --abort<CR>", { desc = "Abort the git rebase" })
vim.keymap.set("n", "<leader>grc", "<CMD>G rebase --continue<CR>", { desc = "Continue the git rebase" })
vim.keymap.set("n", "<leader>gps", "<CMD>G push<CR>", { desc = "Git push" })
vim.keymap.set("n", "<leader>gpf", "<CMD>G push --force<CR>", { desc = "Git force push" })
vim.keymap.set("n", "<leader>gc", "<CMD>G commit -s<CR>", { desc = "Git signed commit" })
