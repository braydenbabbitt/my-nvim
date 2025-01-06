local util = require("lspconfig.util")

return {
  {
    "nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
      servers = {
        denols = {
          root_dir = function(fname)
            return util.root_pattern("deno.json", "deno.jsonc")(fname)
          end,
          init_options = {
            enable = true,
            lint = true,
          },
          filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact" },
          single_file_support = false,
        },
        vtsls = {
          filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact" },
          single_file_support = false,
        },
      },
    },
  },
}
