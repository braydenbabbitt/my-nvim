-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Custom LSP keymaps
vim.keymap.del("n", "<leader>L")
vim.keymap.set("n", "<leader>Lr", function()
  local clients = vim.lsp.get_clients()
  local client_names = {}

  -- Collect client names before stopping them
  for _, client in pairs(clients) do
    table.insert(client_names, client.name)
    vim.lsp.stop_client(client.id)
  end

  -- Restart each client by name
  vim.defer_fn(function()
    for _, name in pairs(client_names) do
      vim.cmd("LspStart " .. name)
    end
  end, 500)
end, { desc = "Restart LSP", remap = true })
vim.keymap.set("n", "<leader>Li", "<cmd>LspInfo<CR>", { desc = "LSP Info", remap = true })

-- Beginning and end of file keymaps
vim.keymap.set("n", "G", "G$", { remap = true })
vim.keymap.set("v", "G", "G$", { remap = true })
vim.keymap.set("n", "gg", "gg0", { remap = true })
vim.keymap.set("v", "gg", "gg0", { remap = true })

-- Reset windows and buffers
vim.keymap.set("n", "<leader>R", function()
  Snacks.bufdelete.all()
  if vim.fn.winnr("$") > 1 then
    vim.cmd("only")
  end
end, { desc = "Reset Windows and Buffers", remap = true })

-- Go to definition with leader
vim.keymap.set("n", "<leader>gd", "gd", { desc = "Go to Definition", remap = true })

-- Ctrl-space as additional key to leave insert mode
vim.keymap.set("v", "<C-space>", "<Esc>", { noremap = true })
vim.keymap.set("v", "<C-@>", "<Esc>", { noremap = true })
-- NOTE: this currently has a conflict with blink.cmp config from LazyVim. See plugins/blink.lua to see how we're dealing with that
-- vim.keymap.set("n", "<C-space>", "<Esc>", { noremap = true })
-- vim.keymap.set("n", "<C-@>", "<Esc>", { noremap = true })

-- Ctrl-c to safer keys message/alert
vim.keymap.set("i", "<C-c>", function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-c>", true, false, true), "n", true)
  vim.api.nvim_echo({
    {
      "Using <C-c> to exit insert mode should only be used in emergencies.\nUse the custom <C-Spave> remap instead to avoid buggy behavior",
      "WarningMsg",
    },
  }, true, {})
end, { noremap = true })

vim.keymap.del("n", "<leader>xl")
vim.keymap.del("n", "<leader>xq")
vim.keymap.set("n", "<leader>Xl", function()
  local success, err = pcall(vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = "Location List" })
vim.keymap.set("n", "<leader>Xq", function()
  local success, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = "Quickfix List" })

-- Avante keymaps
vim.keymap.set("n", "<leader>ac", "<cmd>AvanteClear<CR>", { desc = "Clear Avante Chat" })
vim.keymap.set("v", "<leader>ac", "<cmd>AvanteClear<CR>", { desc = "Clear Avante Chat" })
