return {
	"williamboman/mason.nvim",
	dependencies = { { "williamboman/mason-lspconfig.nvim" } },
	config = function()
		require("mason").setup()
		require("mason-lspconfig").setup({
			ensure_installed = {
				"css_variables",
				"eslint",
				"gopls",
				"lua_ls",
				"omnisharp",
				"pyright",
				"rust_analyzer",
				"sqlls",
				"tailwindcss",
				"ts_ls",
			},
			handlers = {
				lua_ls = function()
					local lua_opts = lsp.nvim_lua_ls()
					require("lspconfig").lua_ls.setup(lua_opts)
				end,
			},
		})
	end,
}
