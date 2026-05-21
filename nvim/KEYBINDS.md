# Neovim Keybinds

`<leader>` = `<Space>`. All custom keymaps live in `lua/mappings.lua`. NvChad defaults inherited via `require "nvchad.mappings"` (line 1) and not duplicated here unless overridden.

## Leader (Space) maps

| Key | Mode | Action |
|---|---|---|
| `<leader>pv` | n | Open netrw file explorer (`:Ex`) |
| `<leader>p` | x (visual) | Paste without overwriting unnamed register |
| `<leader>y` | n / v | Yank to system clipboard (`"+y`) |
| `<leader>Y` | n | Yank line to system clipboard (`"+Y`) |
| `<leader>d` | n / v | Delete to black-hole register (`"_d`) |
| `<leader>f` | n | LSP format current buffer |
| `<leader>/` | n | Toggle comment on current line (`gcc`) |
| `<leader>/` | v | Toggle comment on selection (`gc`) |
| `<leader>ff` | n | Telescope find_files |
| `<leader>fg` | n | Telescope live_grep |
| `<leader>x` | n | Delete current buffer (`:bdelete`) |
| `<leader>X` | n | Wipe ALL empty `[No Name]` buffers |
| `<leader>gp` | n | Preview git hunk (gitsigns) |
| `<leader>gr` | n | Reset git hunk (gitsigns) |
| `<leader>ln` | n | Toggle line numbers (number + relativenumber) |
| `<leader>mp` | n | Toggle MarkdownPreview |
| `<leader>tt` | n | Open `:terminal` in current window |
| `<leader>tv` | n | Open `:terminal` in vertical split |
| `<leader>ts` | n | Open `:terminal` in horizontal split |
| `<leader>tr` | n | Rename current terminal buffer (uses `:file`) |
| `<leader>tk` | n | Kill (force-wipe) current terminal buffer |
| `<leader>tK` | n | Kill ALL terminal buffers |

## Terminal management

| Key | Mode | Action |
|---|---|---|
| `<leader>tt` | n | Open `:terminal` in current window |
| `<leader>tv` | n | Open `:terminal` in vertical split (repeat → more side-by-side) |
| `<leader>ts` | n | Open `:terminal` in horizontal split |
| `<leader>tr` | n | Rename current terminal buffer (prompts for name) |
| `<A-h>` | n / t | Toggle ALL horizontal terms (hide/show as group, preserves size + order) |
| `<A-v>` | n / t | Toggle ALL vertical terms (hide/show as group, preserves size + order) |
| `<A-n>` then `h` | n / t | Spawn a NEW horizontal term (chord) |
| `<A-n>` then `v` | n / t | Spawn a NEW vertical term (chord) |
| `<leader>tk` | n | Kill current terminal buffer |
| `<leader>tK` | n | Kill all terminal buffers |
| `jk` | t | Exit terminal-mode (alias for `<C-\><C-n>`) |

Notes:
- `<leader>tt`/`tv`/`ts` open a plain `:terminal` — independent of the NvChad term-group machinery (`<A-h>`/`<A-v>` toggle), so they will not be picked up by group hide/show unless geometry-fallback classifies them.
- `<leader>tr` renames the current term buffer via `:file <name>`; used by the `nvim .` auto-open layout to label splits.
- Toggle binds hide the term window but keep the buffer + process alive. Use `<leader>tk` / `<leader>tK` to actually terminate.
- Spawn binds use a chord: press `<A-n>`, release, then `h` or `v` within `timeoutlen` (default 1000ms).
- Re-show preserves the most-recent height/width captured at hide time.

## Buffer navigation

| Key | Mode | Action |
|---|---|---|
| `<Tab>` | n | Next buffer (`:bnext`) |
| `<S-Tab>` | n | Previous buffer (`:bNext`) |
| `<leader>x` | n | Close current buffer (`:bdelete`) |
| `<A-b>` | n | Force-delete current buffer (`:bd!`) |
| `<leader>X` | n | Wipe all empty `[No Name]` buffers |

## Window focus (from NvChad defaults)

| Key | Action |
|---|---|
| `<C-h>` | Focus window left |
| `<C-l>` | Focus window right |
| `<C-j>` | Focus window below |
| `<C-k>` | Focus window above |

Inside a terminal you must first leave term-mode with `jk` (or `<C-\><C-n>`) before window-focus keys work — every keypress in term-mode is forwarded to the underlying PTY.

## Window resize

| Key | Action |
|---|---|
| `<C-A-l>` | Vertical resize +5 (wider) |
| `<C-A-h>` | Vertical resize -5 (narrower) |
| `<C-A-k>` | Horizontal resize +3 (taller) |
| `<C-A-j>` | Horizontal resize -3 (shorter) |

## Save / quit

| Key | Mode | Action |
|---|---|---|
| `<C-s>` | n / i / v | Save current file (`:w`) |
| `<C-q>` | n / i / v / t | Force quit all without saving (`:qa!`) |

## Editing tweaks

| Key | Mode | Action |
|---|---|---|
| `J` | v | Move selection down |
| `K` | v | Move selection up |
| `J` | n | Join lines, keep cursor in place |
| `<C-d>` | n | Half-page down, centered |
| `<C-u>` | n | Half-page up, centered |
| `n` | n | Next search match, centered |
| `N` | n | Previous search match, centered |
| `Q` | n | Disabled (no-op) |
| `;` | n | Enter cmd mode (`:`) |
| `jk` | i | Escape to normal mode |
| `<C-c>` | v | Yank to system clipboard |

## Git hunks (gitsigns)

| Key | Action |
|---|---|
| `]g` | Next hunk |
| `[g` | Previous hunk |
| `<leader>gp` | Preview hunk |
| `<leader>gr` | Reset hunk |

## Themes / config

| Key | Action |
|---|---|
| `<C-t>` | Open NvChad theme picker |
| `<C-A-r>` | Reload nvim config (clears loaded modules, re-sources init.lua, reapplies base46 highlights) |

## Jumplist (built-in, listed as reminder)

| Key | Action |
|---|---|
| `<C-o>` | Jump back to previous location |
| `<C-i>` | Jump forward in jumplist (note: shares keycode with `<Tab>` — use literally) |
| `:jumps` | Inspect full jumplist |

## Discoverability

- `:Telescope keymaps` — fuzzy search every mapped key with its description
- `<leader>ch` — NvChad cheatsheet UI
- Press `<leader>` and wait — which-key popup shows leader menu
