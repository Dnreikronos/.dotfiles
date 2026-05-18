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

-- Equalize all windows (vim built-in <C-w>=). Works from terminal-mode too
-- by stepping out to normal-mode first.
map("n", "<A-r>", "<C-w>=", { desc = "Equalize all window sizes" })
map("t", "<A-r>", [[<C-\><C-n><C-w>=]], { desc = "Equalize all window sizes" })
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- Group toggle: <A-h>/<A-v> hide ALL visible terms of given orientation,
-- or re-show all hidden terms of that orientation. Scans the current tab's
-- windows directly (not just vim.g.nvchad_terms) so terms created by any
-- means are caught. Orientation is read from nvchad_terms metadata when
-- available, with a geometry-based fallback for foreign terms.
local saved_sizes = { sp = nil, vsp = nil }
local hidden_bufs = { sp = {}, vsp = {} }
-- Explicit buf→pos registry. Source of truth for orientation; populated by
-- our own term-creation paths via _pending_pos + TermOpen autocmd.
local user_term_pos = {}
local _pending_pos = nil

local function spawn_term(opts)
  _pending_pos = opts.pos
  require("nvchad.term").new(opts)
end

vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("UserTermPosRegistry", { clear = true }),
  callback = function(args)
    if _pending_pos then
      user_term_pos[args.buf] = _pending_pos
      _pending_pos = nil
    end
  end,
})

vim.api.nvim_create_autocmd("BufWipeout", {
  group = vim.api.nvim_create_augroup("UserTermPosCleanup", { clear = true }),
  callback = function(args)
    user_term_pos[args.buf] = nil
  end,
})

local function size_to_fraction(pos)
  local abs = saved_sizes[pos]
  if not abs then return nil end
  local total = (pos == "sp") and vim.o.lines or vim.o.columns
  if total <= 0 then return nil end
  return abs / total
end

local function win_orientation(win)
  local buf = vim.api.nvim_win_get_buf(win)
  -- 1. Our explicit registry (most reliable).
  if user_term_pos[buf] then return user_term_pos[buf] end
  -- 2. nvchad_terms metadata.
  for _, t in pairs(vim.g.nvchad_terms or {}) do
    if type(t) == "table" and t.buf == buf and (t.pos == "sp" or t.pos == "vsp") then
      user_term_pos[buf] = t.pos
      return t.pos
    end
  end
  -- 3. Geometry fallback: full-width row → "sp"; full-height col → "vsp".
  local w = vim.api.nvim_win_get_width(win)
  local h = vim.api.nvim_win_get_height(win)
  if w >= vim.o.columns - 1 then return "sp" end
  if h >= (vim.o.lines - vim.o.cmdheight - 1) - 1 then return "vsp" end
  return nil
end

local function merge_hidden(pos, bufs)
  local seen = {}
  for _, b in ipairs(hidden_bufs[pos] or {}) do seen[b] = true end
  for _, b in ipairs(bufs) do
    if not seen[b] and vim.api.nvim_buf_is_valid(b) then
      table.insert(hidden_bufs[pos], b)
      seen[b] = true
    end
  end
end

