return {
  "CopilotC-Nvim/CopilotChat.nvim",
  dependencies = {
    { "nvim-lua/plenary.nvim", branch = "master" },
    'nvim-telescope/telescope-ui-select.nvim', -- Used by CopilotChat
  },
  build = "make tiktoken",
  opts = {
    -- See Configuration section for options
    mappings = {
      reset = {
        normal = "<C-q>",
        insert = "<C-q>",
      },
    },
  },
  config = function ()
    vim.opt.splitright = true
  end,
}
