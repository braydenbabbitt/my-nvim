-- Core Neovim options
-- Sets up all vim options and global variables

-- Disable snacks animation
vim.g.snacks_animate = false

-- Disable bracketed paste
vim.cmd("set t_BE=")

-- Basic editor settings
vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = true -- Show relative line numbers
vim.opt.mouse = "a" -- Enable mouse support
vim.opt.clipboard = "unnamedplus" -- Use system clipboard
vim.opt.breakindent = true -- Preserve indent on wrapped lines
vim.opt.undofile = true -- Enable persistent undo
vim.opt.ignorecase = true -- Case insensitive search
vim.opt.smartcase = true -- Case sensitive when using capitals
vim.opt.signcolumn = "yes" -- Always show sign column
vim.opt.updatetime = 250 -- Decrease update time
vim.opt.timeoutlen = 300 -- Decrease timeout length
vim.opt.splitright = true -- Vertical splits go right
vim.opt.splitbelow = true -- Horizontal splits go below
vim.opt.list = true -- Show whitespace characters
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.inccommand = "split" -- Preview substitutions live
vim.opt.cursorline = true -- Highlight current line
vim.opt.scrolloff = 10 -- Minimal lines to keep above/below cursor
vim.opt.hlsearch = true -- Highlight search results
vim.opt.cmdheight = 0 -- Hide command line when not in use
vim.opt.laststatus = 3 -- Global statusline

-- Tab settings
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.shiftwidth = 2 -- Size of indent
vim.opt.tabstop = 2 -- Number of spaces tabs count for
vim.opt.softtabstop = 2 -- Number of spaces for tab in insert mode

-- Text wrapping settings (disabled by default, enabled for specific filetypes)
vim.opt.wrap = false -- Disable line wrapping by default

-- Folding settings
vim.opt.foldmethod = "expr" -- Use expression for folding
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- Use treesitter for folding
vim.opt.foldlevel = 99 -- Open all folds by default
vim.opt.foldlevelstart = 99 -- Start with all folds open
vim.opt.foldenable = true -- Enable folding

-- AI settings
vim.g.aicli = "claude"

-- LSP root detection configuration
-- Helper function to check if LSP is in root_spec
function HasLspInRootSpec()
  local spec = vim.g.root_spec or {}
  for _, v in ipairs(spec) do
    if v == "lsp" then
      return true
    end
  end
  return false
end

-- Function to toggle or set LSP in root_spec
function ToggleLspRootSpec(enable, should_notify)
  -- Default should_notify to false if not provided
  if should_notify == nil then
    should_notify = false
  end

  local spec = vim.g.root_spec or {}
  local has_lsp = HasLspInRootSpec()
  local lsp_index = nil

  -- Find the index if LSP exists (needed for removal)
  if has_lsp then
    for i, v in ipairs(spec) do
      if v == "lsp" then
        lsp_index = i
        break
      end
    end
  end

  -- If enable is explicitly provided, use it; otherwise toggle
  local should_have_lsp
  if enable ~= nil then
    should_have_lsp = enable
  else
    should_have_lsp = not has_lsp
  end

  if should_have_lsp and not has_lsp then
    -- Add "lsp" to spec (at the beginning for higher priority)
    table.insert(spec, 1, "lsp")
    if should_notify then
      vim.notify("LSP added to root detection", vim.log.levels.INFO)
    end
  elseif not should_have_lsp and has_lsp then
    -- Remove "lsp" from spec
    table.remove(spec, lsp_index)
    if should_notify then
      vim.notify("LSP removed from root detection", vim.log.levels.INFO)
    end
  end

  vim.g.root_spec = spec
end

-- Remove LSP from root_spec on initial load if it exists
if HasLspInRootSpec() then
  ToggleLspRootSpec(false)
end

-- Create a user command for easy access
vim.api.nvim_create_user_command("ToggleLspRoot", function(opts)
  local enable = nil
  if opts.args ~= "" then
    enable = opts.args == "true" or opts.args == "1"
  end
  ToggleLspRootSpec(enable, true)
end, {
  nargs = "?",
  complete = function()
    return { "true", "false" }
  end,
})
