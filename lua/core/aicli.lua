-- AI CLI Tool Management Module
-- Provides unified interface for managing AI CLI tools (Claude Code, Gemini CLI, GitHub Copilot)

local M = {}

-- CLI Tools Registry
-- Each tool definition includes metadata, installation info, and detection logic
local CLI_TOOLS = {
  claude = {
    name = "Claude Code",
    display_name = "Claude Code",
    executable = "claude",
    install_cmd = "npm install -g @anthropic-ai/claude-cli",
    icon = "󰚩",
    description = "Anthropic's Claude AI assistant",
  },
  gemini = {
    name = "Gemini CLI",
    display_name = "Gemini CLI",
    executable = "gemini",
    install_cmd = "npm i -g @google/gemini-cli",
    icon = "",
    description = "Google's Gemini AI assistant",
  },
  copilot = {
    name = "GitHub Copilot",
    display_name = "GitHub Copilot CLI",
    executable = "gh",
    -- Custom check: gh must be installed AND copilot extension must be installed
    install_check = function()
      if vim.fn.executable("gh") ~= 1 then
        return false
      end
      local output = vim.fn.system("gh extension list")
      return output:match("github/gh%-copilot") ~= nil
    end,
    install_cmd = "gh extension install github/gh-copilot",
    terminal_cmd = "gh copilot",
    icon = "",
    description = "GitHub's Copilot assistant",
  },
}

-- State file path in neovim data directory (git-ignored)
local STATE_FILE = vim.fn.stdpath("data") .. "/aicli.json"

-- Load state from JSON file
-- Returns state table or default if file doesn't exist or is corrupted
local function load_state()
  local file = io.open(STATE_FILE, "r")
  if not file then
    return { selected_tool = "claude" }
  end

  local content = file:read("*a")
  file:close()

  local ok, state = pcall(vim.json.decode, content)
  if not ok or not state or not state.selected_tool then
    vim.notify("AI CLI state file corrupted, using defaults", vim.log.levels.WARN)
    return { selected_tool = "claude" }
  end

  -- Validate that selected_tool exists in CLI_TOOLS
  if not CLI_TOOLS[state.selected_tool] then
    vim.notify(
      string.format("Unknown AI CLI tool '%s', defaulting to claude", state.selected_tool),
      vim.log.levels.WARN
    )
    return { selected_tool = "claude" }
  end

  return state
end

-- Save state to JSON file
-- Includes timestamp for debugging
local function save_state(state)
  state.last_updated = os.date("%Y-%m-%dT%H:%M:%S")

  local ok, json = pcall(vim.json.encode, state)
  if not ok then
    vim.notify("Failed to encode AI CLI state", vim.log.levels.ERROR)
    return false
  end

  local file = io.open(STATE_FILE, "w")
  if not file then
    vim.notify("Failed to save AI CLI state", vim.log.levels.ERROR)
    return false
  end

  file:write(json)
  file:close()
  return true
end

-- Check if a CLI tool is installed
-- Handles both standard executable checks and custom checks (e.g., Copilot)
local function is_tool_installed(tool_id)
  local tool = CLI_TOOLS[tool_id]
  if not tool then
    return false
  end

  -- Use custom install_check if provided (e.g., for Copilot)
  if tool.install_check then
    return tool.install_check()
  end

  -- Standard executable check
  return vim.fn.executable(tool.executable) == 1
end

-- Current state (loaded once on module load)
local current_state = load_state()

-- Get the currently selected tool ID
function M.get_current_tool()
  return current_state.selected_tool
end

-- Get tool info by ID
function M.get_tool_info(tool_id)
  return CLI_TOOLS[tool_id]
end

-- Get the terminal command for the current tool
-- Some tools use different commands than their tool_id (e.g., Copilot uses "gh copilot")
function M.get_terminal_command()
  local tool_id = M.get_current_tool()
  local tool = CLI_TOOLS[tool_id]
  if not tool then
    return "claude" -- fallback
  end
  return tool.terminal_cmd or tool_id
