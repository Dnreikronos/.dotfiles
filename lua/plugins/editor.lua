return {
	{
		'nvimdev/dashboard-nvim',
		event = 'VimEnter',
		config = function()
			require('dashboard').setup {}
		end,
		dependencies = { { 'nvim-tree/nvim-web-devicons' } }
	},
	{
		'akinsho/bufferline.nvim',
		version = "*",
		dependencies = 'nvim-tree/nvim-web-devicons',
		config = function()
			require('bufferline').setup()
		end
	},
	{
		'echasnovski/mini.animate',
		enabled = false,
		version = '*',
		config = function()
			require('mini.animate').setup()
		end
	},
	{
		'echasnovski/mini.statusline',
		version = '*',
		config = function()
			require('mini.statusline').setup()
		end
	},
	{
		'echasnovski/mini.trailspace',
		version = '*',
		config = function()
			require('mini.trailspace').setup()
		end
	},
	{
		'echasnovski/mini.indentscope',
		version = '*',
		config = function()
			require('mini.indentscope').setup()
		end
	},
	{
		"dinhhuy258/git.nvim",
		event = "BufReadPre",
		opts = {
			keymaps = {
				blame = "<Leader>gb",
				browse = "<Leader>go",
			},
		},
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			-- add any options here
		},
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			"rcarriga/nvim-notify",
		},
		config = function()
			require("noice").setup({
				lsp = {
					-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true,
					},
				},
				-- you can enable a preset for easier configuration
				presets = {
					bottom_search = true,    -- use a classic bottom cmdline for search
					command_palette = true,  -- position the cmdline and popupmenu together
					long_message_to_split = true, -- long messages will be sent to a split
					inc_rename = true,       -- enables an input dialog for inc-rename.nvim
					lsp_doc_border = false,  -- add a border to hover docs and signature help
				},
			})
		end
	},
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {
			label = {
				rainbow = {
					enabled = true
				}
			}
		},
		keys = {
			{ "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
			{ "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
			{ "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
			{ "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
			{ "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
		},
	},
	{
		"theprimeagen/harpoon",
		keys = {
			{ "<leader>a", function() require("harpoon.mark").add_file() end,        desc = "Add current file to the list" },
			{ "<C-e>",     function() require("harpoon.ui").toggle_quick_menu() end, desc = "Toggle quick menu" },
			{ "<C-h>",     function() require("harpoon.ui").nav_file(1) end,         desc = "Go to file 1" },
			{ "<C-j>",     function() require("harpoon.ui").nav_file(2) end,         desc = "Go to file 2" },
			{ "<C-k>",     function() require("harpoon.ui").nav_file(3) end,         desc = "Go to file 3" },
			{ "<C-l>",     function() require("harpoon.ui").nav_file(4) end,         desc = "Go to file 4" }
		}
	},
	{
		"rebelot/kanagawa.nvim",
		opts = {
			transparent = true,
		},
	},
	{
		"smoka7/multicursors.nvim",
		event = "VeryLazy",
		dependencies = {
			'smoka7/hydra.nvim',
		},
		opts = {},
		cmd = { 'MCstart', 'MCvisual', 'MCclear', 'MCpattern', 'MCvisualPattern', 'MCunderCursor' },
		keys = {
			{
				mode = { 'v', 'n' },
				'<Leader>m',
				'<cmd>MCstart<cr>',
				desc = 'Create a selection for selected text or word under the cursor',
			},
		},
	},
	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.5',
		dependencies = { 'nvim-lua/plenary.nvim' },
		keys = {
			{ '<C-p>',      function() require('telescope.builtin').git_files() end,  desc = "List git files" },
			{
				'<leader>fs',
				function()
					require('telescope.builtin').grep_string({ search = vim.fn.input("Grep > ") })
				end,
				desc = "Grep search"
			},
			{ '<leader>ff', function() require('telescope.builtin').find_files() end, desc = "List files" },
			{ '<leader>fg', function() require('telescope.builtin').live_grep() end,  desc = "Live grep search" },
			{ '<leader>fb', function() require('telescope.builtin').buffers() end,    desc = "List open buffers" },
			{ '<leader>fh', function() require('telescope.builtin').help_tags() end,  desc = "List help tags" },
		}
	},
	{
		"mbbill/undotree",
		keys = {
			{ "<leader>u", function() vim.cmd.UndotreeToggle() end, desc = "Open undotree" }
		}
	},
	{
		"folke/zen-mode.nvim",
		keys = {
			{
				"<leader>zm",
				":ZenMode<cr>",
				desc = "Open default zen-mode"
			},
			{
				"<leader>zz",
				function()
					require("zen-mode").setup {
						window = {
							width = 90,
							options = {}
						},
					}
					require("zen-mode").toggle()
					vim.wo.wrap = false
					vim.wo.number = true
					vim.wo.rnu = true
				end,
				desc = "Open zen-mode withouth word wrap and 90 width"
			},
			{
				"<leader>zZ",
				function()
					require("zen-mode").setup {
						window = {
							width = 80,
							options = {}
						},
					}
					require("zen-mode").toggle()
					vim.wo.wrap = false
					vim.wo.number = false
					vim.wo.rnu = false
					vim.opt.colorcolumn = "0"
				end,
				desc = "Open cleanest zen-mode"
			}
		}
	},
}

