describe("plugin loading", function()
  it("should load all plugin specs without errors", function()
    local plugin_files = vim.fn.glob("lua/plugins/*.lua", false, true)

    for _, file in ipairs(plugin_files) do
      local module_name = file:gsub("^lua/", ""):gsub("%.lua$", ""):gsub("/", ".")

      local ok, result = pcall(require, module_name)

      assert.is_true(ok, string.format("Failed to load %s: %s", module_name, result))
      assert.is_not_nil(result, string.format("%s returned nil", module_name))
    end
  end)

  it("should have valid lazy.nvim specs", function()
    local plugin_files = vim.fn.glob("lua/plugins/*.lua", false, true)

    for _, file in ipairs(plugin_files) do
      local module_name = file:gsub("^lua/", ""):gsub("%.lua$", ""):gsub("/", ".")
      local spec = require(module_name)

      -- Spec can be a table or an array of tables
      if type(spec) == "table" then
        if spec[1] then
          -- Array of specs
          for _, s in ipairs(spec) do
            assert.is_table(s, string.format("%s spec should be a table", module_name))
            -- Check for plugin name (first string element or string key)
            local has_plugin_name = type(s[1]) == "string" or type(s.name) == "string"
            assert.is_true(has_plugin_name, string.format("%s spec missing plugin name", module_name))
          end
        else
          -- Single spec
          assert.is_table(spec, string.format("%s spec should be a table", module_name))
        end
      end
    end
  end)
end)
