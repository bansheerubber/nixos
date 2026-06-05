return {
	"luukvbaal/statuscol.nvim",
	config = function()
		local builtin = require("statuscol.builtin")

		local ffi = require("ffi")
		ffi.cdef([[
	int next_namespace_id;
	uint64_t display_tick;
	typedef struct {} Error;
	typedef struct {} win_T;
	typedef struct {
		int start;  // line number where deepest fold starts
		int level;  // fold level, when zero other fields are N/A
		int llevel; // lowest level that starts in v:lnum
		int lines;  // number of lines from v:lnum to end of closed fold
	} foldinfo_T;
	foldinfo_T fold_info(win_T* wp, int lnum);
	win_T *find_window_by_handle(int Window, Error *err);
	int compute_foldcolumn(win_T *wp, int col);
	int win_col_off(win_T *wp);
]])

		local function get_num_wraps()
			-- Calculate the actual buffer width, accounting for splits, number columns, and other padding
			local wrapped_lines = vim.api.nvim_win_call(0, function()
				local winid = vim.api.nvim_get_current_win()

				-- get the width of the buffer
				local winwidth = vim.api.nvim_win_get_width(winid)
				local numberwidth = vim.wo.number and vim.wo.numberwidth or 0
				local signwidth = vim.fn.exists("*sign_define") == 1 and vim.fn.sign_getdefined() and 2 or 0
				local foldwidth = vim.wo.foldcolumn or 0

				-- subtract the number of empty spaces in your statuscol. I have
				-- four extra spaces in mine, to enhance readability for me
				local bufferwidth = winwidth - numberwidth - signwidth - foldwidth - 4

				-- fetch the line and calculate its display width
				local line = vim.fn.getline(vim.v.lnum)
				local line_length = vim.fn.strdisplaywidth(line)

				return math.floor(line_length / bufferwidth)
			end)

			return wrapped_lines
		end

		function char_on_pos(pos)
			pos = pos or vim.fn.getpos(".")
			return tostring(vim.fn.getline(pos[1])):sub(pos[2], pos[2])
		end

		function char_byte_count(s, i)
			if not s or s == "" then
				return 1
			end

			local char = string.byte(s, i or 1)

			-- Get byte count of unicode character (RFC 3629)
			if char > 0 and char <= 127 then
				return 1
			elseif char >= 194 and char <= 223 then
				return 2
			elseif char >= 224 and char <= 239 then
				return 3
			elseif char >= 240 and char <= 244 then
				return 4
			end
		end

		function get_visual_range()
			local sr, sc = unpack(vim.fn.getpos("v"), 2, 3)
			local er, ec = unpack(vim.fn.getpos("."), 2, 3)

			-- To correct work with non-single byte chars
			local byte_c = char_byte_count(char_on_pos({ er, ec }))
			ec = ec + (byte_c - 1)

			local range = {}

			if sr == er then
				local cols = sc >= ec and { ec, sc } or { sc, ec }
				range = { sr, cols[1] - 1, er, cols[2] }
			elseif sr > er then
				range = { er, ec - 1, sr, sc }
			else
				range = { sr, sc - 1, er, ec }
			end

			return range
		end

		function is_open_fold(args)
			local foldinfo = ffi.C.fold_info(args.wp, args.lnum)
			return foldinfo.start == args.lnum
		end

		function is_closed_fold(args)
			local foldinfo = ffi.C.fold_info(args.wp, args.lnum)
			return foldinfo.lines > 0
		end

		vim.opt.signcolumn = "yes"

		require("statuscol").setup({
			clickhandlers = { -- builtin click handlers
				Lnum = builtin.lnum_click,
				FoldClose = builtin.foldclose_click,
				FoldOpen = builtin.foldopen_click,
				FoldOther = builtin.foldother_click,
				DapBreakpointRejected = builtin.toggle_breakpoint,
				DapBreakpoint = builtin.toggle_breakpoint,
				DapBreakpointCondition = builtin.toggle_breakpoint,
				["diagnostic/signs"] = builtin.diagnostic_click,
				gitsigns = builtin.gitsigns_click,
			},
			segments = {
				{ text = { "%s" }, click = "v:lua.ScSa" },
				{
					text = {
						function(args)
							local mode = vim.fn.strtrans(vim.fn.mode()):lower():gsub("%W", "")
							if mode == "v" then
								local v_range = get_visual_range()
								local is_in_range = vim.v.lnum >= v_range[1] and vim.v.lnum <= v_range[3]
								return is_in_range and "%#CursorLineNr#" or ""
							end

							return ""
						end,
					},
					condition = {
						function()
							local mode = vim.fn.strtrans(vim.fn.mode()):lower():gsub("%W", "")
							return mode == "v"
						end,
					},
				},
				{
					text = {
						function(args)
							if vim.v.virtnum < 0 then
								return "%=-"
							elseif vim.v.virtnum > 0 and (vim.wo.number or vim.wo.relativenumber) then
								local num_wraps = get_num_wraps()

								if vim.v.virtnum == num_wraps then
									return "%=┗"
								else
									return "%=┣"
								end
							end

							if is_closed_fold(args) then
								return "%=%#FoldedLineNr#fold%*"
							end

							return require("statuscol.builtin").lnumfunc(args)
						end,
						" ",
					},
				},
			},
		})
	end,
}
