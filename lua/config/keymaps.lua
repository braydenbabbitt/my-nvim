-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "<C-`>", function()
  LazyVim.terminal()
end, { desc = "Toggle Root Dir Terminal", remap = true })
vim.keymap.set("t", "<C-`>", "<cmd>close<cr>", { desc = "Hide Terminal", remap = true })
vim.keymap.set("n", "<leader>/", "<leader>sG", { desc = "Grep (cwd)", remap = true })

-- Black hole register for Alt modifier key deletion
vim.keymap.set("n", "<M-x>", '"_x', { noremap = true, silent = true })
vim.keymap.set("v", "<M-x>", '"_x', { noremap = true, silent = true })
vim.keymap.set("n", "<M-d>", '"_d', { noremap = true, silent = true })
vim.keymap.set("v", "<M-d>", '"_x', { noremap = true, silent = true })

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
  Snacks.bufdelete.all()
  if vim.fn.winnr("$") > 1 then
    vim.cmd("only")
  end
  vim.cmd("only")
end, { desc = "Reset Windows and Buffers", remap = true })

-- Go to definition with leader
vim.keymap.set("n", "<leader>gd", "gd", { desc = "Go to Definition", remap = true })

-- Ctrl-c to safer keys message/alert
vim.keymap.set("i", "<C-c>", function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-c>", true, false, true), "n", true)
  vim.api.nvim_echo({
    {
      "Using <C-c> to exit insert mode should only be used in emergencies.\nConsider using <C-[> or <Esc> to avoid buggy behavior.",
      "WarningMsg",
    },
  }, true, {})
end, { noremap = true })
