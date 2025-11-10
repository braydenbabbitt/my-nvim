-- Colorschemes
-- Multiple themes available, default set in init.lua

return {
  -- VSCode theme (default)
  {
    "Mofiqul/vscode.nvim",
    commit = "cb9df08",
    lazy = false,
    priority = 1000,
    config = function()
      local c = require("vscode.colors").get_colors()
      require("vscode").setup({
        style = "dark",
        color_overrides = {
          vscBack = "#0f1012",
          vscPopupBack = "#0f1012",
        },
        group_overrides = {
          Cursor = { fg = c.vscDarkBlue, bg = c.vscLightGreen, bold = true },
          CursorLineNr = { fg = c.vscUiOrange, bg = "NONE" },
        },
      })
    end,
  },

  -- Tokyo Night theme (alternative)
  {
    "folke/tokyonight.nvim",
    commit = "14fd5ff",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night",
      styles = {
        keywords = {
          italic = false,
        },
      },
    },
  },

  -- Catppuccin theme (alternative)
  {
    "catppuccin/nvim",
    commit = "30fa4d1",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "mocha",
      terminal_colors = true,
      styles = {
        conditionals = {},
      },
      dim_inactive = {
        enabled = true,
        shade = "dark",
        percentage = 0.15,
      },
      color_overrides = {
        mocha = {
          base = "#11111c",
          mantle = "#0a0a13",
          crust = "#040408",
        },
      },
    },
  },
}
