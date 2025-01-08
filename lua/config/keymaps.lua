-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "<C-`>", function()
  LazyVim.terminal()
end, { desc = "Toggle Root Dir Terminal", remap = true })
vim.keymap.set("t", "<C-`>", "<cmd>close<cr>", { desc = "Hide Terminal", remap = true })
vim.keymap.set("n", "<leader>/", "<leader>sG", { desc = "Grep (cwd)", remap = true })

-- Black hole register for 'x' deletion
vim.keymap.set("n", "x", '"_x')

-- Custom LSP keymaps
vim.keymap.del("n", "<leader>L")
vim.keymap.set("n", "<leader>Lr", "<cmd>LspRestart<CR>", { desc = "Restart LSP", remap = true })
vim.keymap.set("n", "<leader>Li", "<cmd>LspInfo<CR>", { desc = "LSP Info", remap = true })

-- Beginning and end of file keymaps
vim.keymap.set("n", "G", "G$")
vim.keymap.set("n", "gg", "gg0")
vim.keymap.set("v", "G", "G$")
vim.keymap.set("v", "gg", "gg0")
