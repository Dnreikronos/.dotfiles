require "nvchad.autocmds"

-- .env / .env.* files: assign sh filetype + `#` commentstring so `gc` works.
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { ".env", ".env.*", "*.env" },
  callback = function()
    vim.bo.filetype = "sh"
    vim.bo.commentstring = "# %s"
  end,
})

local no_indent_guides = vim.api.nvim_create_augroup("NoIndentGuides", { clear = true })

local function clear_indent_guides()
  pcall(vim.cmd, "IBLDisable")

  for _, group in ipairs({
    "IblChar",
    "IblScopeChar",
    "@ibl.scope.underline.1",
    "@ibl.scope.underline.2",
    "@ibl.scope.underline.3",
    "@ibl.scope.underline.4",
    "@ibl.scope.underline.5",
    "@ibl.scope.underline.6",
    "@ibl.scope.underline.7",
  }) do
    vim.api.nvim_set_hl(0, group, { fg = "NONE", bg = "NONE", sp = "NONE", underline = false })
  end
end

vim.api.nvim_create_autocmd({ "VimEnter", "BufEnter", "ColorScheme" }, {
  group = no_indent_guides,
  callback = clear_indent_guides,
})

clear_indent_guides()
