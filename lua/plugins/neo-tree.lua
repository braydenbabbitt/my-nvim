return {
  "nvim-neo-tree/neo-tree.nvim",
  config = function(opts)
    local c = require("vscode.colors").get_colors()
    require("neo-tree").setup({
      filesystem = {
        filtered_items = {
          visible = true,
        },
      },
    })

    vim.api.nvim_set_hl(0, "NeoTreeGitModified", { fg = c.vscDarkYellow, bg = "NONE" })
  end,
}
