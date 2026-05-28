# gotchas

## kitty splits: `resize_window reset` does NOT equalize panes
- `remove_all_biases()` (kitty/layout/splits.py:666) sets every split bias to **0.5**.
- For a nested binary tree that means unequal leaves: 2 vsplits -> 50/25/25, not thirds.
- The root's 50% half (often the original/first window) "won't resize" -> reset keeps it at 50%.
- `layout_action` only offers: rotate / move_to_screen_edge / bias / maximize. No native equalize.
- Fix: kitten `equalize.py` walks `pairs_root`, sets each `pair.bias = leaves(one)/leaves(pair)` -> all panes equal. Bound to `ctrl+shift+r`. Runs in-process via `handle_result(... boss)` with `no_ui = True`; no remote control needed.
