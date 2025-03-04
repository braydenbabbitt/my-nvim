return {
  {
    "MagicDuck/grug-far.nvim",
    opts = { headerMaxWidth = 80 },
    cmd = "GrugFar",
    commit = "3d39dc8",
    keys = {
      {
        "<leader>srt",
        function()
          local grug = require("grug-far")
          local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
          grug.open({
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= "" and "*." .. ext or nil,
            },
          })
        end,
        mode = { "n", "v" },
        desc = "Current file [T]ype",
      },
      {
        "<leader>srg",
        function()
          local grug = require("grug-far")
          grug.open({
            transient = true,
            prefills = {},
          })
        end,
        mode = { "n", "v" },
        desc = "[G]lobal",
      },
      {
        "<leader>srf",
        function()
          local grug = require("grug-far")
          local current_file = vim.api.nvim_buf_get_name(0)
          grug.open({
            transient = true,
            prefills = {
              filesFilter = current_file or nil,
            },
          })
        end,
        mode = { "n", "v" },
        desc = "Current [F]ile",
      },
    },
  },
}
