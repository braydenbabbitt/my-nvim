-- Core keymaps
-- All custom keybindings for the config

-- Set leader key (must be set before loading plugins)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Escape alternatives
vim.keymap.set("v", "<C-space>", "<Esc>", { noremap = true, desc = "Exit visual mode" })
vim.keymap.set("v", "<C-@>", "<Esc>", { noremap = true, desc = "Exit visual mode" })
-- Note: insert mode C-space handled by blink.cmp config

-- Ctrl-c warning (prefer <C-space> to avoid bugs)
vim.keymap.set("i", "<C-c>", function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-c>", true, false, true), "n", true)
  vim.api.nvim_echo({
    {
      "Using <C-c> to exit insert mode should only be used in emergencies.\nUse the custom <C-Space> remap instead to avoid buggy behavior",
      "WarningMsg",
    },
  }, true, {})
end, { noremap = true, desc = "Emergency exit with warning" })

-- Beginning and end of file keymaps
vim.keymap.set("n", "G", "G$", { remap = true, desc = "Go to end of file and line" })
vim.keymap.set("v", "G", "G$", { remap = true, desc = "Go to end of file and line" })
vim.keymap.set("n", "gg", "gg0", { remap = true, desc = "Go to start of file and line" })
vim.keymap.set("v", "gg", "gg0", { remap = true, desc = "Go to start of file and line" })

-- Blackhole register delete (delete without yanking)
vim.keymap.set("n", "<leader>x", '"_x', { noremap = true, silent = true, desc = "Delete char (no yank)" })
vim.keymap.set("v", "<leader>x", '"_x', { noremap = true, silent = true, desc = "Delete selection (no yank)" })
vim.keymap.set("n", "<leader>d", '"_d', { noremap = true, silent = true, desc = "Delete (no yank)" })
vim.keymap.set("v", "<leader>d", '"_d', { noremap = true, silent = true, desc = "Delete (no yank)" })

-- Reset windows and buffers
vim.keymap.set("n", "<leader>R", function()
  if Snacks then
    Snacks.bufdelete.all()
  end
  if vim.fn.winnr("$") > 1 then
    vim.cmd("only")
  end
end, { desc = "Reset Windows and Buffers", remap = true })

-- LSP keymaps
vim.keymap.set("n", "<leader>Lrt", function()
  local servers = { "vtsls", "eslint" }
  for _, name in ipairs(servers) do
    for _, client in pairs(vim.lsp.get_clients({ name = name })) do
      client:stop()
    end
    vim.defer_fn(function()
      vim.cmd("LspStart " .. name)
    end, 3000)
  end
end, { desc = "Restart LSP (vtsls & eslint)", remap = true })

vim.keymap.set("n", "<leader>Li", "<cmd>LspInfo<CR>", { desc = "LSP Info", remap = true })
vim.keymap.set({ "n", "v" }, "<leader>Ll", "<cmd>ToggleLspRoot<CR>", { desc = "Toggle LSP Root Detection", remap = true })
vim.keymap.set("n", "<leader>gd", "gd", { desc = "Go to Definition", remap = true })
vim.keymap.set("n", "<leader>gr", function()
  vim.lsp.buf.references()
end, { desc = "Go to References", remap = true })

-- Code actions
vim.keymap.set("n", "<leader>cu", function()
  vim.lsp.buf.code_action({
    apply = true,
    context = {
      only = { "source.removeUnused" },
      diagnostics = {},
    },
  })
end, { desc = "Remove unused imports" })

-- Diagnostic keymaps (quickfix/loclist)
vim.keymap.set("n", "<leader>Xl", function()
  local success, err = pcall(function()
    if vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 then
      vim.cmd.lclose()
    else
      vim.cmd.lopen()
    end
  end)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = "Toggle Location List" })

vim.keymap.set("n", "<leader>Xq", function()
  local success, err = pcall(function()
    if vim.fn.getqflist({ winid = 0 }).winid ~= 0 then
      vim.cmd.cclose()
    else
      vim.cmd.copen()
    end
  end)
  if not success and err then
    vim.notify(err, vim.log.levels.ERROR)
  end
end, { desc = "Toggle Quickfix List" })

-- Claude terminal keymaps (requires Snacks.nvim)
vim.keymap.set("n", "<leader>aa", function()
  if Snacks then
    Snacks.terminal("claude", { win = { position = "right" } })
  end
end, { desc = "Open Claude in right terminal" })

vim.keymap.set("n", "<leader>at", function()
  if Snacks then
    Snacks.terminal.toggle("claude", { win = { position = "right" } })
  end
end, { desc = "Toggle Claude terminal" })

-- Buffer navigation
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "[b", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
vim.keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })

