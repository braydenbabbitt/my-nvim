return {
  "nvim-neo-tree/neo-tree.nvim",
  config = function(opts)
    local c = require("vscode.colors").get_colors()
    require("neo-tree").setup({
      filesystem = {
        filtered_items = {
          visible = true,
        },
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false,
        },
      },
    })

    vim.api.nvim_set_hl(0, "NeoTreeGitModified", { fg = c.vscDarkYellow, bg = "NONE" })
  end,
}
