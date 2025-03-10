return {
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    version = "3.1.0",
    opts = {},
    keys = {
      {
        "<leader>Sr",
        function()
          require("persistence").load()
        end,
        desc = "[R]estore Session",
      },
      {
        "<leader>Ss",
        function()
          require("persistence").select()
        end,
        desc = "[S]elect Session",
      },
      {
        "<leader>Sl",
        function()
          require("persistence").load({ last = true })
        end,
        desc = "[L]oad Last Session",
      },
      {
        "<leader>Sd",
        function()
          require("persistence").stop()
        end,
        desc = "[D]on't Save Current Session",
      },
    },
  },
}
