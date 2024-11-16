return {
	'efueyo/td.nvim',
	'zyedidia/vim-snake',
	'alec-gibson/nvim-tetris',
	'ThePrimeagen/vim-be-good',
	'seandewar/nvimesweeper',
	'alanfortlink/blackjack.nvim',
	{
		'jim-fx/sudoku.nvim',
		cmd = 'Sudoku',
		config = function()
			require('sudoku').setup({})
		end
	}
}


