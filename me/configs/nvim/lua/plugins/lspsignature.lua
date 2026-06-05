return {
	"ray-x/lsp_signature.nvim",
	config = function()
		require("lsp_signature").setup({
			doc_lines = 0, -- TODO add keybind that toggles docs
			handler_opts = {
				border = "single",
			},
			hint_enable = false,
		})
	end,
}
