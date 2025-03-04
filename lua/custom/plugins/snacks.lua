return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    version = "2.22.0",
    opts = {
      dashboard = {
        enabled = true,
        config = function()
          vim.cmd("Neotree toggle") -- open Neotree as part of dashboard
        end,
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
