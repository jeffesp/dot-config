local o = vim.opt

o.number = true
o.relativenumber = false
o.signcolumn = "yes"
o.cursorline = true
o.termguicolors = true
o.scrolloff = 8

o.tabstop = 4
o.shiftwidth = 4
o.expandtab = true
o.smartindent = true

o.wrap = false
o.splitright = true
o.splitbelow = true

o.ignorecase = true
o.smartcase = true

o.undofile = true
o.swapfile = false
o.updatetime = 250
o.timeoutlen = 300

o.mouse = "a"
o.clipboard = "unnamedplus"

vim.diagnostic.config({
	severity_sort = true,
	signs = true,
	underline = true,
	virtual_text = { prefix = "●", source = "if_many" },
	float = { border = "rounded", source = true },
})
