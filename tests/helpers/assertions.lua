local M = {}

-- Assert notification was sent
function M.assert_notified(notifications, pattern, level)
  for _, notif in ipairs(notifications) do
    if notif.msg:match(pattern) then
      if not level or notif.level == level then
        return true
      end
    end
  end
  error(string.format("Expected notification matching '%s' not found", pattern))
end

-- Assert file exists (in mock filesystem)
function M.assert_file_exists(files, path)
  if not files[path] then
    error(string.format("Expected file '%s' to exist", path))
  end
end

-- Assert file contains
function M.assert_file_contains(files, path, pattern)
  M.assert_file_exists(files, path)
  if not files[path]:match(pattern) then
    error(string.format("Expected file '%s' to contain '%s'", path, pattern))
  end
end

-- Assert keymap exists
function M.assert_keymap_exists(mode, lhs)
  local maps = vim.api.nvim_get_keymap(mode)
  for _, map in ipairs(maps) do
    if map.lhs == lhs then
      return true
    end
  end
  error(string.format("Expected keymap '%s' in mode '%s' not found", lhs, mode))
end

return M
