return {
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        preset = "super-tab",
        -- Remap Ctrl-space to exit insert mode
        ["<C-space>"] = {
          function()
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
          end,
        },
      },
    },
  },
}
