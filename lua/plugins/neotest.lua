-- Neotest - Testing Framework for Neovim
-- A framework for interacting with tests within NeoVim

return {
  {
    "nvim-neotest/neotest",
    commit = "deadfb1",
    dependencies = {
      {
        "nvim-neotest/nvim-nio",
        commit = "a428f30",
      },
      "nvim-lua/plenary.nvim",
      {
        "antoinemadec/FixCursorHold.nvim",
        commit = "1bfb32e",
      },
      "nvim-treesitter/nvim-treesitter",

      -- Test adapters
      {
        "marilari88/neotest-vitest",
      },
      {
        "thenbe/neotest-playwright",
        commit = "6266945",
      },
      {
        "nvim-neotest/neotest-python",
        commit = "c969a5b",
      },
      {
        "nvim-neotest/neotest-go",
        commit = "59b5050",
      },
    },
    keys = {
      -- Run tests
      {
        "<leader>tr",
        function()
          require("neotest").run.run()
        end,
        desc = "Run Nearest Test",
      },
      {
        "<leader>tf",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "Run Current File",
      },
      {
        "<leader>tA",
        function()
          require("neotest").run.run(vim.fn.getcwd())
        end,
        desc = "Run All Tests",
      },
      {
        "<leader>tl",
        function()
          require("neotest").run.run_last()
        end,
        desc = "Run Last Test",
      },
      -- Debug tests
      {
        "<leader>td",
        function()
          require("neotest").run.run({ strategy = "dap" })
        end,
        desc = "Debug Nearest Test",
      },
      {
        "<leader>tD",
        function()
          require("neotest").run.run({ vim.fn.expand("%"), strategy = "dap" })
        end,
        desc = "Debug Current File",
      },
      -- UI controls
      {
        "<leader>ts",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Toggle Summary",
      },
      {
        "<leader>to",
        function()
          require("neotest").output.open({ enter = true, auto_close = true })
        end,
        desc = "Show Output",
      },
      {
        "<leader>tO",
        function()
          require("neotest").output_panel.toggle()
        end,
        desc = "Toggle Output Panel",
      },
      -- Stop tests
      {
        "<leader>tS",
        function()
          require("neotest").run.stop()
        end,
        desc = "Stop Tests",
      },
      -- Watch mode
      {
        "<leader>tw",
        function()
          require("neotest").watch.toggle(vim.fn.expand("%"))
        end,
        desc = "Watch Current File",
      },
      {
        "<leader>tW",
        function()
          require("neotest").watch.toggle()
        end,
        desc = "Watch Nearest Test",
      },
      -- Navigation
      {
        "[t",
        function()
          require("neotest").jump.prev({ status = "failed" })
        end,
        desc = "Jump to Previous Failed Test",
      },
      {
        "]t",
        function()
          require("neotest").jump.next({ status = "failed" })
        end,
        desc = "Jump to Next Failed Test",
      },
    },
    opts = function()
      return {
        adapters = {
          -- Vitest adapter for JavaScript/TypeScript
          require("neotest-vitest")({
            -- Filter directories to improve performance
            filter_dir = function(name, rel_path, root)
              return name ~= "node_modules"
            end,
            -- Vitest-specific settings
            vitestCommand = "npx vitest",
            vitestConfigFile = function()
              -- Try to find vitest config
              local config_files = {
                "vitest.config.ts",
                "vitest.config.js",
                "vite.config.ts",
                "vite.config.js",
              }
              for _, config_file in ipairs(config_files) do
                if vim.fn.filereadable(config_file) == 1 then
                  return config_file
                end
              end
              return nil
            end,
            -- Enable watch mode for continuous testing
            is_test_file = function(file_path)
              return string.match(file_path, "%.test%.") ~= nil or string.match(file_path, "%.spec%.") ~= nil
            end,
          }),

          -- Playwright adapter for E2E tests
          require("neotest-playwright").adapter({
            options = {
              persist_project_selection = true,
              enable_dynamic_test_discovery = true,
              -- Filter to only run playwright tests
              is_test_file = function(file_path)
                return string.match(file_path, "%.e2e%.") ~= nil or string.match(file_path, "%.playwright%.") ~= nil
              end,
            },
          }),

          -- Python pytest adapter
          require("neotest-python")({
            -- Use virtualenv if available
            python = function()
              local cwd = vim.fn.getcwd()
              if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
                return cwd .. "/venv/bin/python"
              elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
                return cwd .. "/.venv/bin/python"
              else
                return "python3"
              end
            end,
            -- pytest arguments
            args = { "--log-level", "DEBUG", "--quiet" },
            runner = "pytest",
            -- Use pytest discovery
            pytest_discover_instances = true,
          }),

          -- Go test adapter
          require("neotest-go")({
            experimental = {
              test_table = true,
            },
            args = { "-count=1", "-timeout=60s", "-race", "-cover" },
            -- Go-specific test detection
            is_test_file = function(file_path)
              return string.match(file_path, "_test%.go$") ~= nil
            end,
          }),
        },

        -- Benchmark support
        benchmark = {
          enabled = true,
        },

        -- Consumer configuration
        consumers = {},

        -- Default strategy for running tests
        default_strategy = "integrated",

        -- Diagnostic configuration
        diagnostic = {
          enabled = true,
          severity = vim.diagnostic.severity.ERROR,
        },

        -- Discovery configuration
        discovery = {
          enabled = true,
          concurrent = 1,
        },

        -- Floating window configuration
        floating = {
          border = "rounded",
          max_height = 0.8,
          max_width = 0.9,
          options = {},
        },

        -- Highlight configuration
        highlights = {
          adapter_name = "NeotestAdapterName",
          border = "NeotestBorder",
          dir = "NeotestDir",
          expand_marker = "NeotestExpandMarker",
          failed = "NeotestFailed",
          file = "NeotestFile",
          focused = "NeotestFocused",
          indent = "NeotestIndent",
          marked = "NeotestMarked",
          namespace = "NeotestNamespace",
          passed = "NeotestPassed",
          running = "NeotestRunning",
          select_win = "NeotestWinSelect",
          skipped = "NeotestSkipped",
          target = "NeotestTarget",
          test = "NeotestTest",
          unknown = "NeotestUnknown",
          watching = "NeotestWatching",
        },

        -- Icons
        icons = {
          child_indent = "│",
          child_prefix = "├",
          collapsed = "─",
          expanded = "╮",
          failed = "",
          final_child_indent = " ",
          final_child_prefix = "╰",
          non_collapsible = "─",
          passed = "",
          running = "",
          running_animated = { "/", "|", "\\", "-", "/", "|", "\\", "-" },
          skipped = "",
          unknown = "",
          watching = "",
        },

        -- Jump configuration
        jump = {
          enabled = true,
        },

        -- Log level
        log_level = vim.log.levels.WARN,

        -- Output configuration
        output = {
          enabled = true,
          open_on_run = false,
        },

        -- Output panel configuration
        output_panel = {
          enabled = true,
          open = "botright split | resize 15",
        },

        -- Projects configuration
        projects = {},

        -- Quickfix configuration
        quickfix = {
          enabled = true,
          open = false,
        },

        -- Run configuration
        run = {
          enabled = true,
        },

        -- Running configuration
        running = {
          concurrent = true,
        },

        -- State configuration
        state = {
          enabled = true,
        },

        -- Status configuration
        status = {
          enabled = true,
          virtual_text = false,
          signs = true,
        },

        -- Strategies
        strategies = {
          integrated = {
            height = 40,
            width = 120,
          },
        },

        -- Summary window configuration
        summary = {
          enabled = true,
          expand_errors = true,
          follow = true,
          mappings = {
            attach = "a",
            clear_marked = "M",
            clear_target = "T",
            debug = "d",
            debug_marked = "D",
            expand = { "<CR>", "<2-LeftMouse>" },
            expand_all = "e",
            jumpto = "i",
            mark = "m",
            next_failed = "J",
            output = "o",
            prev_failed = "K",
            run = "r",
            run_marked = "R",
            short = "O",
            stop = "u",
            target = "t",
            watch = "w",
          },
          open = "botright vsplit | vertical resize 50",
        },

        -- Watch configuration
        watch = {
          enabled = true,
          symbol_queries = {
            go = "        ;query\n        ; ;Captures imported types\n        (qualified_type name: (type_identifier) @symbol)\n        ; ;Captures package-local and built-in types\n        (type_identifier)@symbol\n        ; ;Captures imported function calls and variables/constants\n        (selector_expression field: (field_identifier) @symbol)\n        ; ;Captures package-local functions calls\n        (call_expression function: (identifier) @symbol)\n      ",
            javascript = '  ;; query\n  ;; Captures named imports\n  (import_specifier name: (identifier) @symbol)\n  ;; Captures default import\n  (import_clause (identifier) @symbol)\n  ;; Capture require statements\n  (variable_declarator \n  name: (identifier) @symbol\n  value: (call_expression (identifier) @function  (#eq? @function "require")))\n  ;; Capture namespace imports\n  (namespace_import (identifier) @symbol)\n',
            lua = '        ;; query\n        ;; Captures module names in require calls\n        (function_call\n          name: ((identifier) @function (#eq? @function "require"))\n          arguments: (arguments (string) @symbol))\n      ',
            python = "        ;query\n        ;; Captures imports and modules they're imported from\n        (import_from_statement (_ (identifier) @symbol))\n        (import_statement (_ (identifier) @symbol))\n      ",
            ruby = '        ;; query\n        ;; rspec - class name\n        (call\n          method: (identifier) @_ (#match? @_ "^(describe|context)")\n          arguments: (argument_list (constant) @symbol )\n        )\n\n        ;; rspec - namespaced class name\n        (call\n          method: (identifier)\n          arguments: (argument_list\n            (scope_resolution\n              name: (constant) @symbol))\n        )\n      ',
            rust = "        ;; query\n        ;; Captures imported names\n        (use_declaration argument: (scoped_identifier name: (identifier) @symbol))\n      ",
            tsx = '  ;; query\n  ;; Captures named imports\n  (import_specifier name: (identifier) @symbol)\n  ;; Captures default import\n  (import_clause (identifier) @symbol)\n  ;; Capture require statements\n  (variable_declarator \n  name: (identifier) @symbol\n  value: (call_expression (identifier) @function  (#eq? @function "require")))\n  ;; Capture namespace imports\n  (namespace_import (identifier) @symbol)\n',
            typescript = '  ;; query\n  ;; Captures named imports\n  (import_specifier name: (identifier) @symbol)\n  ;; Captures default import\n  (import_clause (identifier) @symbol)\n  ;; Capture require statements\n  (variable_declarator \n  name: (identifier) @symbol\n  value: (call_expression (identifier) @function  (#eq? @function "require")))\n  ;; Capture namespace imports\n  (namespace_import (identifier) @symbol)\n',
          },
        },
      }
    end,
    config = function(_, opts)
      -- Setup neotest with adapters
      require("neotest").setup(opts)

      -- Set up signs for test status
      vim.fn.sign_define("neotest_passed", {
        text = "",
        texthl = "NeotestPassed",
      })
      vim.fn.sign_define("neotest_failed", {
        text = "",
        texthl = "NeotestFailed",
      })
      vim.fn.sign_define("neotest_running", {
        text = "",
        texthl = "NeotestRunning",
      })
      vim.fn.sign_define("neotest_skipped", {
        text = "",
        texthl = "NeotestSkipped",
      })

      -- Set highlight groups
      vim.api.nvim_set_hl(0, "NeotestPassed", { fg = "#98c379" })
      vim.api.nvim_set_hl(0, "NeotestFailed", { fg = "#e06c75" })
      vim.api.nvim_set_hl(0, "NeotestRunning", { fg = "#e5c07b" })
      vim.api.nvim_set_hl(0, "NeotestSkipped", { fg = "#61afef" })
    end,
  },
}
