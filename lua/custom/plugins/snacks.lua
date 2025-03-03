return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      dashboard = {
        enabled = true,
      },
      lazygit = {
        enabled = true,
        config = {
          configure = true,
          gui = {
            nerdFontsVersion = "3",
          },
        },
      },
    },
    keys = {
      {
        "<leader>gg",
        function()
          Snacks.lazygit()
        end,
        desc = "Toggle Lazygit",
      },
    },
  },
}
