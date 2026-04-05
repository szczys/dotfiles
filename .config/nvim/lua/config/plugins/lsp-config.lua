return {
  {
    'mason-org/mason.nvim',
    opts = {},
  },

  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        -- Tell Mason which LSPs to install
        "bashls",
        "clangd",
        "cssls",
        "dockerls",
        "jsonls",
        "lua_ls",
        "marksman",
        "ruff",
        "rust_analyzer",
        "yamlls"
      },
    },
  },

  {
    "neovim/nvim-lspconfig",
    config = function()

      -- Silence "Undefined global" warnings on keyword: vim
      vim.lsp.config("lua_ls", {
          settings = {
              Lua = {
                  diagnostics = {
                      globals = { "vim" }}}}})

      -- Enable LSPs
      vim.lsp.enable('bashls')
      vim.lsp.enable('clangd')
      vim.lsp.enable('cssls')
      vim.lsp.enable('dockerls')
      vim.lsp.enable('jsonls')
      vim.lsp.enable('lua_ls')
      vim.lsp.enable('marksman')
      vim.lsp.enable('ruff')
      vim.lsp.enable('rust_analyzer')
      vim.lsp.enable('yamlls')

      -- Disable logging
      vim.lsp.set_log_level("off")

      -- Keymap
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
      vim.keymap.set('n', 'K', function()
        vim.lsp.buf.hover( { border = 'rounded' })
        vim.api.nvim_command('hi clear Error')
      end, opts)
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
      vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references, {})
      vim.keymap.set('n', 'gl', require('telescope.builtin').diagnostics, opts)
      vim.keymap.set('n', 'ge', vim.diagnostic.open_float, opts)
      vim.keymap.set('n', '<space>k', vim.lsp.buf.signature_help, opts)
      vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
      vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
      vim.keymap.set('n', '<space>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, opts)
      vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
      vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
      vim.keymap.set({ 'n', 'v' }, '<space>ga', vim.lsp.buf.code_action, opts)
      vim.keymap.set('n', '<space>f', function()
        vim.lsp.buf.format { async = true }
      end, opts)
    end
  },
}