local function toggle_group(pos)
  return function()
    local visible = {}
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      local buf = vim.api.nvim_win_get_buf(win)
      if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == "terminal"
        and win_orientation(win) == pos then
        table.insert(visible, { win = win, buf = buf })
      end
    end

    if #visible > 0 then
      local first_win = visible[1].win
      saved_sizes[pos] = (pos == "sp")
        and vim.api.nvim_win_get_height(first_win)
        or vim.api.nvim_win_get_width(first_win)
      local newly_hidden = {}
      local target_wins = {}
      for _, v in ipairs(visible) do
        table.insert(newly_hidden, v.buf)
        target_wins[v.win] = true
      end
      merge_hidden(pos, newly_hidden)

      -- Exit terminal-mode if currently in t-mode, so closing the focused
      -- term window can't be deferred/blocked by the mode transition.
      local mode = vim.api.nvim_get_mode().mode
      if mode == "t" then
        vim.api.nvim_feedkeys(
          vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true),
          "n", false)
      end

      -- Move focus to a non-target window so we never close the current win.
      -- Prefer a normal (non-terminal) win; otherwise any non-target term.
      local safe_win = nil
      for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if not target_wins[w] and vim.api.nvim_win_is_valid(w) then
          local b = vim.api.nvim_win_get_buf(w)
          if vim.bo[b].buftype ~= "terminal" then safe_win = w; break end
        end
      end
      if not safe_win then
        for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
          if not target_wins[w] and vim.api.nvim_win_is_valid(w) then
            safe_win = w; break
          end
        end
      end
      if safe_win then
        pcall(vim.api.nvim_set_current_win, safe_win)
      end

      -- Defer closes to next tick so the mode-exit and focus-switch have
      -- settled; otherwise the currently-focused term close can no-op.
      vim.schedule(function()
        for i = #visible, 1, -1 do
          if vim.api.nvim_win_is_valid(visible[i].win) then
            pcall(vim.api.nvim_win_close, visible[i].win, true)
          end
        end
      end)
      return
    end

    local bufs = {}
    for _, b in ipairs(hidden_bufs[pos] or {}) do
      if vim.api.nvim_buf_is_valid(b) then table.insert(bufs, b) end
    end

    if #bufs == 0 then
      local id = (pos == "sp") and "htoggleTerm" or "vtoggleTerm"
      local opts = { pos = pos, id = id }
      local frac = size_to_fraction(pos)
      if frac then opts.size = frac end
      spawn_term(opts)
      return
    end

    local size = saved_sizes[pos]
    local anchor = vim.api.nvim_get_current_win()
    local modifier = (pos == "sp") and "belowright" or "vertical belowright"
    local resize_cmd = (pos == "sp") and "resize" or "vertical resize"

    for i = #bufs, 1, -1 do
      local buf = bufs[i]
      if vim.api.nvim_win_is_valid(anchor) then
        vim.api.nvim_set_current_win(anchor)
      end
      local cmd
      if size and size > 0 then
        cmd = string.format("%s split | buffer %d | %s %d", modifier, buf, resize_cmd, size)
      else
        cmd = string.format("%s split | buffer %d", modifier, buf)
      end
      local ok = pcall(vim.cmd, cmd)
      if ok and size and size > 0 then
        local new_win = vim.api.nvim_get_current_win()
        vim.schedule(function()
          if vim.api.nvim_win_is_valid(new_win) then
            if pos == "sp" then
              pcall(vim.api.nvim_win_set_height, new_win, size)
            else
              pcall(vim.api.nvim_win_set_width, new_win, size)
            end
          end
        end)
      end
    end
    hidden_bufs[pos] = {}
  end
end

-- Continuously capture term-window size on user resize so the next toggle-off
-- → toggle-on cycle restores whatever the user last set, even if they never
-- toggle-hide between resizes. Augroup prevents duplicate listeners on reload.
local term_size_group = vim.api.nvim_create_augroup("UserTermSizePersist", { clear = true })
vim.api.nvim_create_autocmd("WinResized", {
  group = term_size_group,
  callback = function()
    local wins = (vim.v.event and vim.v.event.windows) or {}
    for _, win in ipairs(wins) do
      if vim.api.nvim_win_is_valid(win) then
        local buf = vim.api.nvim_win_get_buf(win)
        if vim.bo[buf].buftype == "terminal" then
          local pos = win_orientation(win)
          if pos == "sp" then
            saved_sizes.sp = vim.api.nvim_win_get_height(win)
          elseif pos == "vsp" then
            saved_sizes.vsp = vim.api.nvim_win_get_width(win)
          end
        end
      end
    end
  end,
})

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
    spawn_term(opts)
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
