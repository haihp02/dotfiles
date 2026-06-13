vim.g.mapleader = "\\"

local map = vim.keymap.set

-- FZF — primary file navigation
map("n", "<leader>e", "<cmd>FzfLua files<cr>")
map("n", "<leader>f", "<cmd>FzfLua grep<cr>")
map("n", "<leader>b", "<cmd>FzfLua buffers<cr>")

map("n", "Q", "<Nop>")

-- Disable Ctrl+Arrow — tmux can accidentally send these, causing unexpected
-- actions like deleting lines
map({ "n", "i" }, "<C-Up>", "<Nop>")
map({ "n", "i" }, "<C-Down>", "<Nop>")
map({ "n", "i" }, "<C-Left>", "<Nop>")
map({ "n", "i" }, "<C-Right>", "<Nop>")

-- Force hjkl
map("n", "<Left>", '<cmd>echoe "Use h"<cr>')
map("n", "<Right>", '<cmd>echoe "Use l"<cr>')
map("n", "<Up>", '<cmd>echoe "Use k"<cr>')
map("n", "<Down>", '<cmd>echoe "Use j"<cr>')
