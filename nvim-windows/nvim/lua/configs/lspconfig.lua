require("nvchad.configs.lspconfig").defaults()

local servers = {
  "gopls",         -- Go
  "rust_analyzer", -- Rust
  "html",          -- HTML
  "cssls",         -- CSS
  "ts_ls",         -- React/Next.js (TypeScript/JavaScript)
}

vim.lsp.config("rust_analyzer", {
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allTargets = false,
        buildScripts = {
          enable = false,
        },
      },
      check = {
        command = "check",
        allTargets = false,
      },
      checkOnSave = false,
      diagnostics = {
        disabled = { "proc-macro-disabled" },
        experimental = {
          enable = false,
        },
      },
      procMacro = {
        enable = false,
      },
      semanticHighlighting = {
        nonStandardTokens = false,
        operator = {
          enable = false,
        },
        punctuation = {
          enable = false,
        },
      },
    },
  },
  on_attach = function(client)
    client.server_capabilities.semanticTokensProvider = nil
  end,
})

vim.lsp.enable(servers)
