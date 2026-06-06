vim.g.mapleader = ","

-- toggle relative line numbers
vim.wo.number = true
vim.wo.relativenumber = true -- default to relative numbers on
vim.keymap.set("n", "<C-L><C-L>", function()
	vim.wo.relativenumber = not vim.wo.relativenumber
end)

vim.keymap.set("n", "`", "i")
vim.keymap.set("v", "`", "<ESC>i")

-- word skip on arrow keys
vim.keymap.set("n", "<C-Left>", "b")
vim.keymap.set("n", "<C-Right>", "w")

-- window management keybinds
vim.keymap.set({ "n", "v" }, "<C-q>", "<C-w>", { noremap = true })
vim.keymap.set("i", "<C-q>", "<C-C><C-w>", { noremap = true })

-- delete backward one word
vim.keymap.set("i", "<C-w>", [[<C-\><C-o>"_db]], { noremap = true })
vim.keymap.set("n", "<C-w>", [["_db]], { noremap = true })

-- ctrl+s to save
vim.keymap.set("n", "<C-s>", ":w<CR>")
vim.keymap.set("i", "<C-s>", "<C-C>w<CR>")
vim.keymap.set("v", "<C-s>", "<C-O>w<CR>")

-- undotree stuff
vim.keymap.set("n", "<leader>u", ":UndotreeToggle<CR>")

-- keep terminal centered when searching
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- make paste behave normally
vim.keymap.set("x", "p", [["_dP]])

-- yank into OS clipboard
vim.keymap.set("n", "<leader>y", [["+y]])
vim.keymap.set("v", "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- make delete behave normally
vim.keymap.set("n", "<leader>d", [["_d]])
vim.keymap.set("v", "<leader>d", [["_d]])

-- disable Ex mode
vim.keymap.set("n", "Q", "<nop>")

-- start replacing word we're currently on
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

vim.keymap.set({ "n", "i", "v" }, "<S-Up>", "<Up>")
vim.keymap.set({ "n", "i", "v" }, "<S-Down>", "<Down>")
vim.keymap.set({ "n", "i", "v" }, "<S-Left>", "<Left>")
vim.keymap.set({ "n", "i", "v" }, "<S-Right>", "<Right>")

-- sort stuff
vim.keymap.set("v", "<leader>i", ":'<,'>sort<CR>")

-- very magic search by default
vim.cmd([[nnoremap / /\v\c]])
vim.cmd([[cnoremap %s/ %s/\v\c]])

-- restart LSP
vim.keymap.set("n", "<leader>P", ":lsp restart<CR>")

vim.keymap.set("n", "<F1>", "<nop>")
vim.keymap.set("i", "<F1>", "<nop>")
vim.keymap.set("v", "<F1>", "<nop>")

local function ltrim(s)
	return s:gsub("^%s+", "")
end

local function sensible_home()
	local line = vim.api.nvim_get_current_line()
	local trimmed = ltrim(line)

	local difference = #line - #trimmed

	local line_col_pair = vim.api.nvim_win_get_cursor(0)
	local line_no = line_col_pair[1]
	local col = line_col_pair[2]

	if difference == col then
		vim.api.nvim_win_set_cursor(0, { line_no, 0 })
	else
		vim.api.nvim_win_set_cursor(0, { line_no, difference })
	end
end

-- make home key behave sensibly
vim.keymap.set("n", "<Home>", sensible_home, { desc = "Sensible home" })
vim.keymap.set("i", "<Home>", sensible_home, { desc = "Sensible home" })
