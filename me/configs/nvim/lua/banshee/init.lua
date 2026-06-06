require("banshee.remap")
require("banshee.tabs")
require("banshee.highlight")
require("banshee.lazy")
require("banshee.lsp")

require("os")

vim.opt.scrolloff = 20
vim.opt.colorcolumn = "120"

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

vim.opt.signcolumn = "yes"
vim.opt.updatetime = 500

vim.o.winborder = 'rounded'