-- Clear search highlight
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Better indenting
vim.keymap.set("v", "<", "<gv", { desc = "Indent left" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right" })

-- Move lines
vim.keymap.set("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
vim.keymap.set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move line down" })
vim.keymap.set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- Window navigation (skip floating windows to avoid conflicts with terminal apps)
vim.keymap.set("n", "<C-h>", function()
  if vim.api.nvim_win_get_config(0).relative ~= "" then
    return "<C-h>"
  end
  return "<C-w>h"
end, { expr = true, desc = "Go to left window" })

vim.keymap.set("n", "<C-j>", function()
  if vim.api.nvim_win_get_config(0).relative ~= "" then
    return "<C-j>"
  end
  return "<C-w>j"
end, { expr = true, desc = "Go to lower window" })

vim.keymap.set("n", "<C-k>", function()
  if vim.api.nvim_win_get_config(0).relative ~= "" then
    return "<C-k>"
  end
  return "<C-w>k"
end, { expr = true, desc = "Go to upper window" })

vim.keymap.set("n", "<C-l>", function()
  if vim.api.nvim_win_get_config(0).relative ~= "" then
    return "<C-l>"
  end
  return "<C-w>l"
end, { expr = true, desc = "Go to right window" })

-- Window navigation in terminal mode (skip floating windows to avoid conflicts)
vim.keymap.set("t", "<C-h>", function()
  if vim.api.nvim_win_get_config(0).relative ~= "" then
    return "<C-h>"
  end
  return "<cmd>wincmd h<cr>"
end, { expr = true, desc = "Go to left window" })

vim.keymap.set("t", "<C-j>", function()
  if vim.api.nvim_win_get_config(0).relative ~= "" then
    return "<C-j>"
  end
  return "<cmd>wincmd j<cr>"
end, { expr = true, desc = "Go to lower window" })

vim.keymap.set("t", "<C-k>", function()
  if vim.api.nvim_win_get_config(0).relative ~= "" then
    return "<C-k>"
  end
  return "<cmd>wincmd k<cr>"
end, { expr = true, desc = "Go to upper window" })

vim.keymap.set("t", "<C-l>", function()
  if vim.api.nvim_win_get_config(0).relative ~= "" then
    return "<C-l>"
  end
  return "<cmd>wincmd l<cr>"
end, { expr = true, desc = "Go to right window" })

-- Terminal mode escape
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Window management
vim.keymap.set("n", "<leader>ww", "<C-W>p", { desc = "Other window", remap = true })
vim.keymap.set("n", "<leader>wd", "<C-W>c", { desc = "Delete window", remap = true })
vim.keymap.set("n", "<leader>w-", "<C-W>s", { desc = "Split window below", remap = true })
vim.keymap.set("n", "<leader>w|", "<C-W>v", { desc = "Split window right", remap = true })
vim.keymap.set("n", "<leader>-", "<C-W>s", { desc = "Split window below", remap = true })
vim.keymap.set("n", "<leader>|", "<C-W>v", { desc = "Split window right", remap = true })
vim.keymap.set("n", "<leader>wo", "<C-W>o", { desc = "Delete other windows", remap = true })

-- Resize windows
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Quit/Save shortcuts
vim.keymap.set("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

-- Folding keymaps
vim.keymap.set("n", "<leader>za", "za", { desc = "Toggle fold" })
vim.keymap.set("n", "<leader>zc", "zc", { desc = "Close fold" })
vim.keymap.set("n", "<leader>zo", "zo", { desc = "Open fold" })
vim.keymap.set("n", "<leader>zR", "zR", { desc = "Open all folds" })
vim.keymap.set("n", "<leader>zM", "zM", { desc = "Close all folds" })
vim.keymap.set("n", "<leader>zA", "zA", { desc = "Toggle fold recursively" })
vim.keymap.set("n", "<leader>zC", "zC", { desc = "Close fold recursively" })
vim.keymap.set("n", "<leader>zO", "zO", { desc = "Open fold recursively" })

-- Debug command to check terminal buffer settings
vim.api.nvim_create_user_command("TerminalDebug", function()
  local buf = vim.api.nvim_get_current_buf()
  local ft = vim.bo[buf].filetype
  print("Buffer: " .. buf)
  print("Filetype: " .. ft)
  print("\nAutocmds (ExitPre):")
  local autocmds = vim.api.nvim_get_autocmds({ event = "ExitPre", buffer = buf })
  for _, cmd in ipairs(autocmds) do
    print(vim.inspect(cmd))
  end
  print("\nBuffer keymaps:")
  local keymaps = vim.api.nvim_buf_get_keymap(buf, "n")
  for _, map in ipairs(keymaps) do
    if map.lhs:match("q") then
      print(vim.inspect(map))
    end
  end
  print("\nBuffer commands:")
  local commands = vim.api.nvim_buf_get_commands(buf, {})
  for name, cmd in pairs(commands) do
    if name:match("[Qq]") then
      print(name .. ": " .. vim.inspect(cmd))
    end
  end
end, {})
