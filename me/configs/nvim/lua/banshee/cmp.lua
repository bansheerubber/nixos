local cmp = require("cmp")

function setup_cmp()
	cmp.setup.cmdline({
		mapping = {
			["<C-e>"] = {
				i = cmp.mapping.confirm({
					behavior = cmp.ConfirmBehavior.Replace,
					select = true,
				}),
				c = cmp.mapping.confirm({
					behavior = cmp.ConfirmBehavior.Replace,
					select = true,
				}),
			},
			["<CR>"] = {
				i = cmp.config.disable,
				c = cmp.config.disable,
			},
			["<Tab>"] = {
				i = cmp.mapping.disable,
				c = cmp.mapping.disable,
			},
		},
	})

	cmp.setup({
		mapping = cmp.mapping.preset.insert({
			["<C-e>"] = {
				i = cmp.mapping.confirm({
					behavior = cmp.ConfirmBehavior.Replace,
					select = true,
				}),
				c = cmp.mapping.confirm({
					behavior = cmp.ConfirmBehavior.Replace,
					select = true,
				}),
			},
			["<C-Space>"] = {
				i = cmp.mapping.abort(),
				c = cmp.mapping.abort(),
			},
			["<CR>"] = {
				i = cmp.config.disable,
				c = cmp.config.disable,
			},
			["<Tab>"] = {
				i = cmp.mapping.disable,
				c = cmp.mapping.disable,
			},
		}),
		preselect = cmp.PreselectMode.None,
		formatting = {
			fields = { "menu", "abbr", "kind" },
			format = function(entry, item)
				local menu_icon = {
					copilot = "₹",
					nvim_lsp_signature_help = "∢",
					nvim_lsp = "∿",
					nvim_lua = "⅂",
					buffer = "∀",
					path = "∃",
				}

				local kinds = {
					Text = " text",
					Method = "methd",
					Function = " func",
					Constructor = "cnruc",
					Field = "field",
					Variable = "  var",
					Class = "class",
					Interface = "intrf",
					Module = "  mod",
					Property = " prop",
					Unit = " unit",
					Value = "  val",
					Enum = " enum",
					Keyword = "kywrd",
					Snippet = " snip",
					Color = "color",
					File = " file",
					Reference = "  ref",
					Folder = "foldr",
					EnumMember = "varnt",
					Constant = "const",
					Struct = "strct",
					Event = "evnet",
					Operator = "oprtr",
					TypeParameter = " type",
				}

				item.kind = kinds[item.kind]
				item.menu = menu_icon[entry.source.name]

				return item
			end,
		},
		sources = {
			{ name = "nvim_lsp" },
			{ name = "nvim_lua" },
			-- { name = 'copilot', },
			{ name = "buffer" },
			{ name = "path" },
		},
		window = {
			completion = {
				winhighlight = "Normal:CmpNormal,FloatBorder:CmpFloatBorder,CursorLine:CmpCursorLine,Search:CmpSearch",
			},
			documentation = {
				border = false,
				winhighlight = "Normal:CmpDocNormal,FloatBorder:CmpDocFloatBorder",
			},
		},
	})
end

return setup_cmp
