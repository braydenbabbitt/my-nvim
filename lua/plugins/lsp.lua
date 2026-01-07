-- LSP Configuration
-- Language Server Protocol setup with multiple language servers

-- ===================================================================
-- TYPESCRIPT/DENO LSP TOGGLE
-- ===================================================================
-- Helper functions to manage TypeScript LSP preference (vtsls vs denols)
local ts_lsp_state = {
  current = "vtsls", -- default to vtsls
  has_notified_no_git = false, -- track if we've already notified about missing git repo
}

-- Get the state file path for the current git repo
local function get_state_file_path()
  local git_dir = vim.fn.finddir(".git", ".;")
  if git_dir == "" then
    return nil
  end
  local state_dir = vim.fn.fnamemodify(git_dir, ":p:h") .. "/.git/x-lsp"
  return state_dir .. "/ts-lsp.json"
end

-- Read the LSP preference from .git/x-lsp/ts-lsp.json
local function read_ts_lsp_state()
  local state_file = get_state_file_path()
  if not state_file then
    return "vtsls" -- default if not in a git repo
  end

  local file = io.open(state_file, "r")
  if not file then
    return "vtsls" -- default if file doesn't exist
  end

  local content = file:read("*a")
  file:close()

  local ok, decoded = pcall(vim.json.decode, content)
  if ok and decoded and decoded.lsp then
    return decoded.lsp
  end

  return "vtsls" -- default on parse error
end

-- Write the LSP preference to .git/x-lsp/ts-lsp.json
local function write_ts_lsp_state(lsp)
  local state_file = get_state_file_path()
  if not state_file then
    -- Only notify the first time per session
    if not ts_lsp_state.has_notified_no_git then
      vim.notify("Not in a git repository, cannot save LSP state", vim.log.levels.WARN)
      ts_lsp_state.has_notified_no_git = true
    end
    return
  end

  -- Create directory if it doesn't exist
  local state_dir = vim.fn.fnamemodify(state_file, ":h")
  vim.fn.mkdir(state_dir, "p")

  local file = io.open(state_file, "w")
  if not file then
    vim.notify("Failed to write LSP state file", vim.log.levels.ERROR)
    return
  end

  file:write(vim.json.encode({ lsp = lsp }))
  file:close()
end

-- Initialize state from file or detect Deno project
local function initialize_ts_lsp_state()
  -- First check if we have a saved state
  local saved_state = read_ts_lsp_state()
  
  -- If state file exists, use it
  local state_file = get_state_file_path()
  if state_file then
    local file = io.open(state_file, "r")
    if file then
      file:close()
      return saved_state
    end
  end
  
  -- No saved state, check if this is a Deno project
  -- Look for Deno-specific config files in the current directory and upward
  local cwd = vim.fn.getcwd()
  local deno_markers = vim.fs.find({ "deno.json", "deno.jsonc" }, {
    path = cwd,
    upward = true,
  })
  
  if #deno_markers > 0 then
    return "denols"
  end
  
  return "vtsls" -- default to vtsls
end

ts_lsp_state.current = initialize_ts_lsp_state()

-- ===================================================================
-- CENTRALIZED SERVER LIST
-- ===================================================================
-- Add or remove servers here to enable/disable them globally
local servers = {
  "lua_ls",
  "vtsls",
  "eslint",
  -- "denols", -- Disabled by default, use <leader>lt to toggle between vtsls and denols
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

      -- Toggle between vtsls and denols
      vim.keymap.set("n", "<leader>lt", function()
        local new_lsp = ts_lsp_state.current == "vtsls" and "denols" or "vtsls"
        local old_lsp = ts_lsp_state.current

        -- Update state
        ts_lsp_state.current = new_lsp
        write_ts_lsp_state(new_lsp)

        -- Get all TypeScript/JavaScript buffers
        local ts_buffers = {}
        for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_loaded(bufnr) then
            local ft = vim.bo[bufnr].filetype
            if vim.tbl_contains({ "typescript", "javascript", "typescriptreact", "javascriptreact" }, ft) then
              table.insert(ts_buffers, bufnr)
            end
          end
        end

        -- Stop the old LSP client for all TS/JS buffers
        for _, bufnr in ipairs(ts_buffers) do
          local clients = vim.lsp.get_clients({ bufnr = bufnr, name = old_lsp })
          for _, client in ipairs(clients) do
            vim.lsp.stop_client(client.id)
          end
        end

        -- Enable the new LSP
        if new_lsp == "denols" then
          vim.lsp.enable("denols")
        else
          vim.lsp.enable("vtsls")
        end

        -- Restart LSP for all TS/JS buffers
        vim.defer_fn(function()
          for _, bufnr in ipairs(ts_buffers) do
            -- Trigger LSP attach by setting filetype again
            local ft = vim.bo[bufnr].filetype
            vim.bo[bufnr].filetype = ft
          end
          vim.notify(string.format("Switched to %s", new_lsp), vim.log.levels.INFO)
        end, 100)
      end, { desc = "LSP: Toggle TypeScript LSP (vtsls/denols)", noremap = true, silent = true })

      -- Configure diagnostic display
      vim.diagnostic.config({
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.HINT] = "",
            [vim.diagnostic.severity.INFO] = "",
          },
        },
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
      -- Only activates when vtsls is the selected TypeScript LSP
      vim.lsp.config.vtsls = {
        cmd = { "vtsls", "--stdio" },
        filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
        root_markers = { "package.json" },
        single_file_support = false,
        capabilities = capabilities,
        -- Custom root_dir to respect toggle state
        root_dir = function(bufnr, on_dir)
          -- Only activate if vtsls is selected
          if ts_lsp_state.current ~= "vtsls" then
            on_dir(nil)
            return
          end

          local fname = vim.api.nvim_buf_get_name(bufnr)
          if fname == "" then
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
      -- Only activates when denols is the selected TypeScript LSP
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
        -- Custom root_dir to respect toggle state
        root_dir = function(bufnr, on_dir)
          -- Only activate if denols is selected
          if ts_lsp_state.current ~= "denols" then
            on_dir(nil)
            return
          end

          local fname = vim.api.nvim_buf_get_name(bufnr)
          if fname == "" then
            on_dir(nil)
            return
          end

          -- Find deno config files
          local markers = vim.fs.find({ "deno.json", "deno.jsonc", "deno.lock" }, {
            path = fname,
            upward = true,
          })
          on_dir(markers[1] and vim.fs.dirname(markers[1]) or nil)
        end,
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
            -- Set foldexpr for the current window (window-local option)
            vim.wo.foldexpr = "v:lua.vim.lsp.foldexpr()"
          end
        end,
      })
    end,
  },
}
