return {
  {
    "NickvanDyke/opencode.nvim",
    commit = "0457708",
    dependencies = {
      ---@module 'snacks'
      {
        "folke/snacks.nvim",
        opts = { input = {}, picker = {}, terminal = {} },
      },
    },
    config = function()
      ---@type opencode.Opts
      vim.g.opencode_opts = {}

      vim.o.autoread = true

      vim.keymap.set({ "n", "x" }, "<leader>at", function()
        require("opencode").toggle()
      end, { desc = "Toggle opencode" })
      vim.keymap.set({ "n", "x" }, "<leader>aa", function()
        require("opencode").toggle()
      end, { desc = "Open opencode" })
    end,
  },
}
