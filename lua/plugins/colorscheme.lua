return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "night",
      styles = {
        keywords = { italic = false },
      },
      on_colors = function(colors)
        colors.bg = "#1c1e28"
      end,
      dim_inactive = true,
    },
  },
  -- Apply the selected colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
}
