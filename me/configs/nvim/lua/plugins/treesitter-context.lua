local max_lines = 1

return {
	"nvim-treesitter/nvim-treesitter-context",
	config = function()
		local treesitter_context = require("treesitter-context")

		treesitter_context.setup({
			enable = true,
			max_lines = max_lines,
		})

		vim.keymap.set("n", "<leader>c", function()
			if max_lines == 1 then
				max_lines = 0
			else
				max_lines = 1
			end

			treesitter_context.setup({
				enable = true,
				max_lines = max_lines,
			})
		end)
	end,
}
