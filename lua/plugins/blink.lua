-- Blink.cmp - Completion engine
-- Fast, feature-rich autocompletion

return {
  "saghen/blink.cmp",
  commit = "0225218",
  dependencies = "rafamadriz/friendly-snippets",
  opts = {
    keymap = {
      preset = "super-tab",
      -- Remap Ctrl-space to exit insert mode
      ["<C-space>"] = {
        function()
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
        end,
      },
      ["<C-@>"] = {
        function()
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
        end,
      },
    },
    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = "mono",
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
    completion = {
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 500,
      },
    },
  },
  opts_extend = { "sources.default" },
}
