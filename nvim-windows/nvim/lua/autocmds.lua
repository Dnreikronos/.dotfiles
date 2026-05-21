require "nvchad.autocmds"

-- .env / .env.* files: assign sh filetype + `#` commentstring so `gc` works.
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { ".env", ".env.*", "*.env" },
  callback = function()
    vim.bo.filetype = "sh"
    vim.bo.commentstring = "# %s"
  end,
})
