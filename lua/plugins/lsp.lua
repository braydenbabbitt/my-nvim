-- LSP Configuration
-- Language Server Protocol setup with multiple language servers

-- ===================================================================
-- CENTRALIZED SERVER LIST
-- ===================================================================
-- Add or remove servers here to enable/disable them globally
local servers = {
  "lua_ls",
  "vtsls",
  "eslint",
  "denols",
  "tailwindcss",
  "basedpyright",
  "postgres_lsp", -- Note: not available via mason, install manually
}

-- Servers available via Mason (excludes postgres_lsp)
local mason_servers = vim.tbl_filter(function(server)
  return server ~= "postgres_lsp"
end, servers)

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
    opts = function()
      return {
        ensure_installed = mason_servers,
        automatic_installation = true,
      }
    end,
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
            vim.keymap.set(
              "n",
              keys,
              func,
              { buffer = event.buf, desc = "LSP: " .. desc, noremap = true, silent = true }
            )
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

      -- ===================================================================
      -- SERVER DEFINITIONS
      -- ===================================================================

      -- Lua Language Server
      vim.lsp.config.lua_ls = {
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        root_markers = {
          { ".luarc.json", ".luarc.jsonc" }, -- Equal priority
          ".luacheckrc",
          { ".stylua.toml", "stylua.toml" }, -- Equal priority
          { "selene.toml", "selene.yml" }, -- Equal priority
          ".git",
        },
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
      -- Uses root_dir function to exclude Deno projects
      vim.lsp.config.vtsls = {
        cmd = { "vtsls", "--stdio" },
        filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
        root_markers = { "package.json" },
        single_file_support = false,
        capabilities = capabilities,
        -- Custom root_dir to skip Deno projects
        root_dir = function(bufnr, on_dir)
          local fname = vim.api.nvim_buf_get_name(bufnr)
          if fname == "" then
            on_dir(nil)
            return
          end

          -- Skip if this is a Deno project
          local deno_markers = vim.fs.find({ "deno.json", "deno.jsonc", "deno.lock" }, {
            path = fname,
            upward = true,
          })
          if #deno_markers > 0 then
            on_dir(nil)
            return
          end

          -- Find package.json
          local markers = vim.fs.find({ "package.json" }, {
            path = fname,
            upward = true,
          })
          on_dir(markers[1] and vim.fs.dirname(markers[1]) or nil)
        end,
      }

      -- Deno
      vim.lsp.config.denols = {
        cmd = { "deno", "lsp" },
        filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
        root_markers = { "deno.json", "deno.jsonc", "deno.lock" },
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
        root_markers = {
          ".eslintrc.js",
          ".eslintrc.cjs",
          ".eslintrc.yaml",
          ".eslintrc.yml",
          ".eslintrc.json",
          "eslint.config.js",
          "eslint.config.mjs",
          "eslint.config.cjs",
          "package.json",
        },
        capabilities = capabilities,
        settings = {
          workingDirectories = { mode = "auto" },
          packageManager = "pnpm",
        },
      }

      -- Tailwind CSS
      vim.lsp.config.tailwindcss = {
        cmd = { "tailwindcss-language-server", "--stdio" },
        filetypes = {
          "astro",
          "go",
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
          "react",
          "vue",
          "svelte",
          "html",
        },
        root_markers = {
          { "tailwind.config.js", "tailwind.config.ts" }, -- Equal priority
          "package.json",
        },
        capabilities = capabilities,
        settings = {
          tailwindCSS = {
            experimental = {
              -- Useful for libraries like cva/class-variance-authority
              classRegex = {
                { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
                { "cx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
              },
            },
          },
        },
      }

      -- PostgreSQL
      vim.lsp.config.postgres_lsp = {
        cmd = { "postgres_lsp" },
        filetypes = { "sql" },
        single_file_support = true,
        capabilities = capabilities,
      }

      -- Python (basedpyright)
      vim.lsp.config.basedpyright = {
        cmd = { "basedpyright-langserver", "--stdio" },
        filetypes = { "python" },
        root_markers = {
          "pyproject.toml",
          "setup.py",
          "setup.cfg",
          "requirements.txt",
          "Pipfile",
          "pyrightconfig.json",
          ".git",
        },
        single_file_support = true,
        capabilities = capabilities,
        settings = {
          basedpyright = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "openFilesOnly",
              useLibraryCodeForTypes = true,
            },
          },
        },
      }

      -- ===================================================================
      -- SERVER ACTIVATION
      -- ===================================================================

      -- Enable all LSP servers from the centralized list
      -- They will auto-attach based on filetypes and root_markers
      vim.lsp.enable(servers)

      -- ===================================================================
      -- MODERN 0.11 FEATURES
      -- ===================================================================

      -- Auto-fold imports on file open
      -- Configure which filetypes to exclude from auto-folding
      local auto_fold_exclude_filetypes = {
        -- Uncomment to exclude specific filetypes:
        -- 'python',
        -- 'lua',
        -- 'javascript',
        -- 'typescript',
      }

      vim.api.nvim_create_autocmd("LspNotify", {
        group = vim.api.nvim_create_augroup("lsp-auto-fold-imports", { clear = true }),
        callback = function(args)
          if args.data.method == "textDocument/didOpen" then
            local bufnr = args.buf
            local ft = vim.bo[bufnr].filetype

            -- Skip if filetype is in exclude list
            if vim.tbl_contains(auto_fold_exclude_filetypes, ft) then
              return
            end

            local winid = vim.fn.bufwinid(bufnr)
            if winid ~= -1 then
              vim.lsp.foldclose("imports", winid)
            end
          end
        end,
      })

      -- Set up LSP-based folding for supported servers
      vim.o.foldmethod = "expr"
      vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- Default to treesitter

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-folding", { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client:supports_method("textDocument/foldingRange") then
            local bufnr = args.buf
            local winid = vim.api.nvim_get_current_win()
            -- Prefer LSP folding over treesitter when available
            vim.wo[winid][bufnr].foldexpr = "v:lua.vim.lsp.foldexpr()"
          end
        end,
      })
    end,
  },
}
