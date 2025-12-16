local helpers = require("tests.helpers")

describe("core.options", function()
  before_each(function()
    helpers.setup()
    -- Clear require cache to reload module
    package.loaded["core.options"] = nil
    package.loaded["core.aicli"] = nil
  end)

  after_each(function()
    helpers.teardown()
  end)

  describe("HasLspInRootSpec", function()
    it("should return false when root_spec is empty", function()
      vim.g.root_spec = {}
      require("core.options")

      assert.is_false(HasLspInRootSpec())
    end)

    it("should return true when lsp is in root_spec", function()
      vim.g.root_spec = { ".git", "lsp", "package.json" }
      require("core.options")

      assert.is_true(HasLspInRootSpec())
    end)

    it("should return false when lsp is not in root_spec", function()
      vim.g.root_spec = { ".git", "package.json" }
      require("core.options")

      assert.is_false(HasLspInRootSpec())
    end)
  end)

  describe("ToggleLspRootSpec", function()
    it("should add lsp to root_spec when enable=true", function()
      vim.g.root_spec = { ".git" }
      require("core.options")

      ToggleLspRootSpec(true, false)

      local spec = vim.g.root_spec
      assert.are.equal("lsp", spec[1])
      assert.are.equal(".git", spec[2])
    end)

    it("should remove lsp from root_spec when enable=false", function()
      vim.g.root_spec = { "lsp", ".git" }
      require("core.options")

      ToggleLspRootSpec(false, false)

      local spec = vim.g.root_spec
      assert.are.equal(1, #spec)
      assert.are.equal(".git", spec[1])
    end)

    it("should toggle lsp when enable is nil", function()
      vim.g.root_spec = { ".git" }
      require("core.options")

      -- First toggle should add
      ToggleLspRootSpec(nil, false)
      assert.is_true(HasLspInRootSpec())

      -- Second toggle should remove
      ToggleLspRootSpec(nil, false)
      assert.is_false(HasLspInRootSpec())
    end)

    it("should notify when should_notify=true", function()
      local notify_mock = require("tests.helpers.mock").mock_notify()
      vim.g.root_spec = {}
      require("core.options")

      ToggleLspRootSpec(true, true)

      helpers.assert.assert_notified(notify_mock.notifications, "LSP added", vim.log.levels.INFO)
      notify_mock.restore()
    end)

    it("should not notify when should_notify=false", function()
      local notify_mock = require("tests.helpers.mock").mock_notify()
      vim.g.root_spec = {}
      require("core.options")

      ToggleLspRootSpec(true, false)

      assert.are.equal(0, #notify_mock.notifications)
      notify_mock.restore()
    end)

    it("should handle middle position of lsp correctly", function()
      vim.g.root_spec = { ".git", "lsp", "package.json" }
      require("core.options")

      ToggleLspRootSpec(false, false)

      local spec = vim.g.root_spec
      assert.are.equal(2, #spec)
      assert.are.equal(".git", spec[1])
      assert.are.equal("package.json", spec[2])
    end)
  end)

  describe("ToggleLspRoot command", function()
    it("should create user command", function()
      require("core.options")

      local commands = vim.api.nvim_get_commands({})
      assert.is_not_nil(commands.ToggleLspRoot)
    end)
  end)

  describe("vim options", function()
    it("should set expected vim options", function()
      require("core.options")

      assert.is_true(vim.opt.number:get())
      assert.is_true(vim.opt.relativenumber:get())
      assert.are.equal("a", vim.opt.mouse:get())
      assert.are.equal("unnamedplus", vim.opt.clipboard:get())
      assert.are.equal(2, vim.opt.shiftwidth:get())
      assert.are.equal(10, vim.opt.scrolloff:get())
    end)

    it("should disable snacks animation", function()
      require("core.options")

      assert.is_false(vim.g.snacks_animate)
    end)
  end)
end)
