local util = require("lspconfig.util")
local setup_cmp = require("banshee.cmp")
local ts_format = require("banshee.tsformat")

vim.lsp.config("gdscript", {
	port = 6008,
})

vim.lsp.config("css_variables", {
	filetypes = { "css", "scss", "less", "typescriptreact", "typescript" },
})


local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true

vim.lsp.config('*', {
  capabilities = capabilities,
})

vim.o.sessionoptions = "blank,buffers,curdir,help,tabpages,winsize,winpos,terminal,localoptions"

vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "√",
			[vim.diagnostic.severity.HINT] = "∘",
			[vim.diagnostic.severity.INFO] = "∘",
			[vim.diagnostic.severity.WARN] = "∫",
		},
	},
})

function jump_to_diag(diagnostic, line)
	vim.api.nvim_win_set_cursor(0, { diagnostic.lnum + 1, 0 })

	vim.schedule(function()
		vim.diagnostic.open_float({
			scope = "line",
			pos = diagnostic.lnum,
		})
	end)
end

function diag_handler(reverse)
	local current_line = vim.fn.getpos(".")[2]
	local current_buf = vim.api.nvim_get_current_buf()

	local diag_window = -1
	local windows = vim.api.nvim_list_wins()
	for i = 1, #windows do
		local buffer = vim.api.nvim_win_get_buf(windows[i])
		local buffer_contents = vim.api.nvim_buf_get_lines(buffer, 0, 1, false)[1]
		if buffer_contents == "Diagnostics:" then
			diag_window = windows[i]
		end
	end

	if diag_window == -1 and not vim.diagnostic.open_float() then
		local next = vim.diagnostic.get_next()
		if next == nil then
			return
		end

		local prev = vim.diagnostic.get_prev()
		if prev == nil then
			return
		end

		if next.bufnr ~= current_buf and prev.bufnr ~= current_buf then
			return
		end

		local next_dist = math.abs(next.lnum + 1 - current_line)
		local prev_dist = math.abs(prev.lnum + 1 - current_line)

		if prev_dist < next_dist then
			jump_to_diag(prev)
		else
			jump_to_diag(next)
		end
	elseif diag_window ~= -1 then
		vim.api.nvim_win_close(diag_window, true)

		local diagnostics = vim.diagnostic.get(current_buf)

		if reverse then
			for i = #diagnostics, 1, -1 do
				local diagnostic = diagnostics[i]
				if diagnostic.lnum + 1 < current_line then
					jump_to_diag(diagnostic)
					return
				end
			end

			if #diagnostics > 0 then
				local diagnostic = diagnostics[#diagnostics]
				jump_to_diag(diagnostic)
			end
		else
			for i = 1, #diagnostics do
				local diagnostic = diagnostics[i]
				if diagnostic.lnum + 1 > current_line then
					jump_to_diag(diagnostic)
					return
				end
			end

			if #diagnostics > 0 then
				local diagnostic = diagnostics[1]
				jump_to_diag(diagnostic)
			end
		end
	end
end

vim.keymap.set("", "<leader>;", function()
	diag_handler(true)
end, { desc = "Show diag error window (reverse)" })

vim.keymap.set("", "<leader>l", function()
	diag_handler(false)
end, { desc = "Show diag error window" })

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		vim.diagnostic.config({
			virtual_lines = false,
			virtual_text = {
				prefix = "√",
				severity = vim.diagnostic.severity.ERROR,
			},
			update_in_insert = true,
		})

		local opts = { buffer = args.buf, remap = false }

		-- SEE TELESCOPE FOR MORE LSP KEYMAPS

		vim.keymap.set("n", "K", function()
			vim.lsp.buf.hover()
		end, opts)

		vim.keymap.set("n", "<leader>vws", function()
			vim.lsp.buf.workspace_symbol()
		end, opts)

		-- vim.keymap.set("n", "<leader>vd", function() vim.lsp.buf.open_float() end, opts)

		vim.keymap.set("n", "]d", function()
			vim.diagnostic.goto_next()
		end, opts)

		vim.keymap.set("n", "[d", function()
			vim.diagnostic.goto_prev()
		end, opts)

		vim.keymap.set("n", "<leader>.", function()
			vim.lsp.buf.code_action()
		end, opts)

		vim.keymap.set("n", "<leader>n", function()
			vim.lsp.buf.rename()
		end, opts)

		vim.keymap.set("n", "<C-h>", function()
			vim.lsp.buf.signature_help()
		end, opts)

		vim.keymap.set("n", "<leader>j", function()
			local ts_client = util.get_active_client_by_name(args.buf, "ts_ls")
			if ts_client then
				ts_format(ts_client, args.buf)
			else
				vim.lsp.buf.format()
				vim.cmd("write")
			end
		end, opts)

		setup_cmp()

		vim.opt.signcolumn = "yes"
	end,
})
