-- LuaSnip - Snippet engine
-- Custom snippets for various filetypes

return {
  "L3MON4D3/LuaSnip",
  commit = "4585605",
  build = "make install_jsregexp",
  dependencies = {
    { "rafamadriz/friendly-snippets", commit = "572f566" },
  },
  config = function()
    local ls = require("luasnip")
    local s = ls.snippet
    local t = ls.text_node
    local i = ls.insert_node

    -- Load friendly-snippets
    require("luasnip.loaders.from_vscode").lazy_load()

    -- Custom snippets by filetype
    local custom_snippets = {
      javascript = {
        s("cc", { t("console.log('brayden-test', "), i(1), t(")") }),
      },
      typescript = {
        s("cc", { t("console.log('brayden-test', "), i(1), t(")") }),
      },
      javascriptreact = {
        s("cc", { t("console.log('brayden-test', "), i(1), t(")") }),
      },
      typescriptreact = {
        s("cc", { t("console.log('brayden-test', "), i(1), t(")") }),
      },
    }

    -- Register all custom snippets
    for ft, snippets in pairs(custom_snippets) do
      ls.add_snippets(ft, snippets)
    end

    -- Keybindings for snippet navigation
    vim.keymap.set({ "i", "s" }, "<C-CR>", function()
      if ls.expand_or_jumpable() then
        ls.expand_or_jump()
      else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-CR>", true, false, true), "n", true)
      end
    end, { silent = true, desc = "Expand or jump to next snippet node" })

    vim.keymap.set({ "i", "s" }, "<C-S-CR>", function()
      if ls.jumpable(-1) then
        ls.jump(-1)
      else
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-S-CR>", true, false, true), "n", true)
      end
    end, { silent = true, desc = "Jump to previous snippet node" })
  end,
}
