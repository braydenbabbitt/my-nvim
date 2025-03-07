return {
  {
    "stevearc/conform.nvim",
    version = "9.0.0",
    dependencies = { "mason.nvim" },
    lazy = true,
    cmd = "ConformInfo",
    opts = {
      default_format_opts = {
        timeout_ms = 3000,
        async = false,
        quiet = false,
        lsp_fallback = true,
      },
      formatters_by_ft = {
        ["*"] = { "injected" }, -- Enable injected formatting for all files | WARN: This could lead to performance issues

        -- Add specific formatters for languages
        lua = { "stylua", "injected" },
        python = { "black", "injected" },
        javascript = { "prettier", "injected" },
        typescript = { "prettier", "injected" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
      },
      formatters = {
        injected = { options = { ignore_errors = true } },
      },
    },
  },
}
