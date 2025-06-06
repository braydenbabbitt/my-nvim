-- This file handles all necessary mappings to use <leader>d and <leader>x for the black hole delete register

-- Set keymaps
vim.keymap.set("n", "<leader>x", '"_x', { noremap = true, silent = true })
vim.keymap.set("v", "<leader>x", '"_x', { noremap = true, silent = true })
vim.keymap.set("n", "<leader>d", '"_d', { noremap = true, silent = true })
vim.keymap.set("v", "<leader>d", '"_d', { noremap = true, silent = true })

return {
  {
    "folke/snacks.nvim",
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
  {
    "folke/todo-comments.nvim",
    keys = {
      -- Change conflicts with black hole register delete keymaps
      { "<leader>Xt", "<cmd>Trouble todo toggle<cr>", desc = "Todo (Trouble)" },
      {
        "<leader>XT",
        "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>",
        desc = "Todo/Fix/Fixme (Trouble)",
      },
      { "<leader>xt", false },
      { "<leader>xT", false },
    },
  },
  {
    "folke/trouble.nvim",
    keys = {
      { "<leader>Xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>XX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
      { "<leader>XL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
      { "<leader>XQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },
      { "<leader>xx", false },
      { "<leader>xX", false },
      { "<leader>xL", false },
      { "<leader>xQ", false },
    },
  },
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
