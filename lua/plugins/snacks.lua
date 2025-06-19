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
      {
        "<leader>ff",
        LazyVim.pick("files", { root = false }),
        desc = "Find Files (cwd)",
        remap = true,
      },
      {
        "<leader>fF",
        LazyVim.pick("files"),
        desc = "Find Files (Root Dir)",
        remap = true,
      },
      { "<leader>sW", LazyVim.pick("grep_word"), desc = "Visual selection or word (Root Dir)", mode = { "n", "x" } },
      {
        "<leader>sw",
        LazyVim.pick("grep_word", { root = false }),
        desc = "Visual selection or word (cwd)",
        mode = { "n", "x" },
      },
      {
        "<leader>fg",
        function()
          Snacks.picker.git_files({ filter = { cwd = true } })
        end,
        desc = "Find Files (git-files)",
        remap = true,
      },
    },
  },
}
