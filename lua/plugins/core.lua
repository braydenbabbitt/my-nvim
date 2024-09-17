local lspconfig_util = require("lspconfig.util")

function deepest_root_pattern(patterns1, patterns2)
  local find_root1 = lspconfig_util.root_pattern(unpack(patterns1))
  local find_root2 = lspconfig_util.root_pattern(unpack(patterns2))

  return function(startpath)
    local path1 = find_root1(startpath)
    local path2 = find_root2(startpath)

    if path1 and path2 then
      local path1_length = select(2, path1:gsub("/", ""))
      local path2_length = select(2, path2:gsub("/", ""))

      if path1_length > path2_length then
        return path1
      end
    elseif path1 then
      return path1
    end

    return nil
  end
end

return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },
  {
    "nvim-lspconfig",
    opts = {
      inlay_hints = { enabled = false },
    },
    config = function()
      local lspconfig = require("lspconfig")

      lspconfig.tsserver.setup({
        inlay_hints = { enabled = false },
        root_dir = deepest_root_pattern(
          { "package.json", "tsconfig.json" },
          { "deno.json", "deno.jsonc", "import_map.json" }
        ),
        single_file_support = false,
      })

      lspconfig.denols.setup({
        inlay_hints = { enabled = false },
        root_dir = deepest_root_pattern(
          { "deno.json", "deno.jsonc", "import_map.json" },
          { "package.json", "tsconfig.json" }
        ),
      })
    end,
  },
  {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      require("onedark").setup({
        style = "darker",
      })
    end,
  },
  {
    "Mofiqul/vscode.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      local c = require("vscode.colors").get_colors()
      require("vscode").setup({
        style = "dark",
        color_overrides = {
          vscBack = "#0f1012",
          vscPopupBack = "#0f1012",
        },
        group_overrides = {
          Cursor = { fg = c.vscDarkBlue, bg = c.vscLightGreen, bold = true },
          CursorLineNr = { fg = c.vscUiOrange, bg = "NONE" },
        },
      })
      vim.api.nvim_set_hl(0, "NeoTreeGitModified", { fg = c.vscDarkYellow, bg = "NONE" })

      vim.cmd("colorscheme vscode")
    end,
  },
  {
    "olimorris/onedarkpro.nvim",
    lazy = false,
    priority = 1000,
  },
}
