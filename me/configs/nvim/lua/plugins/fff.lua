local function calc_preview_size(terminal_height)
	local preview_size = 0.75

	local height = math.floor(terminal_height * 0.9)
	local preview_height = math.floor(height * preview_size)
	local list_height = height - preview_height - 7

	-- make list have a minimum height of 20 lines
	if list_height < 20 then
		local derived_preview_height = height - 20 - 7
		return derived_preview_height / height
	end

	return preview_size
end

local function aspect_ratio(terminal_width, terminal_height)
	local width = terminal_width
	local height = terminal_height * 2
	return width / height
end

return {
	"dmtrKovalenko/fff.nvim",
	build = function()
		require("fff.download").download_or_build_binary()
	end,
	opts = {
		prompt = "  ",
		layout = {
			prompt_position = "top",
			preview_position = function(terminal_width, terminal_height)
				return aspect_ratio(terminal_width, terminal_height) > 1 and "right" or "bottom"
			end,
			preview_size = function(terminal_width, terminal_height)
				return aspect_ratio(terminal_width, terminal_height) > 1 and 0.6 or calc_preview_size(terminal_height)
			end,
			flex = false,
		},
		preview = {
			line_numbers = true,
		},
		grep = {
			modes = { "plain", "fuzzy", "regex" },
		},
		hl = {
			border = "FFFFloatBorder",
			title = "FFFTitle",
			directory_path = "FFFDirectory",
		},
	},
	lazy = false,
	keys = {
		{
			"<C-p>",
			function()
				require("fff").find_files()
			end,
			desc = "FFFind files",
		},
		{
			"<C-f>",
			function()
				require("fff").live_grep()
			end,
			desc = "LiFFFe grep",
		},
	},
}
