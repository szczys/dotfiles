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
  },
  dap = {
    adapter = require('rust-tools.dap').get_codelldb_adapter(
      '/home/mike/.local/share/nvim/mason/packages/codelldb/codelldb',
      '/home/mike/.local/share/nvim/mason/packages/codelldb/extension/lldb/lib/liblldb.so'
    )
  }
})
