return {
	"nvim-lualine/lualine.nvim",
	config = function()
		local colors = {
			background = "#1B121F",
			foreground = "#D3C6D3",
		}

		local theme = {
			normal = {
				a = { bg = colors.background, gui = "bold" },
				b = { bg = colors.background, fg = colors.foreground },
				c = { bg = colors.background, fg = colors.foreground },
			},
			insert = {
				a = { bg = colors.background, gui = "bold" },
				b = { bg = colors.background, fg = colors.foreground },
				c = { bg = colors.background, fg = colors.foreground },
			},
			visual = {
				a = { bg = colors.background, gui = "bold" },
				b = { bg = colors.background, fg = colors.foreground },
				c = { bg = colors.background, fg = colors.foreground },
			},
			replace = {
				a = { bg = colors.background, gui = "bold" },
				b = { bg = colors.background, fg = colors.foreground },
				c = { bg = colors.background, fg = colors.foreground },
			},
			command = {
				a = { bg = colors.background, gui = "bold" },
				b = { bg = colors.background, fg = colors.foreground },
				c = { bg = colors.background, fg = colors.foreground },
			},
			inactive = {
				a = { bg = colors.background, gui = "bold" },
				b = { bg = colors.background, fg = colors.foreground },
				c = { bg = colors.background, fg = colors.foreground },
			},
		}

		local lualine_a = { {
			"mode",
			fmt = function(str)
				return str:lower()
			end,
		} }

		local branch = {
			"branch",
			fmt = function(str)
				if str == "" then
					return ""
				end

				if #str > 35 then
					str = str:sub(1, 15) .. "..." .. str:sub(#str - 15, #str)
				end

				return " " .. str
			end,
		}

		local diff = "diff"

		local diagnostics = {
			"diagnostics",
			symbols = {
				error = "√",
				hint = "∘",
				info = "∘",
				warn = "∫",
			},
		}

		local lualine_b = { branch, diff, diagnostics }

		local lualine_c = {
			{
				"filename",
				path = 1,
				symbols = {
					modified = "≈",
					readonly = "∿",
					unnamed = "no name",
					newfile = "new file",
				},
			},
		}

		local lualine_x = {
			"encoding",
			{
				"fileformat",
				fmt = function(str)
					if str == "unix" then
						return "lf"
					elseif str == "mac" then
						return "cr"
					elseif str == "dos" then
						return "crlf"
					end

					return str
				end,
			},
			"filetype",
		}

		local lualine_y = { "searchcount" }

		require("lualine").setup({
			options = {
				icons_enabled = false,
				component_separators = { left = "|", right = "|" },
				section_separators = { left = "", right = "" },
				theme = theme,
				refresh = {
					statusline = 100,
				},
			},
			sections = {
				lualine_a = lualine_a,
				lualine_b = lualine_b,
				lualine_c = lualine_c,
				lualine_x = lualine_x,
				lualine_y = lualine_y,
				lualine_z = {},
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = { diff, diagnostics },
				lualine_c = lualine_c,
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
		})
	end,
}
