local helpers = require("tests.helpers")

describe("core.keymaps", function()
  before_each(function()
    helpers.setup()
    -- Clear require cache to reload module
    package.loaded["core.keymaps"] = nil
    package.loaded["core.options"] = nil
    package.loaded["core.aicli"] = nil
  end)

  after_each(function()
    helpers.teardown()
  end)

  describe("leader keys", function()
    it("should set leader to space", function()
      require("core.keymaps")

      assert.are.equal(" ", vim.g.mapleader)
      assert.are.equal(" ", vim.g.maplocalleader)
    end)
  end)

  describe("window navigation", function()
    it("should create window navigation keymaps", function()
      require("core.keymaps")

      helpers.assert.assert_keymap_exists("n", "<C-h>")
      helpers.assert.assert_keymap_exists("n", "<C-j>")
      helpers.assert.assert_keymap_exists("n", "<C-k>")
      helpers.assert.assert_keymap_exists("n", "<C-l>")
    end)
  end)

  describe("diagnostic navigation", function()
    it("should create error navigation keymaps", function()
      require("core.keymaps")

      helpers.assert.assert_keymap_exists("n", "]e")
      helpers.assert.assert_keymap_exists("n", "[e")
    end)
  end)

  describe("quickfix/loclist toggles", function()
    it("should create toggle keymaps", function()
      require("core.keymaps")

      helpers.assert.assert_keymap_exists("n", "<leader>Xl")
      helpers.assert.assert_keymap_exists("n", "<leader>Xq")
    end)
  end)

  describe("AI CLI keymaps", function()
    it("should create AI selection keymap", function()
      require("core.keymaps")

      helpers.assert.assert_keymap_exists("n", "<leader>als")
    end)

    it("should create quick-switch keymaps", function()
      require("core.keymaps")

      helpers.assert.assert_keymap_exists("n", "<leader>alc")
      helpers.assert.assert_keymap_exists("n", "<leader>alg")
      helpers.assert.assert_keymap_exists("n", "<leader>alh")
      helpers.assert.assert_keymap_exists("n", "<leader>alo")
    end)
  end)
end)
