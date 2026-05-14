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
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = "cd app && npx --yes yarn install",
  },
  {
    "nvim-tree/nvim-tree.lua",
    opts = {
      diagnostics = {
        enable = true,
        show_on_dirs = true,
      },
      renderer = {
        highlight_git = true,
        icons = {
          show = {
            git = true,
            folder = true,
            file = true,
            folder_arrow = true,
          },
          glyphs = {
            git = {
              unstaged  = "",
              staged    = "",
              unmerged  = "",
              renamed   = "",
              untracked = "",
              deleted   = "",
              ignored   = "",
            },
          },
        },
      },
      git = {
        enable = true,
        ignore = false,
      },
    },
    config = function(_, opts)
      require("nvim-tree").setup(opts)

      local function apply_hl()
        local hl = vim.api.nvim_set_hl
        hl(0, "NvimTreeGitDirty",     { fg = "#f1fa8c" })
        hl(0, "NvimTreeGitNew",       { fg = "#8be9fd" })
        hl(0, "NvimTreeGitStaged",    { fg = "#50fa7b" })
        hl(0, "NvimTreeGitRenamed",   { fg = "#ffb86c" })
        hl(0, "NvimTreeGitDeleted",   { fg = "#ff5555" })
        hl(0, "NvimTreeGitMerge",     { fg = "#ff79c6" })
        hl(0, "NvimTreeGitIgnored",   { fg = "#6272a4" })

        hl(0, "NvimTreeFileDirty",    { fg = "#f1fa8c" })
        hl(0, "NvimTreeFileNew",      { fg = "#8be9fd" })
        hl(0, "NvimTreeFileStaged",   { fg = "#50fa7b" })
        hl(0, "NvimTreeFileRenamed",  { fg = "#ffb86c" })
        hl(0, "NvimTreeFileDeleted",  { fg = "#ff5555" })
        hl(0, "NvimTreeFileMerge",    { fg = "#ff79c6" })
        hl(0, "NvimTreeFileIgnored",  { fg = "#6272a4" })

        hl(0, "NvimTreeFolderDirty",  { fg = "#f1fa8c", bold = true })
        hl(0, "NvimTreeFolderNew",    { fg = "#8be9fd", bold = true })
        hl(0, "NvimTreeFolderStaged", { fg = "#50fa7b", bold = true })
      end

      apply_hl()
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("NvimTreeGitHL", { clear = true }),
        callback = apply_hl,
      })
    end,
  },
  {
    import = "nvchad.blink.lazyspec"
  },
}
