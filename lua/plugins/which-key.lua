-- Which-key - Keymap hints
-- Shows available keybindings in a popup

return {
  "folke/which-key.nvim",
  commit = "370ec46",
  event = "VeryLazy",
  opts = {
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
      { "<leader>a", group = "AI/Assistant" },
      { "<leader>b", group = "Buffer" },
      { "<leader>c", group = "Code" },
      { "<leader>d", desc = "Blackhole Register Delete" },
      { "<leader>D", group = "Debug" },
      { "<leader>Dp", group = "Profiler" },
      { "<leader>f", group = "Find/File" },
      { "<leader>g", group = "Git" },
      { "<leader>L", group = "LSP" },
      { "<leader>Lr", group = "LSP Restart" },
      { "<leader>n", group = "Notifications" },
      { "<leader>q", group = "Quit/Session" },
      { "<leader>s", group = "Search" },
      { "<leader>u", group = "UI/Toggle" },
      { "<leader>w", group = "Windows" },
      { "<leader>x", desc = "Blackhole Register Delete" },
      { "<leader>X", group = "Diagnostics/Quickfix" },
    },
  },
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
