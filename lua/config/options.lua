-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.snacks_animate = false

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
