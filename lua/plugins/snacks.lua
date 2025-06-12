return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          explorer = {
            auto_close = true,
            git_status_open = false,
            hidden = true,
            ignored = true,
          },
        },
      },
    },
    keys = {
      {
        "<leader>e",
        "<leader>fE",
        desc = "Explorer Snacks (cwd)",
        remap = true,
      },
      {
        "<leader>E",
        "<leader>fe",
        desc = "Explorer Snacks (root dir)",
        remap = true,
      },
      {
        "<leader>/",
        "<leader>sG",
        desc = "Snacks Search (cwd)",
        remap = true,
      },
    },
  },
}
