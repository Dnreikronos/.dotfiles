require "nvchad.mappings"

local key = vim.keymap.set

vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

key({ 'n', 'i', 'v' }, '<C-s>', '<CMD>w<CR>', { desc = '[S]ave the current file.' })
key({ 'n', 'i', 'v', 't' }, '<C-q>', '<CMD>qa!<CR>', { desc = 'Force quit all (no save).' })

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("v", "<leader>/", "<Plug>(comment_toggle_linewise_visual)",
  { noremap = false, desc = "Toggle comment on selection" })

--[[ telescope ]]
vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep, {})
vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, { desc = 'Find Files' })


vim.keymap.set("n", "<tab>", vim.cmd.bnext)
vim.keymap.set("n", "<S-tab>", vim.cmd.bNext)
vim.keymap.set("n", "<leader>x", vim.cmd.bdelete)
vim.api.nvim_set_keymap('v', '<C-c>', '"+y', { noremap = true, silent = true })

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- git hunk navigation
map("n", "]g", function() require("gitsigns").nav_hunk("next") end, { desc = "Next git change" })
map("n", "[g", function() require("gitsigns").nav_hunk("prev") end, { desc = "Previous git change" })
map("n", "<leader>gp", function() require("gitsigns").preview_hunk() end, { desc = "Preview git hunk" })
map("n", "<leader>gr", function() require("gitsigns").reset_hunk() end, { desc = "Reset git hunk" })

map("n", "<leader>ln", function()
  vim.wo.number = not vim.wo.number
  vim.wo.relativenumber = not vim.wo.relativenumber
end, { desc = "Toggle line numbers" })

map("n", "<leader>mp", "<CMD>MarkdownPreviewToggle<CR>", { desc = "Toggle markdown preview" })

map("n", "<C-t>", function()
  require("nvchad.themes").open()
end, {})

-- window focus (inherited from nvchad.mappings, see line 1)
--   <C-h> -> focus left window
--   <C-l> -> focus right window
--   <C-j> -> focus window below
--   <C-k> -> focus window above
--
-- Terminal mode (when cursor is inside an :terminal buffer and keystrokes are
-- being sent to the shell), nvim does NOT respond to window-focus keybinds
-- because every keypress is forwarded to the underlying PTY. To regain
-- control you must first leave terminal-mode and return to normal-mode.
--
-- Built-in escape:   <C-\><C-n>   (Ctrl+\ then Ctrl+n)
-- Custom escape:     jk           (defined below)
--
-- After leaving term-mode, the cursor is in normal-mode inside the terminal
-- window, so any of the <C-h/j/k/l> bindings above can be used to focus a
-- neighboring window (e.g. the file on the left).
--
-- Note: <Esc> is intentionally NOT remapped here because terminal programs
-- (vim-in-term, fzf, less, htop, etc.) need to receive raw <Esc>. The "jk"
-- digraph is uncommon in shell input and safe to intercept.
map("t", "jk", [[<C-\><C-n>]], { desc = "Exit terminal mode (jk escape)" })

-- jumplist navigation (vim built-in, no remap)
--   <C-o> -> jump back to previous location (e.g. after `gd` go-to-definition)
--   <C-i> -> jump forward to next location in the jumplist
--
-- Note: <C-i> and <Tab> share the same keycode in terminals, and <Tab> is
-- remapped above (line 40) to :bnext. Use <C-i> literally for forward-jump,
-- or `:jumps` to inspect the full jumplist.

-- window resize
map("n", "<C-A-l>", "<cmd>vertical resize +5<CR>", { desc = "Increase window width" })
map("n", "<C-A-h>", "<cmd>vertical resize -5<CR>", { desc = "Decrease window width" })
map("n", "<C-A-k>", "<cmd>resize +3<CR>", { desc = "Increase window height" })
map("n", "<C-A-j>", "<cmd>resize -3<CR>", { desc = "Decrease window height" })
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Persistent toggleable terminal size (override NvChad <A-h> / <A-v>)
-- nvchad.term stores opts in g.nvchad_terms keyed by buf. display() uses
-- opts.size (fraction of lines/columns) if set. Capture the current size
-- before closing, replay it on next open.
local saved_sizes = { sp = nil, vsp = nil }

local function make_toggle(pos, id)
  return function()
    local terms = vim.g.nvchad_terms or {}
    local existing
    for _, t in pairs(terms) do
      if type(t) == "table" and t.id == id then existing = t; break end
    end

    local visible_win = nil
    if existing and vim.api.nvim_buf_is_valid(existing.buf) then
      local win = vim.fn.bufwinid(existing.buf)
      if win ~= -1 then visible_win = win end
    end

    if visible_win then
      if pos == "sp" then
        saved_sizes.sp = vim.api.nvim_win_get_height(visible_win) / vim.o.lines
      else
        saved_sizes.vsp = vim.api.nvim_win_get_width(visible_win) / vim.o.columns
      end
    end

    local opts = { pos = pos, id = id }
    local s = saved_sizes[pos]
    if s then opts.size = s end
    require("nvchad.term").toggle(opts)
  end
end

map({ "n", "t" }, "<A-h>", make_toggle("sp", "htoggleTerm"),
  { desc = "Toggle horizontal term (persist size)" })
map({ "n", "t" }, "<A-v>", make_toggle("vsp", "vtoggleTerm"),
  { desc = "Toggle vertical term (persist size)" })

-- Reload config: clear loaded user modules, recompile base46 (theme cache),
-- re-source init.lua, and reapply highlights so chadrc changes (incl.
-- transparency) take effect without a full restart.
local function reload_config()
  for name, _ in pairs(package.loaded) do
    if name:match("^mappings")
      or name:match("^options")
      or name:match("^autocmds")
      or name:match("^chadrc")
      or name:match("^nvconfig")
      or name:match("^configs%.")
      or name:match("^plugins")
      or name:match("^base46")
    then
      package.loaded[name] = nil
    end
  end
  local ok, base46 = pcall(require, "base46")
  if ok then
    pcall(base46.load_all_highlights)
  end
  vim.cmd("source " .. vim.env.MYVIMRC)
  vim.notify("nvim config reloaded", vim.log.levels.INFO)
end

map("n", "<C-A-r>", reload_config, { desc = "Reload nvim config" })
