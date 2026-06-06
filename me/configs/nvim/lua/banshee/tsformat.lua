---@param bufnr integer
---@param mode "v"|"V"
---@return table {start={row,col}, end={row,col}} using (1, 0) indexing
local function range_from_selection(bufnr, mode)
	-- TODO: Use `vim.fn.getregionpos()` instead.

	-- [bufnum, lnum, col, off]; both row and column 1-indexed
	local start = vim.fn.getpos("v")
	local end_ = vim.fn.getpos(".")
	local start_row = start[2]
	local start_col = start[3]
	local end_row = end_[2]
	local end_col = end_[3]

	-- A user can start visual selection at the end and move backwards
	-- Normalize the range to start < end
	if start_row == end_row and end_col < start_col then
		end_col, start_col = start_col, end_col --- @type integer, integer
	elseif end_row < start_row then
		start_row, end_row = end_row, start_row --- @type integer, integer
		start_col, end_col = end_col, start_col --- @type integer, integer
	end
	if mode == "V" then
		start_col = 1
		local lines = vim.api.nvim_buf_get_lines(bufnr, end_row - 1, end_row, true)
		end_col = #lines[1]
	end
	return {
		["start"] = { start_row, start_col - 1 },
		["end"] = { end_row, end_col - 1 },
	}
end

local function ts_format(ts_client, bufnr)
	---@type lsp.CodeActionParams
	local params

	local mode = vim.api.nvim_get_mode().mode
	local win = vim.api.nvim_get_current_win()
	if mode == "v" or mode == "V" then
		local range = range_from_selection(bufnr, mode)
		params = vim.lsp.util.make_given_range_params(range.start, range["end"], bufnr, ts_client.offset_encoding)
	else
		params = vim.lsp.util.make_range_params(win, ts_client.offset_encoding)
	end

	--- @cast params lsp.CodeActionParams

	local context = {
		only = { "source.organizeImports" },
		diagnostics = {},
		triggerKind = vim.lsp.protocol.CodeActionTriggerKind.Invoked,
	}

	local ns_push = vim.lsp.diagnostic.get_namespace(ts_client.id, false)
	local ns_pull = vim.lsp.diagnostic.get_namespace(ts_client.id, true)
	local diagnostics = {}
	local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
	vim.list_extend(diagnostics, vim.diagnostic.get(bufnr, { namespace = ns_pull, lnum = lnum }))
	vim.list_extend(diagnostics, vim.diagnostic.get(bufnr, { namespace = ns_push, lnum = lnum }))

	params.context = vim.tbl_extend("force", context, {
		---@diagnostic disable-next-line: no-unknown
		diagnostics = vim.tbl_map(function(d)
			return d.user_data.lsp
		end, diagnostics),
	})

	ts_client:request(
		"textDocument/codeAction",
		params,
		---@param result (lsp.Command|lsp.CodeAction)[]|nil
		function(err, result, ctx)
			if err ~= nil then
				print(err.message)
			end

			local function apply_action(action)
				if action.edit then
					vim.lsp.util.apply_workspace_edit(action.edit, ts_client.offset_encoding)
				end
				local a_cmd = action.command
				if a_cmd then
					local command = type(a_cmd) == "table" and a_cmd or action
					--- @cast command lsp.Command
					ts_client:exec_cmd(command, ctx)
				end
			end

			for _, action in pairs(result or {}) do
				apply_action(action)
			end

			vim.lsp.buf.format()
			vim.cmd("write")
		end,
		bufnr
	)
end

return ts_format
