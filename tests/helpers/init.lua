local M = {}

-- Load all helper modules
M.mock = require("tests.helpers.mock")
M.assert = require("tests.helpers.assertions")

-- Setup function to run before each test
function M.setup()
  -- Reset vim state
  vim.api.nvim_exec2("silent! %bwipeout!", {})

  -- Clear autocommands
  vim.api.nvim_exec2("autocmd!", {})

  -- Reset keymaps
  vim.api.nvim_exec2("mapclear", {})
  vim.api.nvim_exec2("mapclear!", {})

  -- Clear global variables
  for k, _ in pairs(vim.g) do
    if type(k) == "string" and not k:match("^loaded_") then
      vim.g[k] = nil
    end
  end
end

-- Teardown function
function M.teardown()
  M.setup() -- Reset state
end

-- Helper to create temp files
function M.create_temp_file(content)
  local tmpfile = vim.fn.tempname()
  local f = io.open(tmpfile, "w")
  if f then
    f:write(content or "")
    f:close()
  end
  return tmpfile
end

-- Helper to wait for async operations
function M.wait_for(fn, timeout)
  timeout = timeout or 1000
  local start = vim.loop.now()
  while vim.loop.now() - start < timeout do
    if fn() then
      return true
    end
    vim.wait(10)
  end
  return false
end

return M
