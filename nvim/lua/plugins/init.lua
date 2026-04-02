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
    "lewis6991/satellite.nvim",
    event = "BufRead",
    config = function()
      require("satellite").setup({
        current_only = false,
        winblend = 0,
        zindex = 40,
        excluded_filetypes = {
          "NvimTree", "neo-tree", "help", "terminal",
          "lazy", "mason", "nvdash", "nvcheatsheet",
        },
        handlers = {
          cursor = { enable = true, symbols = { "█" } },
          search = { enable = true },
          diagnostic = { enable = true },
          gitsigns = { enable = true, symbols = { "▎" } },
        },
      })
      vim.api.nvim_set_hl(0, "SatelliteBar", { bg = "#555555" })
      vim.api.nvim_set_hl(0, "SatelliteCursor", { fg = "#ffffff" })
      vim.api.nvim_set_hl(0, "SatelliteGitSignsAdd", { fg = "#50fa7b" })
      vim.api.nvim_set_hl(0, "SatelliteGitSignsChange", { fg = "#f1fa8c" })
      vim.api.nvim_set_hl(0, "SatelliteGitSignsDelete", { fg = "#ff5555" })
    end,
  },
  {
    import = "nvchad.blink.lazyspec"
  },
}
