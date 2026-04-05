require("nvchad.configs.lspconfig").defaults()

local servers = {
  "gopls",         -- Go
  "rust_analyzer", -- Rust
  "html",          -- HTML
  "cssls",         -- CSS
  "ts_ls",         -- React/Next.js (TypeScript/JavaScript)
  "solidity_ls_nomicfoundation", -- Solidity
}

vim.lsp.enable(servers)
