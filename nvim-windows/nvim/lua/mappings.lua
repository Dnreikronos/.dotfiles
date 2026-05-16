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

-- Built-in `gc` operator (nvim >= 0.10) uses `commentstring` for the current
-- filetype. Works out of the box for Go (//), Rust (//), SQL (--), Markdown
-- (<!-- -->), Lua (--), sh (#), etc. .env handled via autocmd in autocmds.lua.
vim.keymap.set("x", "<leader>/", "gc",
  { remap = true, desc = "Toggle comment on selection" })
vim.keymap.set("n", "<leader>/", "gcc",
  { remap = true, desc = "Toggle comment on current line" })

--[[ telescope ]]
vim.keymap.set('n', '<leader>fg', require('telescope.builtin').live_grep, {})
vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, { desc = 'Find Files' })


vim.keymap.set("n", "<tab>", vim.cmd.bnext)
vim.keymap.set("n", "<S-tab>", vim.cmd.bNext)
vim.keymap.set("n", "<leader>x", vim.cmd.bdelete)
vim.keymap.set("n", "<A-b>", "<CMD>bd!<CR>", { desc = "Force delete current buffer (bd!)" })
vim.keymap.set("n", "<leader>X", function()
  local closed = 0
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(b) and vim.api.nvim_buf_get_name(b) == "" then
      local lines = vim.api.nvim_buf_line_count(b)
      local first = vim.api.nvim_buf_get_lines(b, 0, 1, false)[1] or ""
      if lines <= 1 and first == "" then
        pcall(vim.api.nvim_buf_delete, b, { force = true })
        closed = closed + 1
      end
    end
  end
  vim.notify("Closed " .. closed .. " empty [No Name] buffer(s)")
end, { desc = "Wipe all empty [No Name] buffers" })
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

-- Group toggle: <A-h>/<A-v> hide all visible terms of given orientation,
-- or re-show all hidden terms of that orientation. Persists ABSOLUTE
-- rows/cols (not fraction) so size survives external window resizes.
-- Re-show always splits off the anchor (current non-term win at toggle
-- time), iterated in reverse so final order matches buf creation order.
local saved_sizes = { sp = nil, vsp = nil }

local function size_to_fraction(pos)
  local abs = saved_sizes[pos]
  if not abs then return nil end
  local total = (pos == "sp") and vim.o.lines or vim.o.columns
  if total <= 0 then return nil end
  return abs / total
end

local function toggle_group(pos)
  return function()
    local terms = vim.g.nvchad_terms or {}
    local group = {}
    for _, t in pairs(terms) do
      if type(t) == "table" and t.pos == pos and vim.api.nvim_buf_is_valid(t.buf) then
        table.insert(group, t)
      end
    end
    table.sort(group, function(a, b) return a.buf < b.buf end)

    if #group == 0 then
      local id = (pos == "sp") and "htoggleTerm" or "vtoggleTerm"
      local opts = { pos = pos, id = id }
      local frac = size_to_fraction(pos)
      if frac then opts.size = frac end
      require("nvchad.term").new(opts)
      return
    end

    local visible_wins = {}
    for _, t in ipairs(group) do
      local win = vim.fn.bufwinid(t.buf)
      if win ~= -1 then table.insert(visible_wins, win) end
    end

    if #visible_wins > 0 then
      local first = visible_wins[1]
      if pos == "sp" then
        saved_sizes.sp = vim.api.nvim_win_get_height(first)
      else
        saved_sizes.vsp = vim.api.nvim_win_get_width(first)
      end
      for _, win in ipairs(visible_wins) do
        pcall(vim.api.nvim_win_close, win, true)
      end
    else
      local size = saved_sizes[pos]
      local anchor = vim.api.nvim_get_current_win()
      local modifier = (pos == "sp") and "belowright" or "vertical belowright"

      for i = #group, 1, -1 do
        local t = group[i]
        if vim.api.nvim_win_is_valid(anchor) then
          vim.api.nvim_set_current_win(anchor)
        end
        local cmd
        if size then
          cmd = string.format("%s %d split | buffer %d", modifier, size, t.buf)
        else
          cmd = string.format("%s split | buffer %d", modifier, t.buf)
        end
        pcall(vim.cmd, cmd)
      end
    end
  end
end

map({ "n", "t" }, "<A-h>", toggle_group("sp"),
  { desc = "Toggle ALL horizontal terms" })
map({ "n", "t" }, "<A-v>", toggle_group("vsp"),
  { desc = "Toggle ALL vertical terms" })

-- Spawn additional terms (do NOT collide with toggle IDs above).
-- Each press creates a fresh term buf with unique id, reusing saved size.
local function make_new(pos)
  return function()
    local opts = { pos = pos, id = "extraTerm_" .. vim.loop.hrtime() }
    local frac = size_to_fraction(pos)
    if frac then opts.size = frac end
    require("nvchad.term").new(opts)
  end
end

map({ "n", "t" }, "<A-n>h", make_new("sp"),
  { desc = "New horizontal term" })
map({ "n", "t" }, "<A-n>v", make_new("vsp"),
  { desc = "New vertical term" })

-- Kill (force-wipe) current terminal buffer.
map("n", "<leader>tk", function()
  local b = vim.api.nvim_get_current_buf()
  if vim.bo[b].buftype == "terminal" then
    pcall(vim.api.nvim_buf_delete, b, { force = true })
  else
    vim.notify("Not a terminal buffer", vim.log.levels.WARN)
  end
end, { desc = "Kill current terminal" })

-- Kill ALL terminal buffers.
map("n", "<leader>tK", function()
  local killed = 0
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(b) and vim.bo[b].buftype == "terminal" then
      pcall(vim.api.nvim_buf_delete, b, { force = true })
      killed = killed + 1
    end
  end
  vim.notify("Killed " .. killed .. " terminal(s)")
end, { desc = "Kill ALL terminals" })

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
