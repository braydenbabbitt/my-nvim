return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      filtered_items = {
        visible = true,
      },
    },
  },
  config = function(opts)
    local c = require("vscode.colors").get_colors()
    require("neo-tree").setup(opts)

    vim.api.nvim_set_hl(0, "NeoTreeGitModified", { fg = c.vscDarkYellow, bg = "NONE" })
  end,
}
