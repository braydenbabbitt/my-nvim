-- Trouble - Diagnostics list
-- Pretty list for diagnostics, references, quickfix, etc.

return {
  "folke/trouble.nvim",
  commit = "3fb3bd7",
  cmd = { "Trouble" },
  opts = {
    use_diagnostic_signs = true,
  },
  keys = {
    {
      "<leader>Xx",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "Diagnostics (Trouble)",
    },
    {
      "<leader>XX",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "Buffer Diagnostics (Trouble)",
    },
    {
      "<leader>cs",
      "<cmd>Trouble symbols toggle focus=false<cr>",
      desc = "Symbols (Trouble)",
    },
    {
      "<leader>cS",
      "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
      desc = "LSP references/definitions (Trouble)",
    },
    {
      "<leader>XL",
      "<cmd>Trouble loclist toggle<cr>",
      desc = "Location List (Trouble)",
    },
    {
      "<leader>XQ",
      "<cmd>Trouble qflist toggle<cr>",
      desc = "Quickfix List (Trouble)",
    },
  },
}
