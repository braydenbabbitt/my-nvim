function TerminalNav(direction)
  ---@param self snacks.terminal
  return function(self)
    return self:is_floating() and "<c-" .. direction .. ">"
      or vim.schedule(function()
        vim.cmd.wincmd(direction)
      end)
  end
end
