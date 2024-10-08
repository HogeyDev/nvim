vim.g.mapleader = " "
-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("i", "<C-c>", "<Esc>")

vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>", { silent = true })
vim.keymap.set("n", "<leader>o", ":Neotree focus<CR>", { silent = true })

vim.keymap.set("n", "<leader>ce", ":e ~/.config/nvim/<CR>", { silent = true })
