local map = vim.keymap.set

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })

-- Keep cursor centered when scrolling
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- Move selected lines up/down in visual mode
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Paste without overwriting the clipboard register
map("x", "p", '"_dP')

-- Helix-like x: select line, then x again extends down
map("n", "x", "V",  { desc = "Select line" })
map("x", "x", "j",  { desc = "Extend line selection down" })

-- Diagnostics (mirrors Helix's [d ]d)
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Diagnostic float" })
