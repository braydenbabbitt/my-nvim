local helpers = require("tests.helpers")

describe("core.autocmds", function()
  before_each(function()
    helpers.setup()
    -- Clear require cache to reload module
    package.loaded["core.autocmds"] = nil
  end)

  after_each(function()
    helpers.teardown()
  end)

  describe("ESLint auto-fix on save", function()
    it("should create BufWritePre autocmd for JS/TS files", function()
      require("core.autocmds")

      local autocmds = vim.api.nvim_get_autocmds({
        event = "BufWritePre",
        pattern = "*.ts",
      })

      assert.is_true(#autocmds > 0)
    end)
  end)

  describe("highlight on yank", function()
    it("should create TextYankPost autocmd", function()
      require("core.autocmds")

      local autocmds = vim.api.nvim_get_autocmds({
        event = "TextYankPost",
        group = "highlight-yank",
      })

      assert.is_true(#autocmds > 0)
    end)
  end)

  describe("close with q", function()
    it("should create FileType autocmd for special buffers", function()
      require("core.autocmds")

      -- Create a quickfix buffer
      local buf = vim.api.nvim_create_buf(false, true)
      vim.bo[buf].filetype = "qf"

      -- Trigger FileType event
      vim.api.nvim_exec_autocmds("FileType", { pattern = "qf", buffer = buf })

      -- Check that 'q' keymap exists in buffer
      local keymaps = vim.api.nvim_buf_get_keymap(buf, "n")
      local has_q = false
      for _, map in ipairs(keymaps) do
        if map.lhs == "q" then
          has_q = true
          break
        end
      end

      assert.is_true(has_q)
    end)
  end)

  describe("window resize handler", function()
    it("should create VimResized autocmd", function()
      require("core.autocmds")

      local autocmds = vim.api.nvim_get_autocmds({
        event = "VimResized",
        group = "resize_splits",
      })

      assert.is_true(#autocmds > 0)
    end)
  end)

  describe("last location jump", function()
    it("should create BufReadPost autocmd", function()
      require("core.autocmds")

      local autocmds = vim.api.nvim_get_autocmds({
        event = "BufReadPost",
        group = "last_loc",
      })

      assert.is_true(#autocmds > 0)
    end)
  end)

  describe("text wrapping for markdown", function()
    it("should create FileType autocmd for markdown", function()
      require("core.autocmds")

      local autocmds = vim.api.nvim_get_autocmds({
        event = "FileType",
        pattern = "markdown",
      })

      assert.is_true(#autocmds > 0)
    end)
  end)

  describe("snacks terminal fix", function()
    it("should create FileType autocmd for snacks_terminal", function()
      require("core.autocmds")

      local autocmds = vim.api.nvim_get_autocmds({
        event = "FileType",
        pattern = "snacks_terminal",
      })

      assert.is_true(#autocmds > 0)
    end)

    it("should use deferred execution", function()
      local defer_mock = require("tests.helpers.mock").mock_defer_fn()

      require("core.autocmds")

      local buf = vim.api.nvim_create_buf(false, true)
      vim.bo[buf].filetype = "snacks_terminal"

      vim.api.nvim_exec_autocmds("FileType", { pattern = "snacks_terminal", buffer = buf })

      -- Check that defer_fn was called with 100ms delay
      local found_defer = false
      for _, call in ipairs(defer_mock.calls) do
        if call.delay == 100 then
          found_defer = true
          break
        end
      end

      assert.is_true(found_defer)

      defer_mock.restore()
    end)
  end)
end)
