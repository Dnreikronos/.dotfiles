return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		cmd = "Telescope",
		keys = {
			{ "<leader>fg", function() require("telescope.builtin").live_grep() end,  desc = "Live Grep" },
			{ "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "Find Files" },
		},
		opts = {
			defaults = {
				layout_config = { prompt_position = "top" },
				sorting_strategy = "ascending",
			},
		},
	}
}
