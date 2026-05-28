# kitty kitten: equalize all splits to EQUAL fractions.
# kitty's built-in `resize_window reset` only sets every split bias to 0.5,
# which gives unequal sizes for nested trees (e.g. 50/25/25). This walks the
# splits tree and sets each pair's bias to its leaf-count ratio so every pane
# ends up the same size, including the original/first window.
from kitty.layout.splits import Pair


def main(args):
    # No TUI; all work happens in handle_result (runs in the kitty process).
    return None


def handle_result(args, answer, target_window_id, boss):
    tab = boss.active_tab
    if tab is None:
        return
    root = getattr(tab.current_layout, 'pairs_root', None)
    if root is None:
        return  # current tab is not using the `splits` layout

    def leaves(node):
        if isinstance(node, Pair):
            return leaves(node.one) + leaves(node.two)
        return 0 if node is None else 1

    def balance(pair):
        one, two = leaves(pair.one), leaves(pair.two)
        if one and two:
            pair.bias = one / (one + two)
        if isinstance(pair.one, Pair):
            balance(pair.one)
        if isinstance(pair.two, Pair):
            balance(pair.two)

    balance(root)
    tab.relayout()


handle_result.no_ui = True
