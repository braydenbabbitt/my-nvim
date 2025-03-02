---@module "snacks"
return {
  {
    "folke/snacks.nvim",
    opts = {
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
