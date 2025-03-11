return {
  {
    "neovim/nvim-lspconfig",
    version = "1.7.0",
    dependencies = {
      { "williamboman/mason.nvim", opts = {} },
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      { "j-hui/fidget.nvim", opts = {} },

      -- Allows extra capabilities provided by nvim-cmp
      "hrsh7th/cmp-nvim-lsp",
    },
    opts = {
      servers = {
        eslint = {
          settings = {
            workingDirectories = { mode = "auto" },
            format = true,
          },
        },
      },
      setup = {
        eslint = function()
          local get_clients = function(opts)
            local ret = {}
            if vim.lsp.get_clients then
              ret = vim.lsp.get_clients(opts)
            else
              ret = vim.lsp.get_active_clients(opts)
              if opts and opts.method then
                ret = vim.tbl_filter(function(client)
                  return client.supports_method(opts.method, { bufnr = opts.bufnr })
                end, ret)
              end
            end
            return opts and opts.filter and vim.tbl_filter(opts.filter, ret) or ret
          end

          local function get_client(buf)
            return get_clients({ name = "eslint", bufnr = buf })[1]
          end

          local Plugin = require("lazy.core.plugin")
          local conform_format = Plugin.values("conform.nvim", "opts", false).format

          local format = function(opts)
            opts = vim.tbl_deep_extend("force", {}, opts or {}, conform_format)
          end

          local get_formatter = function(opts)
            opts = opts or {}
            local filter = opts.filter or {}
            filter = type(filter) == "string" and { name = filter } or filter

            local ret = {
              name = "LSP",
              primary = true,
              priority = 1,
              format = function(buf)
                format(vim.tbl_deep_extend("force", {}, filter, { bufnr = buf }))
              end,
              sources = function(buf)
                local clients = get_clients(vim.tbl_deep_extend("force", filter, { bufnr = buf }))

                local ret = vim.tbl_filter(function(client)
                  return client.supports_method("textDocument/formatting")
                    or client.supports_method("textDocument/rangeFormatting")
                end, clients)

                return vim.tbl_map(function(client)
                  return client.name
                end, ret)
              end,
            }

            return vim.tbl_deep_extend("force", ret, opts)
          end

          local formatter = get_formatter({
            name = "eslint: lsp",
            primary = false,
            priority = 200,
            filter = "eslint",
          })

          if not pcall(require, "vim.lsp._dynamic") then
            formatter.name = "eslint: EslintFixAll"
            formatter.sources = function(buf)
              local client = get_client(buf)
              return client and { "eslint" } or {}
            end
            formatter.format = function(buf)
              local client = get_client(buf)
              if client then
                local diag = vim.diagnostic.get(buf, { namespace = vim.lsp.diagnostic.get_namespace(client.id) })
                if #diag > 0 then
                  vim.cmd("EslintFixAll")
                end
              end
            end
          end
        end,
      },
    },
    config = function(opts)
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
        callback = function(event)
          local test = "test"

          test = "true"

          if test then
            test = ""
          end

          local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end
          map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
          map("<leader>gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

          map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
          map("<leader>gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

          map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
          map("<leader>gi", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

          map("<leader>gy", require("telescope.builtin").lsp_type_definitions, "[G]oto Type Defition")

          map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

          map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

          map("<leader>cr", vim.lsp.buf.rename, "[R]ename Variable")

          map("<leader>ca", vim.lsp.buf.code_action, "Code [A]ction", { "n", "x" })

          map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
          map("<leader>gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

          -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
          ---@param client vim.lsp.Client
          ---@param method vim.lsp.protocol.Method
          ---@param bufnr? integer some lsp support methods only in specific files
          ---@return boolean
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has("nvim-0.11") == 1 then
              return client:supports_method(method, bufnr)
            else
              ---@diagnostic disable-next-line: param-type-mismatch
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          -- Autocommands used to highlight references of the word under the cursor
          -- when the cursor rests on it for a short time.
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if
            client
            and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
          then
            local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
              group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
              end,
            })
          end

          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map("<leader>lh", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end, "Toggle Inlay [H]ints")
          end
        end,
      })

      vim.diagnostic.config({
        severity_sort = true,
        float = { border = "rounded", source = "if_many" },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.INFO] = "󰋽 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
          },
        } or {},
        virtual_text = {
          source = "if_many",
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      })

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
      local util = require("lspconfig.util")

      local servers = {
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
          inlay_hints = {
            enabled = false,
          },
          filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact" },
          single_file_support = false,
        },
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = "Replace",
              },
            },
          },
        },
      }

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        "stylua",
      })
      require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

      require("mason-lspconfig").setup({
        ensure_installed = {},
        automatic_installation = false,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
            require("lspconfig")[server_name].setup(server)
          end,
        },
      })

      require("nvim-lspconfig").setup(opts)
    end,
  },
}
