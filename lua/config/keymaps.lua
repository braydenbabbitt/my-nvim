-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "<C-`>", function()
  LazyVim.terminal()
end, { desc = "Toggle Root Dir Terminal", remap = true })
vim.keymap.set("t", "<C-`>", "<cmd>close<cr>", { desc = "Hide Terminal", remap = true })
vim.keymap.set("n", "<leader>/", "<leader>sG", { desc = "Grep (cwd)", remap = true })

-- Black hole register for 'x' deletion
vim.keymap.set("n", "x", '"_x', { noremap = true, silent = true })
vim.keymap.set("v", "x", '"_x', { noremap = true, silent = true })

-- Custom LSP keymaps
vim.keymap.del("n", "<leader>L")
vim.keymap.set("n", "<leader>Lr", "<cmd>LspRestart<CR>", { desc = "Restart LSP", remap = true })
vim.keymap.set("n", "<leader>Li", "<cmd>LspInfo<CR>", { desc = "LSP Info", remap = true })

-- Beginning and end of file keymaps
vim.keymap.set("n", "G", "G$", { remap = true })
vim.keymap.set("n", "gg", "gg0", { remap = true })
vim.keymap.set("v", "G", "G$", { remap = true })
vim.keymap.set("v", "gg", "gg0", { remap = true })

-- Reset windows and buffers
vim.keymap.set("n", "<leader>R", function()
  vim.cmd("bufdo bwipeout")
  vim.cmd("only")
end, { desc = "Reset Windows and Buffers", remap = true })
vim.keymap.set("v", "<leader>R", function()
  vim.cmd("bufdo bwipeout")
  vim.cmd("only")
end, { desc = "Reset Windows and Buffers", remap = true })

-- Go to definition with leader
vim.keymap.set("n", "<leader>gd", "gd", { desc = "Go to Definition", remap = true })

-- Use safer "esc" when attempting to exit insert mode
vim.keymap.set("i", "<C-c>", "<esc>", { remap = true })
