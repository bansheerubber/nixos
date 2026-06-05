return {
	"lewis6991/gitsigns.nvim",
	config = function()
		local gitsigns = require("gitsigns")

		gitsigns.setup({
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
				delay = 50,
				ignore_whitespace = false,
			},
		})

		vim.keymap.set("n", "<leader>b", "<Cmd>Gitsigns toggle_current_line_blame<CR>")
		vim.keymap.set("n", "<leader>w", "<Cmd>Gitsigns toggle_word_diff<CR>")
		vim.keymap.set("n", "<leader>e", "<Cmd>Gitsigns toggle_deleted<CR>")

		vim.keymap.set("n", "]g", function() gitsigns.nav_hunk('next') end)
		vim.keymap.set("n", "[g", function() gitsigns.nav_hunk('prev') end)
	end,
}
