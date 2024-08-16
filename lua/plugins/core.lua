return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    -- config = function()
    --   require("tokyonight").setup({
    --     style = "night",
    --     styles = {
    --       functions = {},
    --     },
    --     on_colors = function(colors)
    --       colors.error = "#eb1717"
    --     end,
    --   })
    --
    --   vim.cmd("colorscheme tokyonight")
    -- end,
  },
  {
    "nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
    },
  },
  {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      require("onedark").setup({
        style = "darker",
      })
    end,
  },
  {
    "Mofiqul/vscode.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      local c = require("vscode.colors").get_colors()
      require("vscode").setup({
        style = "dark",
        color_overrides = {
          vscBack = "#0f1012",
        },
        group_overrides = {
          Cursor = { fg = c.vscDarkBlue, bg = c.vscLightGreen, bold = true },
          CursorLineNr = { fg = c.vscUiOrange, bg = "NONE" },
          NvimTreeGitDirty = { fg = c.vscDarkYellow, bg = "NONE" },
        },
      })

      vim.cmd("colorscheme vscode")
    end,
  },
}
