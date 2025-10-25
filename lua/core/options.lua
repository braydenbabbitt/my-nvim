-- Neovim options configuration
local opt = vim.opt
local g = vim.g

-- Leader key (must be set before lazy.nvim)
g.mapleader = " "
g.maplocalleader = "\\"

-- Disable animations
g.snacks_animate = false

-- UI Options
opt.number = true -- Show line numbers
opt.relativenumber = true -- Show relative line numbers
opt.cursorline = true -- Highlight current line
opt.signcolumn = "yes" -- Always show sign column
opt.termguicolors = true -- True color support
opt.showmode = false -- Don't show mode (lualine shows it)
opt.wrap = false -- No line wrapping
opt.scrolloff = 8 -- Lines to keep above/below cursor
opt.sidescrolloff = 8 -- Columns to keep left/right of cursor

-- Indentation
opt.expandtab = true -- Use spaces instead of tabs
opt.shiftwidth = 2 -- Size of an indent
opt.tabstop = 2 -- Number of spaces tabs count for
opt.softtabstop = 2 -- Number of spaces for <Tab>
opt.smartindent = true -- Smart autoindenting
opt.breakindent = true -- Wrapped lines continue visually indented

-- Search
opt.ignorecase = true -- Ignore case in search
opt.smartcase = true -- Override ignorecase if uppercase in search
opt.hlsearch = true -- Highlight search results
opt.incsearch = true -- Show matches as you type

-- Splits
opt.splitbelow = true -- Horizontal splits go below
opt.splitright = true -- Vertical splits go right

-- Clipboard
opt.clipboard = "unnamedplus" -- Use system clipboard

-- Undo & Backup
opt.undofile = true -- Persistent undo
opt.backup = false -- No backup file
opt.writebackup = false -- No backup before overwrite
opt.swapfile = false -- No swap file

-- Mouse
opt.mouse = "a" -- Enable mouse support

-- Completion
opt.completeopt = "menu,menuone,noselect" -- Completion options
opt.pumheight = 10 -- Max items in popup menu

-- Performance
opt.updatetime = 250 -- Faster completion
opt.timeoutlen = 300 -- Faster key sequence completion

-- Misc
opt.conceallevel = 2 -- Conceal text (useful for markdown)
opt.confirm = true -- Confirm to save changes before exiting
opt.virtualedit = "block" -- Allow cursor beyond end of line in visual block mode
opt.formatoptions = "jcroqlnt" -- Automatic formatting options

-- LSP Root Detection Toggle System
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
