return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufWritePost", "BufReadPost", "InsertLeave" },
    config = function()
      local lint = require("lint")

      lint.linters_by_ft = {
        python = { "flake8" },
        javascript = { "eslint" },
        typescript = { "eslint" },
        lua = { "luacheck" },
      }

      local function debounce(ms, fn)
        local timer = vim.uv.new_timer()
        if timer == nil then
          return fn
        end
        return function(...)
          local argv = { ... }
          timer:start(ms, 0, function()
            timer:stop()
            vim.schedule_wrap(fn)(unpack(argv))
          end)
        end
      end

      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        group = lint_augroup,
        callback = debounce(100, function()
          lint.try_lint()
        end),
      })
    end,
  },
}
