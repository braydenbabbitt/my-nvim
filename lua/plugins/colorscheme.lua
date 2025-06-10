return {
  {
    "Mofiqul/vscode.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "dark",
      color_overrides = {
        vscBack = "#0f1012",
        vscPopupBack = "#0f1012",
      },
    },
    config = function(_, opts)
      local c = require("vscode.colors").get_colors()
      opts.group_overrides = {
        Cursor = { fg = c.vscDarkBlue, bg = c.vscLightGreen, bold = true },
        CursorLineNr = { fg = c.vscUiOrange, bg = "NONE" },
      }
      require("vscode").setup(opts)
    end,
  },
  {
    "folke/tokyonight.nvim",
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
  {
    "catppuccin/nvim",
    -- name = "catppuccin",
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
  -- Apply the selected colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "vscode",
    },
  },
}
