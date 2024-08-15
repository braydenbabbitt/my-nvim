return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      require("tokyonight").setup({
        style = "night",
        styles = {
          functions = {},
        },
        on_colors = function(colors)
          colors.error = "#eb1717"
        end,
      })

      vim.cmd("colorscheme tokyonight")
    end,
  },
  {
    "nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
    },
  },
}
