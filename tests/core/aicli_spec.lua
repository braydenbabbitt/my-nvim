local helpers = require("tests.helpers")
local mock = helpers.mock

describe("core.aicli", function()
  local aicli
  local state_file

  before_each(function()
    helpers.setup()

    -- Mock state file path
    state_file = "/tmp/test_aicli.json"

    -- Clear require cache to reload module
    package.loaded["core.aicli"] = nil

    -- Mock vim.fn.stdpath to return test path
    _G.original_stdpath = vim.fn.stdpath
    vim.fn.stdpath = function(what)
      if what == "data" then
        return "/tmp"
      end
      return _G.original_stdpath(what)
    end
  end)

  after_each(function()
    -- Restore stdpath
    if _G.original_stdpath then
      vim.fn.stdpath = _G.original_stdpath
      _G.original_stdpath = nil
    end
    helpers.teardown()
  end)

  describe("load_state", function()
    it("should return default state when file doesn't exist", function()
      local file_io = mock.mock_file_io()

      aicli = require("core.aicli")
      local current = aicli.get_current_tool()

      assert.are.equal("opencode", current)
      file_io.restore()
    end)

    it("should load state from valid JSON file", function()
      local file_io = mock.mock_file_io()
      file_io.files[state_file] = '{"selected_tool":"claude","last_updated":"2024-01-01T00:00:00"}'

      aicli = require("core.aicli")
      local current = aicli.get_current_tool()

      assert.are.equal("claude", current)
      file_io.restore()
    end)

    it("should return default state and warn when JSON is corrupted", function()
      local file_io = mock.mock_file_io()
      local notify_mock = mock.mock_notify()

      file_io.files[state_file] = "{invalid json}"

      aicli = require("core.aicli")
      local current = aicli.get_current_tool()

      assert.are.equal("opencode", current)
      helpers.assert.assert_notified(notify_mock.notifications, "corrupted", vim.log.levels.WARN)

      file_io.restore()
      notify_mock.restore()
    end)

    it("should validate selected_tool exists in CLI_TOOLS", function()
      local file_io = mock.mock_file_io()
      local notify_mock = mock.mock_notify()

      file_io.files[state_file] = '{"selected_tool":"unknown_tool"}'

      aicli = require("core.aicli")
      local current = aicli.get_current_tool()

      assert.are.equal("opencode", current)
      helpers.assert.assert_notified(notify_mock.notifications, "Unknown AI CLI tool", vim.log.levels.WARN)

      file_io.restore()
      notify_mock.restore()
    end)
  end)

  describe("save_state", function()
    it("should save state to JSON file with timestamp", function()
      local file_io = mock.mock_file_io()
      local exec_mock = mock.mock_executable({ claude = true })

      aicli = require("core.aicli")
      aicli.set_current_tool("claude") -- This will trigger save_state

      helpers.assert.assert_file_exists(file_io.files, state_file)
      helpers.assert.assert_file_contains(file_io.files, state_file, '"selected_tool":"claude"')
      helpers.assert.assert_file_contains(file_io.files, state_file, '"last_updated"')

      exec_mock.restore()
      file_io.restore()
    end)
  end)

  describe("is_tool_installed", function()
    it("should check executable for standard tools", function()
      local exec_mock = mock.mock_executable({
        opencode = true,
        claude = false,
        gemini = true,
      })
      local file_io = mock.mock_file_io()

      aicli = require("core.aicli")

      -- Opencode is installed
      local result1 = aicli.set_current_tool("opencode")
      assert.is_true(result1)

      -- Claude is not installed
      local notify_mock = mock.mock_notify()
      local result2 = aicli.set_current_tool("claude")
      assert.is_false(result2)
      helpers.assert.assert_notified(notify_mock.notifications, "not installed", vim.log.levels.WARN)

      notify_mock.restore()
      exec_mock.restore()
      file_io.restore()
    end)

    it("should use custom install_check for copilot", function()
      local exec_mock = mock.mock_executable({ gh = true })
      local system_mock = mock.mock_system({
        ["gh extension list"] = "github/gh-copilot",
      })
      local file_io = mock.mock_file_io()

      aicli = require("core.aicli")
      local result = aicli.set_current_tool("copilot")

      assert.is_true(result)
      assert.are.equal(1, system_mock.call_count["gh extension list"])

      exec_mock.restore()
      system_mock.restore()
      file_io.restore()
    end)

    it("should fail copilot check when gh not installed", function()
      local exec_mock = mock.mock_executable({ gh = false })
      local notify_mock = mock.mock_notify()
      local file_io = mock.mock_file_io()

      aicli = require("core.aicli")
      local result = aicli.set_current_tool("copilot")

      assert.is_false(result)

      exec_mock.restore()
      notify_mock.restore()
      file_io.restore()
    end)

    it("should fail copilot check when extension not installed", function()
      local exec_mock = mock.mock_executable({ gh = true })
      local system_mock = mock.mock_system({
        ["gh extension list"] = "some-other-extension",
      })
      local notify_mock = mock.mock_notify()
      local file_io = mock.mock_file_io()

      aicli = require("core.aicli")
      local result = aicli.set_current_tool("copilot")

      assert.is_false(result)

      exec_mock.restore()
      system_mock.restore()
      notify_mock.restore()
      file_io.restore()
    end)
  end)

  describe("get_terminal_command", function()
    it("should return custom terminal_cmd when defined", function()
      local exec_mock = mock.mock_executable({ claude = true })
      local file_io = mock.mock_file_io()

      aicli = require("core.aicli")
      aicli.set_current_tool("claude")

      local cmd = aicli.get_terminal_command()
      assert.are.equal("printf '\\e[?2004l' && claude", cmd)

      exec_mock.restore()
      file_io.restore()
    end)

    it("should return tool_id when terminal_cmd not defined", function()
      local exec_mock = mock.mock_executable({ opencode = true })
      local file_io = mock.mock_file_io()

      aicli = require("core.aicli")
      aicli.set_current_tool("opencode")

      local cmd = aicli.get_terminal_command()
      assert.are.equal("opencode", cmd)

      exec_mock.restore()
      file_io.restore()
    end)
  end)

  describe("set_current_tool", function()
    it("should emit AICliToolChanged event", function()
      local exec_mock = mock.mock_executable({ gemini = true })
      local file_io = mock.mock_file_io()
      local event_fired = false

      vim.api.nvim_create_autocmd("User", {
        pattern = "AICliToolChanged",
        callback = function(ev)
          event_fired = true
          assert.are.equal("gemini", ev.data.tool)
        end,
      })

      aicli = require("core.aicli")
      aicli.set_current_tool("gemini")

      assert.is_true(event_fired)

      exec_mock.restore()
      file_io.restore()
    end)

    it("should set vim.g.aicli global variable", function()
      local exec_mock = mock.mock_executable({ claude = true })
      local file_io = mock.mock_file_io()

      aicli = require("core.aicli")
      aicli.set_current_tool("claude")

      assert.are.equal("claude", vim.g.aicli)

      exec_mock.restore()
      file_io.restore()
    end)
  end)

  describe("show_selection_menu", function()
    it("should display tools in defined order", function()
      local exec_mock = mock.mock_executable({
        opencode = true,
        claude = false,
        gemini = true,
        gh = false,
      })
      local file_io = mock.mock_file_io()

      local ui_select_items = nil
      vim.ui.select = function(items, opts, on_choice)
        ui_select_items = items
      end

      aicli = require("core.aicli")
      aicli.show_selection_menu()

      assert.is_not_nil(ui_select_items)
      assert.are.equal(4, #ui_select_items)
      assert.is_true(ui_select_items[1]:match("OpenCode") ~= nil)
      assert.is_true(ui_select_items[2]:match("Claude") ~= nil)

      exec_mock.restore()
      file_io.restore()
    end)

    it("should mark current tool with checkmark", function()
      local exec_mock = mock.mock_executable({ opencode = true })
      local file_io = mock.mock_file_io()
      file_io.files[state_file] = '{"selected_tool":"opencode"}'

      local ui_select_items = nil
      vim.ui.select = function(items, opts, on_choice)
        ui_select_items = items
      end

      aicli = require("core.aicli")
      aicli.show_selection_menu()

      assert.is_true(ui_select_items[1]:match("✓") ~= nil)

      exec_mock.restore()
      file_io.restore()
    end)
  end)
end)
