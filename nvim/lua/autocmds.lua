require "nvchad.autocmds"

-- .env / .env.* files: assign sh filetype + `#` commentstring so `gc` works.
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { ".env", ".env.*", "*.env" },
  callback = function()
    vim.bo.filetype = "sh"
    vim.bo.commentstring = "# %s"
  end,
})

-- `nvim .` (single directory arg) → auto-open 4 named terminal vsplits.
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() ~= 1 then return end
    local arg = vim.fn.argv(0)
    if vim.fn.isdirectory(arg) ~= 1 then return end

    vim.schedule(function()
      local names = { "plan", "implementation", "fix", "review" }
      local start_buf = vim.api.nvim_get_current_buf()

      vim.cmd("silent! only")
      vim.cmd("enew")
      vim.cmd("terminal")
      pcall(vim.api.nvim_buf_set_name, 0, names[1])

      for i = 2, #names do
        vim.cmd("vsplit | terminal")
        pcall(vim.api.nvim_buf_set_name, 0, names[i])
      end

      pcall(vim.api.nvim_buf_delete, start_buf, { force = true })
      vim.cmd("wincmd t")
      vim.cmd("startinsert")
    end)
  end,
})
