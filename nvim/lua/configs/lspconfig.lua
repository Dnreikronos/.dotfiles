require("nvchad.configs.lspconfig").defaults()

local servers = {
  "gopls",         -- Go
  "rust_analyzer", -- Rust
  "html",          -- HTML
  "cssls",         -- CSS
  "ts_ls",         -- React/Next.js (TypeScript/JavaScript)
}

vim.lsp.enable(servers)
