-- Utility functions for configuration
local M = {}

-- Store original LazyVim functions
local _original_lazyvim_root_get = nil
local _original_lazyvim_root_cwd = nil

-- Get the appropriate directory based on the global setting
-- If use_root_dir_as_cwd is true, returns the root directory
-- Otherwise returns the current working directory
function M.get_cwd()
  if vim.g.always_use_cwd then
    return vim.fn.getcwd()
  else
    return LazyVim.root.get()
  end
end

-- Toggle the use_root_dir_as_cwd setting
function M.toggle_always_use_cwd()
  vim.g.always_use_cwd = not vim.g.always_use_cwd
  local status = vim.g.always_use_cwd and "enabled" or "disabled"
  vim.notify("Always use CWD instead of Root Dir set to: " .. status, vim.log.levels.INFO)

  -- Apply the override after toggling
  M.apply_root_override()
end

-- Get the status of the use_root_dir_as_cwd setting
function M.get_always_user_cwd_status()
  return vim.g.always_use_cwd and "Always Use CWD" or "Normal Root Dir Behavior"
end

-- Override LazyVim's root detection to respect our global setting
function M.apply_root_override()
  -- Wait for LazyVim to be loaded
  vim.defer_fn(function()
    if LazyVim and LazyVim.root then
      -- Store originals if not already stored
      if not _original_lazyvim_root_get then
        _original_lazyvim_root_get = LazyVim.root.get
        _original_lazyvim_root_cwd = LazyVim.root.cwd
      end

      -- Override LazyVim.root.cwd function
      LazyVim.root.cwd = function()
        if vim.g.always_use_cwd then
          return vim.fn.getcwd()
        else
          return _original_lazyvim_root_get()
        end
      end

      -- Override any getcwd calls within LazyVim plugins when our setting is enabled
      local original_getcwd = vim.fn.getcwd
      vim.fn.getcwd = function(...)
        if not vim.g.always_use_cwd then
          -- Check if we're being called from a LazyVim context
          local info = debug.getinfo(2, "S")
          if
            info
            and info.source
            and (info.source:match("lazy") or info.source:match("telescope") or info.source:match("neo%-tree"))
          then
            return _original_lazyvim_root_get()
          end
        end
        return original_getcwd(...)
      end
    end
  end, 100)
end

return M
