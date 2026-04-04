-- Conform.nvim - Formatting
-- Handles code formatting with external formatters

return {
  "stevearc/conform.nvim",
  commit = "b4aab98",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = "",
      desc = "Format buffer",
    },
  },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      javascript = { "prettier" },
      typescript = { "prettier" },
      javascriptreact = { "prettier" },
      typescriptreact = { "prettier" },
      json = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
      html = { "prettier" },
      css = { "prettier" },
      scss = { "prettier" },
      astro = { "prettier" },
      gdscript = { "gdformat" },
      cs = { "csharpier" },
      cpp = { "clang_format" },
      c = { "clang_format" },
    },
    format_on_save = function()
      if vim.g.autoformat == false then
        return nil
      end
      return { timeout_ms = 500, lsp_fallback = true }
    end,
    -- Set up formatters
    formatters = {
      prettier = {
        prepend_args = { "--prose-wrap", "always" },
      },
    },
  },
  init = function()
    -- If you want conform to format on save, you can do it here
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
