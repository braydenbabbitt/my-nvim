return {
  {
    "snacks.nvim",
    keys = {
      { "<leader>dps", false },
      {
        "<leader>Dps",
        function()
          Snacks.profiler.scratch()
        end,
        desc = "Profiler Scratch Buffer",
      },
      { "<leader>dpp", false },
      {
        "<leader>Dpp",
        function()
          Snacks.toggle.profiler()
        end,
        desc = "Snacks profiler",
      },
      { "<leader>dph", false },
      {
        "<leader>Dph",
        function()
          Snacks.toggle.profiler_highlights()
        end,
        desc = "Snacks profiler highlights",
      },
    },
  },
}
