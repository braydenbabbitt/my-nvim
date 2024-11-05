return {
  {
    "github/copilot.vim",
    event = "VeryLazy",
    config = function()
      vim.keymap.set("i", "<C-Enter>", 'copilot#Accept("<Enter>")', {
        expr = true,
        replace_keycodes = false,
      })
      vim.g.copilot_no_tab_map = true

      vim.keymap.set("n", "<C-x>", "<Plug>(copilot-dismiss)")
      vim.keymap.set("i", "<C-x>", "<Plug>(copilot-dismiss)")
    end,
  },
}
