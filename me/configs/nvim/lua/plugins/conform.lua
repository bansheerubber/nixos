return {
	"stevearc/conform.nvim",
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				go = { "goimports", "gofmt" },
				javascript = { "prettier" },
				javascriptreact = { "prettier" },
				typescript = { "prettier" },
				typescriptreact = { "prettier" },
				lua = { "stylua" },
			},
			default_format_opts = {
				lsp_format = "fallback",
			},
			lsp_fallback = true,
		})

		-- vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
		-- vim.o.format = "v:lua.require'conform'.format()"
		vim.lsp.buf.format = conform.format
	end,
}
