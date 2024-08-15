-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "<C-`>", function()
  LazyVim.terminal(nil, { cwd = LazyVim.root() })
end, { desc = "Toggle Root Dir Terminal" })
vim.keymap.set("t", "<C-`>", "<cmd>close<cr>", { desc = "Hide Terminal" })
