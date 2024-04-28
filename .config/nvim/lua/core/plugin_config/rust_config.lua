local rt = require("rust-tools")

rt.setup({
  server = {
    capabilities = require("cmp_nvim_lsp").default_capabilities();
    on_attach = function(_, bufnr)
      -- Hover actions
      vim.keymap.set("n", "<Leader>k", rt.hover_actions.hover_actions, { buffer = bufnr })
      -- Code action groups
      vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
    end,
  },
  tools = {
    hover_actions = {
      auto_focus = true,
    }
  }
})
