local vertical_layout = {
	height = 0.9,
	mirror = true,
	prompt_position = "top",
	preview_height = 0.75,
}

local horizontal_layout = {
	height = 0.9,
	prompt_position = "top",
	preview_width = 0.6,
}

local function calc_preview_size()
	local preview_size = 0.75

	local height = math.floor(vim.o.lines * 0.9)
	local preview_height = math.floor(height * preview_size)
	local list_height = height - preview_height - 8

	-- make list have a minimum height of 20 lines
	if list_height < 20 then
		local derived_preview_height = height - 20 - 7
		return derived_preview_height / height
	end

	return preview_size
end

local function aspect_ratio()
	local width = vim.o.columns
	local height = vim.o.lines * 2
	return width / height
end

local function decorate_config(config)
	vertical_layout.preview_height = calc_preview_size()

	local utils = require("telescope.utils")

	return vim.tbl_deep_extend("force", config, {
		layout_strategy = aspect_ratio() > 1 and "horizontal" or "vertical",
		layout_config = aspect_ratio() > 1 and horizontal_layout or vertical_layout,
		entry_maker = config.group_by and function(entry)
			local line_col = string.format(" %d:%d", tostring(entry.lnum), tostring(entry.col))
			local text = entry.text

			return {
				value = entry,
				ordinal = " " .. entry.text,
				display = function()
					return string.format("%s %s", line_col, text),
						{
							{
								{ 0, #line_col },
								"LineNr",
							},
							{
								{ #line_col + 1, (#line_col + #text + 1) },
								"Normal",
							},
						}
				end,

				bufnr = entry.bufnr,
				filename = entry.filename,
				lnum = entry.lnum,
				col = entry.col,
				text = entry.text,
				start = entry.start,
				finish = entry.finish,
			}
		end,
		group_by = config.group_by and {
			field = "filename",
			header_renderer = function(_, path)
				local tail = utils.path_tail(path)

				local directory = path:sub(0, path:find(tail, 0, true) - 2)
				directory = directory:sub(#vim.fn.getcwd() + 2, #directory)

				return {
					{ string.format("  %s ", tail), "Normal" },
					{ directory, "FFFDirectory" },
				}
			end,
		} or nil,
	})
end

return {
	"bansheerubber/telescope.nvim",
	dependencies = { { "nvim-lua/plenary.nvim", "nvim-telescope/telescope-file-browser.nvim" } },
	lazy = false,
	config = function()
		local builtin = require("telescope.builtin")
		local telescope = require("telescope")

		require("telescope").setup({
			defaults = {
				prompt_prefix = "  ",
				selection_caret = "  ",
				layout_config = {},
			},
			extensions = {
				file_browser = {
					dir_icon = "",
					dir_icon_hl = "Directory",
					git_icons = {
						untracked = "",
						changed = "",
					},
					display_stat = {},
					grouped = true,
					hidden = { file_browser = true, folder_browser = true },
				},
			},
		})

		telescope.load_extension("file_browser")

		vim.keymap.set("n", "<leader>f", function()
			telescope.extensions.file_browser.file_browser(decorate_config({
				sorting_strategy = "ascending",
				path = "%:p:h",
				select_buffer = true,
			}))
		end)

		vim.keymap.set("n", "<leader>a", "<Cmd>Telescope session-lens search_session<CR>")

		vim.keymap.set({ "n", "v" }, "<leader>t", function()
			builtin.lsp_document_symbols(decorate_config({
				ignore_symbols = { "var", "namespace" },
				sorting_strategy = "ascending",
			}))
		end)

		vim.keymap.set("n", "<leader>r", function()
			builtin.lsp_references(decorate_config({
				path_display = { "hidden" },
				sorting_strategy = "ascending",
				group_by = true,
			}))
		end)

		vim.keymap.set("n", "gd", function()
			builtin.lsp_definitions(decorate_config({
				path_display = { "hidden" },
				sorting_strategy = "ascending",
				group_by = true,
			}))
		end)

		vim.api.nvim_create_autocmd("User", {
			pattern = "TelescopePreviewerLoaded",
			callback = function()
				vim.wo.number = true
				vim.opt.tabstop = 2
				vim.opt.shiftwidth = 2
				vim.opt.softtabstop = 2
				vim.opt.expandtab = false
			end,
		})
	end,
}
