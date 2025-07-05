local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    rust = { "rustfmt" },
    go = { "goimports" }, -- or { "gofmt" }, if preferred
    -- css = { "prettier" },
    -- html = { "prettier" },
  },
}

return options
