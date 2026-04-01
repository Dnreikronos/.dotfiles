return {
  {
    "stevearc/conform.nvim",
    event = 'BufWritePre',
    opts = require "configs.conform",
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  {
    'vyfor/cord.nvim',
    build = ':Cord update',
    event = "VimEnter",
  },
  {
    'lewis6991/gitsigns.nvim',
    event = "BufRead",
    config = function()
      require('gitsigns').setup({
        current_line_blame = true,
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = 'eol',
          delay = 300,
        },
      })
    end,
  },
  {
    import = "nvchad.blink.lazyspec" 
  },
}
