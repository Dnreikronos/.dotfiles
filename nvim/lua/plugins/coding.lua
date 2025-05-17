return {
	-- Refactoring Plugin
	{
		"ThePrimeagen/refactoring.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		keys = {
			{ "<leader>re",  function() require('refactoring').refactor('Extract Function') end },
			{ "<leader>rf",  function() require('refactoring').refactor('Extract Function To File') end },
			{ "<leader>rv",  function() require('refactoring').refactor('Extract Variable') end },
			{ "<leader>rI",  function() require('refactoring').refactor('Inline Function') end },
			{ "<leader>ri",  function() require('refactoring').refactor('Inline Variable') end },
			{ "<leader>rb",  function() require('refactoring').refactor('Extract Block') end },
			{ "<leader>rbf", function() require('refactoring').refactor('Extract Block To File') end }
		},
		config = function()
			require("refactoring").setup()
		end,
	},

	-- Incremental Rename Plugin
	{
		"smjonas/inc-rename.nvim",
		keys = { { "<leader>rn", ":IncRename " } },
		config = function()
			require("inc_rename").setup()
		end,
	},

	-- Dial Plugin (for increment and decrement)
	{
		"monaqa/dial.nvim",
		keys = {
			{ "<C-a>",  function() require("dial.map").manipulate("increment", "normal") end },
			{ "<C-x>",  function() require("dial.map").manipulate("decrement", "normal") end },
			{ "g<C-a>", function() require("dial.map").manipulate("increment", "gnormal") end },
			{ "g<C-x>", function() require("dial.map").manipulate("decrement", "gnormal") end },
		},
	},

	-- Autopairs Plugin
	{
		'windwp/nvim-autopairs',
		event = "InsertEnter",
		opts = {},
	},

	-- Trouble Plugin (for displaying diagnostics)
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {},
		keys = {
			{ "<leader>xq", "<cmd>TroubleToggle quickfix<cr>", { silent = true, noremap = true } },
		},
	},

	-- Treesitter Plugin (for syntax highlighting)
	-- LSP Zero Plugin (now updated)
	{
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v1.x',
		dependencies = {
			-- LSP Support
			'neovim/nvim-lspconfig',
			'williamboman/mason.nvim',
			'williamboman/mason-lspconfig.nvim',

			-- Autocompletion
			'hrsh7th/nvim-cmp',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'saadparwaiz1/cmp_luasnip',
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-nvim-lua',

			-- Snippets
			'L3MON4D3/LuaSnip',
			'rafamadriz/friendly-snippets',
		},
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup({
				ensure_installed = { 'ts_ls', 'rust_analyzer', 'clangd', 'lua_ls', 'gopls', 'prismals' }
			})

			local lspconfig = require("lspconfig")

			-- LSP Key Mappings
			local on_attach = function(client, bufnr)
				local opts = { buffer = bufnr, remap = false }

				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
				vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
				vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
				vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
				vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
				vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
				vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
				vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
			end

			-- Configure Language Servers
			lspconfig.lua_ls.setup({
				on_attach = on_attach,
				settings = {
					Lua = {
						diagnostics = {
							globals = { 'vim' }
						}
					}
				}
			})

			lspconfig.ts_ls.setup({ on_attach = on_attach })
			lspconfig.rust_analyzer.setup({ on_attach = on_attach })
			lspconfig.clangd.setup({ on_attach = on_attach })
			lspconfig.gopls.setup({ on_attach = on_attach })
			lspconfig.prismals.setup({ on_attach = on_attach })

			-- Completion
			local cmp = require('cmp')
			cmp.setup({
				mapping = {
					['<C-p>'] = cmp.mapping.select_prev_item(),
					['<C-n>'] = cmp.mapping.select_next_item(),
					['<C-y>'] = cmp.mapping.confirm({ select = true }),
					['<C-Space>'] = cmp.mapping.complete(),
				},
				sources = {
					{ name = 'nvim_lsp' },
					{ name = 'buffer' },
					{ name = 'path' },
					{ name = 'luasnip' },
				},
			})

			vim.diagnostic.config({
				virtual_text = true,
			})
		end
	},

	-- Markdown Preview Plugin
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function() vim.fn["mkdp#util#install"]() end,
	},
}
