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
  -- Apply the selected colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "vscode",
    },
  },
}
