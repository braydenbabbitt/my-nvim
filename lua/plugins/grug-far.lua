-- Grug-far: Find and replace across files
-- A better search and replace experience with a nice UI

return {
  "MagicDuck/grug-far.nvim",
  commit = "3e72397",
  event = "VeryLazy",
  opts = {
    headerMaxWidth = 80,
  },
  keys = {
    {
      "<leader>sr",
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
      desc = "Search and Replace",
    },
  },
}
