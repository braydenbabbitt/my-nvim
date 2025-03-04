return {
  {
    "Mofiqul/vscode.nvim",
    priority = 1000,
    commit = "7331e83",
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
          -- Add overrides for Neo-tree specific highlight groups
          NeoTreeIndentMarker = { fg = c.vscLineNumber, bg = "NONE" },
          NeoTreeExpander = { fg = c.vscLineNumber, bg = "NONE" },
          NeoTreeNormal = { bg = c.vscBack },
          NeoTreeNormalNC = { bg = c.vscBack },
          NeoTreeWinSeparator = { fg = c.vscBack, bg = c.vscBack },
        },
      })
      vim.api.nvim_set_hl(0, "NeoTreeGitModified", { fg = c.vscDarkYellow, bg = "NONE" })
      vim.api.nvim_set_hl(0, "NeoTreeIndentMarker", { fg = c.vscLineNumber, bg = "NONE" })
      vim.api.nvim_set_hl(0, "NeoTreeVertSplit", { fg = c.vscBack, bg = c.vscBack })
      vim.cmd.colorscheme("vscode")
    end,
  },
}