end

-- Set the current tool and persist to disk
-- Emits AICliToolChanged event for which-key and other listeners
function M.set_current_tool(tool_id)
  local tool = CLI_TOOLS[tool_id]
  if not tool then
    vim.notify(string.format("Unknown AI CLI tool: %s", tool_id), vim.log.levels.ERROR)
    return false
  end

  -- Check if tool is installed
  if not is_tool_installed(tool_id) then
    vim.notify(
      string.format("%s is not installed. Use <leader>als to install it.", tool.display_name),
      vim.log.levels.WARN
    )
    return false
  end

  -- Update state
  current_state.selected_tool = tool_id
  vim.g.aicli = tool_id

  -- Persist to disk
  save_state(current_state)

  -- Notify user
  vim.notify(string.format("Switched to %s", tool.display_name), vim.log.levels.INFO)

  -- Emit event for which-key and other listeners
  vim.api.nvim_exec_autocmds("User", {
    pattern = "AICliToolChanged",
    data = { tool = tool_id },
  })

  return true
end

-- Install a CLI tool via Snacks terminal
-- Shows installation progress in floating terminal
-- Auto-switches to tool after successful installation
local function install_tool(tool_id)
  local tool = CLI_TOOLS[tool_id]
  if not tool then
    vim.notify("Unknown tool", vim.log.levels.ERROR)
    return
  end

  local cmd = tool.install_cmd

  -- Check if Snacks is available
  if not Snacks then
    vim.notify("Snacks.nvim not available. Install manually: " .. cmd, vim.log.levels.ERROR)
    return
  end

  -- Open terminal with installation command
  Snacks.terminal(cmd, {
    win = { position = "float" },
    on_exit = function(status)
      if status == 0 then
        vim.notify(tool.display_name .. " installed successfully!", vim.log.levels.INFO)
        -- Auto-switch to newly installed tool
        current_state.selected_tool = tool_id
        vim.g.aicli = tool_id
        save_state(current_state)

        -- Emit event for which-key updates
        vim.api.nvim_exec_autocmds("User", {
          pattern = "AICliToolChanged",
          data = { tool = tool_id },
        })
      else
        vim.notify("Installation failed! Check terminal output for details.", vim.log.levels.ERROR)
      end
    end,
  })
end

-- Handle tool selection from menu
-- Prompts for installation if tool is not installed
local function handle_tool_selection(tool_id)
  if not tool_id then
    return
  end

  local tool = CLI_TOOLS[tool_id]
  if not tool then
    return
  end

  -- Check if installed
  if not is_tool_installed(tool_id) then
    -- Prompt for installation
    local confirm =
      vim.fn.confirm(string.format("%s is not installed. Install now?", tool.display_name), "&Yes\n&No", 2)

    if confirm == 1 then
      install_tool(tool_id)
    end
  else
    -- Tool is installed, switch to it
    M.set_current_tool(tool_id)
  end
end

-- Show interactive selection menu
-- Displays all tools with installation status (✓/✗)
function M.show_selection_menu()
  -- Define a consistent order for tools
  local tool_order = { "claude", "gemini", "copilot" }

  local items = {}
  local tool_ids = {}

  -- Build menu items in defined order
  for _, id in ipairs(tool_order) do
    local tool = CLI_TOOLS[id]
    if tool then
      local installed = is_tool_installed(id)
      local selected = M.get_current_tool() == id
      local installation_status = installed and "" or "(not installed)"
      local selected_text = selected and "✓" or " "
      local label = string.format("%s %s %s", selected_text, tool.display_name, installation_status)

      table.insert(items, label)
      table.insert(tool_ids, id)
    end
  end

  -- Show selection menu
  vim.ui.select(items, {
    prompt = "Select AI CLI Tool:",
    format_item = function(item)
      return item
    end,
  }, function(choice, idx)
    if not idx then
      return
    end
    handle_tool_selection(tool_ids[idx])
  end)
end

return M
