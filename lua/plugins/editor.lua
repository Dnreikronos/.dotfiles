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
		opts = {},
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		config = function()
			require("noice").setup({
				lsp = {
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true,
					},
				},
				presets = {
					bottom_search = true,
					command_palette = true,
					long_message_to_split = true,
					inc_rename = true,
					lsp_doc_border = false,
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
		"nanotech/jellybeans.vim",
		config = function()
			vim.cmd.colorscheme("jellybeans")
		end
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
				desc = "Open zen-mode without word wrap and 90 width"
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
