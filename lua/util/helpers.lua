-- Helper functions for the configuration
local M = {}

-- Get the foreground color of a highlight group
function M.get_hl_fg(name)
  local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
  if hl.fg then
    return string.format("#%06x", hl.fg)
  end
  return nil
end

-- Get the background color of a highlight group
function M.get_hl_bg(name)
  local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
  if hl.bg then
    return string.format("#%06x", hl.bg)
  end
  return nil
end

-- Get all colors from a highlight group
function M.get_hl(name)
  local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
  local result = {}

  if hl.fg then
    result.fg = string.format("#%06x", hl.fg)
  end

  if hl.bg then
    result.bg = string.format("#%06x", hl.bg)
  end

  if hl.bold then
    result.bold = true
  end

  if hl.italic then
    result.italic = true
  end

  return result
end

-- Detect project root directory
function M.get_root_dir()
  local root_patterns = { ".git", "package.json", "deno.json", "Cargo.toml", "go.mod", "pyproject.toml" }
  local path = vim.api.nvim_buf_get_name(0)

  if path == "" then
    return vim.fn.getcwd()
  end

  local root = vim.fs.dirname(path)

  for _, pattern in ipairs(root_patterns) do
    local found = vim.fs.find(pattern, {
      path = root,
      upward = true,
    })

    if #found > 0 then
      return vim.fs.dirname(found[1])
    end
  end

  return vim.fn.getcwd()
end

-- Shorten path intelligently
function M.pretty_path(opts)
  opts = opts or {}
  local path = vim.api.nvim_buf_get_name(0)

  if path == "" then
    return "[No Name]"
  end

  -- For special buffers
  local buftype = vim.bo.buftype
  if buftype == "terminal" then
    return "Terminal"
  elseif buftype == "help" then
    return "Help"
  elseif buftype == "quickfix" then
    return "Quickfix"
  end

  -- Get relative path from root
  local root = M.get_root_dir()
  local relative = vim.fn.fnamemodify(path, ":~:.")

  if vim.startswith(path, root) then
    relative = path:sub(#root + 2)
  end

  return relative
end

-- Check if a plugin is loaded
function M.has(plugin)
  return require("lazy.core.config").spec.plugins[plugin] ~= nil
end

return M
