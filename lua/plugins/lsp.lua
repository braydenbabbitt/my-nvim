-- LSP Configuration
-- Language Server Protocol setup with multiple language servers

return {
  -- Mason - LSP/DAP/Linter installer
  {
    "williamboman/mason.nvim",
    commit = "fc98833",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
  },

  -- Mason-lspconfig bridge
  {
    "williamboman/mason-lspconfig.nvim",
    commit = "1a31f82",
    dependencies = { "mason.nvim" },
    opts = {
      ensure_installed = {
        "lua_ls",
        "vtsls",
        "eslint",
        "denols",
        -- Note: postgres_lsp is not available via mason, install manually if needed
      },
      automatic_installation = true,
    },
  },

  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    commit = "1f7fbc3",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      -- Setup LSP keymaps on attach
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          -- Jump to definition/declaration/references
          map("gd", vim.lsp.buf.definition, "Goto Definition")
          map("gD", vim.lsp.buf.declaration, "Goto Declaration")
          map("gr", vim.lsp.buf.references, "Goto References")
          map("gI", vim.lsp.buf.implementation, "Goto Implementation")
          map("gy", vim.lsp.buf.type_definition, "Goto Type Definition")

          -- Symbols and search
          map("<leader>ss", vim.lsp.buf.document_symbol, "Document Symbols")
          map("<leader>sS", vim.lsp.buf.workspace_symbol, "Workspace Symbols")

          -- Code actions
          map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
          map("<leader>cr", vim.lsp.buf.rename, "Rename")

          -- Diagnostics
          map("<leader>cd", vim.diagnostic.open_float, "Line Diagnostics")

          -- Documentation
          map("K", vim.lsp.buf.hover, "Hover Documentation")
          map("gK", vim.lsp.buf.signature_help, "Signature Help")

          -- Enable inlay hints if supported
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            -- Inlay hints are disabled by default in options.lua
            -- Uncomment to add toggle:
            map("<leader>th", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
            end, "[T]oggle Inlay [H]ints")
          end
        end,
      })

      -- Configure diagnostic display
      vim.diagnostic.config({
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = "if_many",
          header = "",
          prefix = "",
        },
      })

      -- Default LSP capabilities (completion support)
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities())

      -- Helper function to find project root
      local function root_pattern(...)
        local patterns = { ... }
        return function(fname)
          local util = vim.fs
          for _, pattern in ipairs(patterns) do
            local found = util.find(pattern, { path = fname, upward = true })
            if found and #found > 0 then
              return vim.fs.dirname(found[1])
            end
          end
          return nil
        end
      end

      -- Configure individual language servers using new vim.lsp.config API
      -- Lua Language Server
      vim.lsp.config.lua_ls = {
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        root_dir = root_pattern(
          ".luarc.json",
          ".luarc.jsonc",
          ".luacheckrc",
          ".stylua.toml",
          "stylua.toml",
          "selene.toml",
          "selene.yml",
          ".git"
        ),
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME,
                "${3rd}/luv/library",
              },
            },
            completion = {
              callSnippet = "Replace",
            },
            diagnostics = { disable = { "missing-fields" } },
          },
        },
      }

      -- TypeScript/JavaScript (vtsls)
      vim.lsp.config.vtsls = {
        cmd = { "vtsls", "--stdio" },
        filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
        root_dir = root_pattern("package.json"),
        single_file_support = false,
        capabilities = capabilities,
      }

      -- Deno
      vim.lsp.config.denols = {
        cmd = { "deno", "lsp" },
        filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
        root_dir = root_pattern("deno.json", "deno.jsonc", "deno.lock"),
        single_file_support = false,
        capabilities = capabilities,
        init_options = {
          enable = true,
          lint = true,
        },
      }

      -- ESLint
      vim.lsp.config.eslint = {
        cmd = { "vscode-eslint-language-server", "--stdio" },
        filetypes = {
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
          "vue",
          "svelte",
          "astro",
        },
        root_dir = root_pattern(
          ".eslintrc",
          ".eslintrc.js",
          ".eslintrc.cjs",
          ".eslintrc.yaml",
          ".eslintrc.yml",
          ".eslintrc.json",
          "eslint.config.js",
          "package.json"
        ),
        capabilities = capabilities,
        settings = {
          workingDirectories = { mode = "auto" },
        },
      }

      -- PostgreSQL
      vim.lsp.config.postgres_lsp = {
        cmd = { "postgres_lsp" },
        filetypes = { "sql" },
        single_file_support = true,
        capabilities = capabilities,
      }

      -- Enable LSP servers
      vim.lsp.enable("lua_ls")

      -- Only enable one of vtsls or denols based on project type
      -- Check if current buffer's directory has deno markers
      local function is_deno_project(bufnr)
        local fname = vim.api.nvim_buf_get_name(bufnr or 0)
        if fname == "" then
          return false
        end
        local deno_markers = { "deno.json", "deno.jsonc", "deno.lock" }
        for _, marker in ipairs(deno_markers) do
          local found = vim.fs.find(marker, { path = fname, upward = true })
          if found and #found > 0 then
            return true
          end
        end
        return false
      end

      -- Create autocmd to conditionally enable vtsls or denols
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
        callback = function(args)
          if is_deno_project(args.buf) then
            vim.lsp.enable("denols")
          else
            vim.lsp.enable("vtsls")
          end
        end,
      })

      vim.lsp.enable("eslint")
      vim.lsp.enable("postgres_lsp")
    end,
  },
}
