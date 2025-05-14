-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "<C-`>", function()
  LazyVim.terminal()
end, { desc = "Toggle Root Dir Terminal", remap = true })
vim.keymap.set("t", "<C-`>", "<cmd>close<cr>", { desc = "Hide Terminal", remap = true })
vim.keymap.set("n", "<leader>/", "<leader>sG", { desc = "Grep (cwd)", remap = true })

-- Black hole register for Alt modifier key deletion
vim.keymap.set("n", "<leader>x", '"_x', { noremap = true, silent = true })
vim.keymap.set("v", "<leader>x", '"_x', { noremap = true, silent = true })
vim.keymap.set("n", "<leader>d", '"_d', { noremap = true, silent = true })
vim.keymap.set("v", "<leader>d", '"_x', { noremap = true, silent = true })

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
end, { desc = "Reset Windows and Buffers", remap = true })

-- Go to definition with leader (opens in new buffer)
vim.keymap.set("n", "<leader>gD", "gd", { desc = "Go to Definition (new buffer)", remap = true })
-- Go to definition replacing the current buffer
vim.keymap.set("n", "<leader>gd", function()
  -- Save current window ID
  local current_win = vim.api.nvim_get_current_win()
  -- Save current buffer ID
  local current_buf = vim.api.nvim_get_current_buf()
  -- Get current cursor position
  local cursor_pos = vim.api.nvim_win_get_cursor(current_win)

  -- Store information about the current buffer to allow returning
  vim.w.previous_buffer = {
    bufnr = current_buf,
    cursor = cursor_pos,
  }

  -- Create a command to close the current buffer after we jump
  vim.cmd("augroup GotoDefinitionReplaceBuf")
  vim.cmd("autocmd!")
  vim.cmd(
    "autocmd BufWinEnter * ++once lua if vim.api.nvim_get_current_buf() ~= "
      .. current_buf
      .. " then vim.api.nvim_buf_delete("
      .. current_buf
      .. ", {force = true}) vim.cmd('autocmd! GotoDefinitionReplaceBuf') vim.cmd('augroup! GotoDefinitionReplaceBuf') end"
  )
  vim.cmd("augroup END")

  -- Use LSP to jump to definition
  vim.lsp.buf.definition()
end, { desc = "Go to Definition (replace buffer)", noremap = true })

-- Ctrl-c to safer keys message/alert
vim.keymap.set("i", "<C-c>", function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-c>", true, false, true), "n", true)
  vim.api.nvim_echo({
    {
      -- "Using <C-c> to exit insert mode should only be used in emergencies.\nConsider using <C-[> or <Esc> to avoid buggy behavior.",
      "Using <C-c> to exit insert mode should only be used in emergencies.\nUse the custom <C-Space> remap instead to avoid buggy behavior",
      "WarningMsg",
    },
  }, true, {})
end, { noremap = true })

Snacks.toggle.profiler():map("<leader>Dpp")
Snacks.toggle.profiler_highlights():map("<leader>Dph")

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

-- Use Ctrl+space instead of ESC or Ctrl+[ to save my wrist
vim.keymap.set("v", "<C-space>", "<Esc>", { noremap = true })
vim.keymap.set("v", "<C-@>", "<Esc>", { noremap = true })

-- This currently has a conflict with blink.lua config from LazyVim. See plugins/blink.lua to see how we're dealing with that
-- vim.keymap.set("i", "<C-space>", "<Esc>", { noremap = true })
-- vim.keymap.set("i", "<C-@>", "<Esc>", { noremap = true })

vim.keymap.set("n", "<leader>ac", "<cmd>AvanteClear<CR>", { desc = "Clear Avante Chat" })
vim.keymap.set("v", "<leader>ac", "<cmd>AvanteClear<CR>", { desc = "Clear Avante Chat" })
