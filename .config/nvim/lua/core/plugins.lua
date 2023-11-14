local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  'ellisonleao/gruvbox.nvim',
  'nvim-tree/nvim-tree.lua',
  'nvim-tree/nvim-web-devicons',
  'nvim-lualine/lualine.nvim',
  'nvim-treesitter/nvim-treesitter',
  'kylechui/nvim-surround',
  'windwp/nvim-autopairs',
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-nvim-lsp',
  'L3MON4D3/LuaSnip',
  'airblade/vim-gitgutter',
  'edkolev/tmuxline.vim',
  'rose-pine/neovim',
  'tomasiser/vim-code-dark',
  'preservim/nerdcommenter',
  'whiteinge/diffconflicts',

  {'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons'},

  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  },

  {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "neovim/nvim-lspconfig",
  },

  {
    'nvim-telescope/telescope.nvim', version = '0.1.4',
    dependencies = { {'nvim-lua/plenary.nvim'} }
  },

  {
    "AckslD/nvim-neoclip.lua",
    dependencies = {
      {'nvim-telescope/telescope.nvim'},
    }
  }
}

require("lazy").setup(plugins, opts)
