local helpers = require("tests.helpers")
local mock = helpers.mock

describe("LSP integration", function()
  before_each(function()
    helpers.setup()
  end)

  after_each(function()
    helpers.teardown()
  end)

  describe("plugin load", function()
    it("should load lsp plugin spec without errors", function()
      local ok, result = pcall(require, "plugins.lsp")

      assert.is_true(ok, string.format("Failed to load plugins.lsp: %s", result))
      assert.is_not_nil(result, "plugins.lsp returned nil")
    end)
  end)

  -- Note: Testing the actual LSP functions (root_pattern, is_deno_project, start_server)
  -- requires more complex setup with LSP mocking. These functions are defined within
  -- the plugin config closure and are not directly accessible for unit testing.
  -- They will be tested through integration tests when the LSP plugin is actually loaded.
end)
