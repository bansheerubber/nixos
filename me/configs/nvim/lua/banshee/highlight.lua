vim.wo.cursorline = true
vim.wo.cursorlineopt = "number"

vim.api.nvim_set_hl(0, "CursorLineNR", { ctermfg = "magenta" })
vim.api.nvim_set_hl(0, "LineNR", { ctermfg = "grey" })
