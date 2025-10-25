-- Completion and snippets configuration
return {
  -- LuaSnip (must load before blink.cmp)
  {
    "L3MON4D3/LuaSnip",
    version = "2.4.0",
    build = "make install_jsregexp",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local ls = require("luasnip")
      local s = ls.snippet
      local t = ls.text_node
      local i = ls.insert_node

      -- Load friendly snippets
      require("luasnip.loaders.from_vscode").lazy_load()

      -- Table of custom snippets by filetype
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

      -- Keybind setup
      vim.keymap.set({ "i", "s" }, "<C-CR>", function()
        if ls.expand_or_jumpable() then
          ls.expand_or_jump()
        else
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-CR>", true, false, true), "n", true)
        end
      end, { silent = true })

      vim.keymap.set({ "i", "s" }, "<C-S-CR>", function()
        if ls.jumpable(-1) then
          ls.jump(-1)
        else
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-S-CR>", true, false, true), "n", true)
        end
      end, { silent = true })
    end,
  },

  -- Friendly snippets
  {
    "rafamadriz/friendly-snippets",
    lazy = true,
  },

  -- Blink.cmp
  {
    "saghen/blink.cmp",
    version = "0.*",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
    },
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
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
      },
      sources = {
        default = { "lsp", "path", "luasnip", "buffer" },
        providers = {
          luasnip = {
            name = "luasnip",
            module = "blink.compat.source",
          },
        },
      },
      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          window = {
            border = "rounded",
          },
        },
        menu = {
          border = "rounded",
        },
      },
      signature = {
        enabled = true,
        window = {
          border = "rounded",
        },
      },
    },
  },

  -- Blink compat for LuaSnip
  {
    "saghen/blink.compat",
    version = "*",
    lazy = true,
    opts = {},
  },
}
