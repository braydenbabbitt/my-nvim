local M = {}

-- Mock file I/O
function M.mock_file_io()
  local files = {}

  local original_open = io.open
  io.open = function(path, mode)
    mode = mode or "r"

    if mode:match("r") then
      -- Reading
      if files[path] then
        local content = files[path]
        return {
          read = function(_, format)
            if format == "*a" then
              return content
            end
            return nil
          end,
          close = function() end,
        }
      end
      return nil
    elseif mode:match("w") then
      -- Writing
      return {
        write = function(_, data)
          files[path] = data
        end,
        close = function() end,
      }
    end
  end

  return {
    files = files,
    restore = function()
      io.open = original_open
    end,
  }
end

-- Mock vim.fn.executable
function M.mock_executable(executables)
  local original = vim.fn.executable
  vim.fn.executable = function(name)
    if executables[name] ~= nil then
      return executables[name] and 1 or 0
    end
    return 0
  end

  return {
    restore = function()
      vim.fn.executable = original
    end,
  }
end

-- Mock vim.fn.system
function M.mock_system(responses)
  local original = vim.fn.system
  local call_count = {}

  vim.fn.system = function(cmd)
    local key = type(cmd) == "table" and table.concat(cmd, " ") or cmd
    call_count[key] = (call_count[key] or 0) + 1

    if responses[key] then
      local response = responses[key]
      if type(response) == "function" then
        return response(cmd)
      end
      return response
    end
    return ""
  end

  return {
    call_count = call_count,
    restore = function()
      vim.fn.system = original
    end,
  }
end

-- Mock vim.notify
function M.mock_notify()
  local notifications = {}
  local original = vim.notify

  vim.notify = function(msg, level, opts)
    table.insert(notifications, {
      msg = msg,
      level = level,
      opts = opts,
    })
  end

  return {
    notifications = notifications,
    restore = function()
      vim.notify = original
    end,
  }
end

-- Mock vim.fs.find
function M.mock_fs_find(results)
  local original = vim.fs.find

  vim.fs.find = function(pattern, opts)
    local key = pattern
    if results[key] then
      return results[key]
    end
    return {}
  end

  return {
    restore = function()
      vim.fs.find = original
    end,
  }
end

-- Mock vim.defer_fn (execute immediately for testing)
function M.mock_defer_fn()
  local original = vim.defer_fn
  local deferred_calls = {}

  vim.defer_fn = function(fn, delay)
    table.insert(deferred_calls, { fn = fn, delay = delay })
    fn() -- Execute immediately
  end

  return {
    calls = deferred_calls,
    restore = function()
      vim.defer_fn = original
    end,
  }
end

-- Mock vim.fn.stdpath
function M.mock_stdpath(paths)
  local original = vim.fn.stdpath

  vim.fn.stdpath = function(what)
    if paths[what] then
      return paths[what]
    end
    return original(what)
  end

  return {
    restore = function()
      vim.fn.stdpath = original
    end,
  }
end

return M
