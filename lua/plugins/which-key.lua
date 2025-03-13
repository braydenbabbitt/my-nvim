return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts_extend = { "spec" },
    opts = {
      spec = {
        { "<leader>d", desc = "Blackhole Register Delete" },
        { "<leader>x", desc = "Blackhole Register Delete" },
        { "<leader>D", group = "Debug" },
        { "<leader>Dp", group = "profiler" },
        { "<leader>dp", hidden = true },
      },
    },
  },
}
