return {
  {
    "folke/todo-comments.nvim",
    version = "1.4.0",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = {
      "BufReadPost",
      "BufNewFile",
      "BufWritePost",
    },
    keys = {
      {
        "<leader>T]",
        function()
          require("todo-comments").jump_next()
        end,
        desc = "Next Todo Comment",
      },
      {
        "<leader>T[",
        function()
          require("todo-comments").jump_prev()
        end,
        desc = "Previous Todo Comment",
      },
      { "<leader>Tt", "<cmd>Trouble todo toggle<cr>", desc = "Toggle [T]rouble Todo List" },
      { "<leader>Ft", "<cmd>Trouble todo toggle filter = {tag = {FIX,FIXME}}<cr>", desc = "Toggle [T]rouble Fix List" },
      { "<leader>TT", "<cmd>TodoTelescope<cr>", desc = "Toggle [T]elescope Todo List" },
      { "<leader>FT", "<cmd>TodoTelescope keywords=FIX,FIXME<cr>", desc = "Toggle [T]elescope Fix List" },
    },
  },
}
