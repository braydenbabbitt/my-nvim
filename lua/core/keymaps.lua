-- Keymaps configuration
local keymap = vim.keymap.set
local opts_nr = { noremap = true, silent = true }
local opts_r = { remap = true, silent = true }

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts_nr)
keymap("n", "<C-j>", "<C-w>j", opts_nr)
keymap("n", "<C-k>", "<C-w>k", opts_nr)
keymap("n", "<C-l>", "<C-w>l", opts_nr)

-- Resize windows with arrows
keymap("n", "<C-Up>", ":resize +2<CR>", opts_nr)
keymap("n", "<C-Down>", ":resize -2<CR>", opts_nr)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts_nr)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts_nr)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts_nr)
keymap("n", "<S-h>", ":bprevious<CR>", opts_nr)

-- Move text up and down
keymap("n", "<A-j>", ":m .+1<CR>==", opts_nr)
keymap("n", "<A-k>", ":m .-2<CR>==", opts_nr)
keymap("v", "<A-j>", ":m '>+1<CR>gv=gv", opts_nr)
keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", opts_nr)

-- Better paste in visual mode (don't overwrite clipboard)
keymap("v", "p", '"_dP', opts_nr)

-- Stay in indent mode
keymap("v", "<", "<gv", opts_nr)
keymap("v", ">", ">gv", opts_nr)

-- Clear search highlighting
keymap("n", "<Esc>", ":noh<CR>", opts_nr)

-- Better up/down (navigate wrapped lines)
keymap({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
keymap({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Custom beginning and end of file keymaps
keymap("n", "G", "G$", opts_r)
keymap("v", "G", "G$", opts_r)
keymap("n", "gg", "gg0", opts_r)
keymap("v", "gg", "gg0", opts_r)

-- Go to definition with leader
keymap("n", "<leader>gd", "gd", { desc = "Go to Definition", remap = true })

-- Ctrl-space as additional key to leave insert mode (visual mode only for now)
keymap("v", "<C-space>", "<Esc>", opts_nr)
keymap("v", "<C-@>", "<Esc>", opts_nr)

-- Ctrl-c warning message
keymap("i", "<C-c>", function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-c>", true, false, true), "n", true)
  vim.api.nvim_echo({
    {
      "Using <C-c> to exit insert mode should only be used in emergencies.\nUse the custom <C-Space> remap instead to avoid buggy behavior",
      "WarningMsg",
    },
  }, true, {})
end, opts_nr)

-- LSP keymaps (will be enhanced when LSP attaches)
keymap("n", "<leader>Li", "<cmd>LspInfo<CR>", { desc = "LSP Info", remap = true })
keymap({ "n", "v" }, "<leader>Ll", "<cmd>ToggleLspRoot<CR>", { desc = "Toggle LSP Root Detection", remap = true })

-- LSP Restart functionality (requires custom function)
keymap("n", "<leader>Lrt", function()
  local servers = { "vtsls", "eslint" }
  for _, name in ipairs(servers) do
    for _, client in pairs(vim.lsp.get_clients({ name = name })) do
      client:stop()
    end
    vim.defer_fn(function()
      vim.cmd("LspStart " .. name)
    end, 3000)
  end
  vim.notify("Restarting vtsls & eslint...", vim.log.levels.INFO)
end, { desc = "Restart LSP (vtsls & eslint)", remap = true })

-- Reset windows and buffers (requires Snacks)
keymap("n", "<leader>R", function()
  -- Will be available when Snacks is loaded
  if Snacks then
    Snacks.bufdelete.all()
    if vim.fn.winnr("$") > 1 then
      vim.cmd("only")
    end
  else
    vim.notify("Snacks not loaded", vim.log.levels.WARN)
  end
end, { desc = "Reset Windows and Buffers", remap = true })

-- Diagnostic lists (toggle location/quickfix)
keymap("n", "<leader>Xl", function()
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

keymap("n", "<leader>Xq", function()
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

-- Claude Code terminal integration (requires Snacks)
keymap("n", "<leader>aa", function()
  if Snacks then
    Snacks.terminal("claude", { win = { position = "right" } })
  else
    vim.notify("Snacks not loaded", vim.log.levels.WARN)
  end
end, { desc = "Open Claude in right terminal" })

keymap("n", "<leader>at", function()
  if Snacks then
    Snacks.terminal.toggle("claude", { win = { position = "right" } })
  else
    vim.notify("Snacks not loaded", vim.log.levels.WARN)
  end
end, { desc = "Toggle Claude terminal" })

-- Blackhole register delete/cut keymaps
keymap("n", "<leader>x", '"_x', { noremap = true, silent = true })
keymap("v", "<leader>x", '"_x', { noremap = true, silent = true })
keymap("n", "<leader>d", '"_d', { noremap = true, silent = true })
keymap("v", "<leader>d", '"_d', { noremap = true, silent = true })

-- Diagnostic keymaps
keymap("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous Diagnostic" })
keymap("n", "]d", vim.diagnostic.goto_next, { desc = "Next Diagnostic" })
keymap("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show Diagnostic" })
keymap("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostic Loclist" })

-- Quick save
keymap("n", "<C-s>", ":w<CR>", opts_nr)
keymap("i", "<C-s>", "<Esc>:w<CR>a", opts_nr)

-- Better escape
keymap("i", "jk", "<ESC>", opts_nr)
keymap("i", "kj", "<ESC>", opts_nr)
