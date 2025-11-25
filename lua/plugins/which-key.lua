-- Which-key - Keymap hints
-- Shows available keybindings in a popup

return {
  "folke/which-key.nvim",
  commit = "370ec46",
  event = "VeryLazy",
  opts = {
    preset = "helix", -- Use the modern helix preset layout
    delay = 300, -- Delay before which-key popup appears (ms)

    -- Window configuration
    win = {
      border = "rounded", -- Border style: none, single, double, rounded, solid, shadow
      padding = { 1, 2 }, -- Extra window padding [top/bottom, right/left]
      title = true,
      title_pos = "center",
      zindex = 1000,
      -- Transparency
      wo = {
        winblend = 0, -- value between 0-100 (0 = opaque, 100 = transparent)
      },
    },

    -- Layout configuration
    layout = {
      width = { min = 20, max = 50 }, -- min and max width of columns
      spacing = 3, -- spacing between columns
    },

    -- Icons configuration
    icons = {
      breadcrumb = "»", -- symbol used in the command line area
      separator = "➜", -- symbol used between a key and its label
      group = "+", -- symbol prepended to a group
      ellipsis = "…",
      mappings = true, -- Use mini.icons or nvim-web-devicons
      rules = false, -- Disable default icon rules
      keys = {
        Up = " ",
        Down = " ",
        Left = " ",
        Right = " ",
        C = "󰘴 ",
        M = "󰘵 ",
        D = "󰘳 ",
        S = "󰘶 ",
        CR = "󰌑 ",
        Esc = "󱊷 ",
        ScrollWheelDown = "󱕐 ",
        ScrollWheelUp = "󱕑 ",
        NL = "󰌑 ",
        BS = "󰁮",
        Space = "󱁐 ",
        Tab = "󰌒 ",
        F1 = "󱊫",
        F2 = "󱊬",
        F3 = "󱊭",
        F4 = "󱊮",
        F5 = "󱊯",
        F6 = "󱊰",
        F7 = "󱊱",
        F8 = "󱊲",
        F9 = "󱊳",
        F10 = "󱊴",
        F11 = "󱊵",
        F12 = "󱊶",
      },
    },

    -- Disable which-key for certain keys
    disable = {
      ft = {},
      bt = {},
    },

    plugins = {
      marks = true,
      registers = true,
      spelling = {
        enabled = true,
        suggestions = 20,
      },
    },

    spec = {
      -- Group descriptions
      { "<leader>a", group = "AI/Assistant", icon = "󰚩" },
      { "<leader>al", group = "Switch AI CLI", icon = "" },
      { "<leader>b", group = "Buffer", icon = "󰓩" },
      { "<leader>c", group = "Code", icon = "" },
      { "<leader>d", desc = "Blackhole Register Delete" },
      { "<leader>D", group = "Debug", icon = "" },
      { "<leader>Dp", group = "Profiler", icon = "" },
      { "<leader>f", group = "Find/File", icon = "" },
      { "<leader>g", group = "Git", icon = "" },
      { "<leader>L", group = "LSP", icon = "" },
      { "<leader>Lr", group = "LSP Restart" },
      { "<leader>n", group = "Notifications", icon = "" },
      { "<leader>q", group = "Quit/Session", icon = "" },
      { "<leader>s", group = "Search", icon = "" },
      { "<leader>u", group = "UI/Toggle", icon = "" },
      { "<leader>w", group = "Windows", icon = "" },
      { "<leader>x", desc = "Blackhole Register Delete" },
      { "<leader>X", group = "Diagnostics/Quickfix", icon = "󱖫" },
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)

    -- Dynamic AI CLI descriptions
    local function update_ai_descriptions()
      local ok, aicli = pcall(require, "core.aicli")
      if not ok then
        return
      end

      local current = aicli.get_current_tool()
      local tool = aicli.get_tool_info(current)

      wk.add({
        { "<leader>aa", desc = "Open " .. tool.display_name },
        { "<leader>at", desc = "Toggle " .. tool.display_name },
        { "<leader>als", desc = "Select AI CLI (current: " .. tool.display_name .. ")" },
      })
    end

    -- Update on startup
    vim.schedule(update_ai_descriptions)

    -- Update when tool changes
    vim.api.nvim_create_autocmd("User", {
      pattern = "AICliToolChanged",
      callback = update_ai_descriptions,
    })
  end,
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
