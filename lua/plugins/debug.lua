-- Debug Adapter Protocol (DAP) Configuration
-- Debugging support for multiple languages with UI and virtual text

return {
  -- Core DAP plugin
  {
    "mfussenegger/nvim-dap",
    commit = "085386b",
    dependencies = {
      -- DAP UI for a better debugging experience
      {
        "rcarriga/nvim-dap-ui",
        commit = "cf91d5e",
        dependencies = {
          {
            "nvim-neotest/nvim-nio",
            commit = "a428f30",
          },
        },
      },
      -- Virtual text support (inline variable values)
      {
        "theHamsta/nvim-dap-virtual-text",
        commit = "d7c695e",
        opts = {
          enabled = true,
          enabled_commands = true,
          highlight_changed_variables = true,
          highlight_new_as_changed = false,
          show_stop_reason = true,
          commented = false,
          only_first_definition = true,
          all_references = false,
          virt_text_pos = "eol", -- Position: 'eol' | 'overlay' | 'right_align'
          all_frames = false,
          virt_lines = false,
          virt_text_win_col = nil,
        },
      },
      -- Mason integration for DAP
      {
        "jay-babu/mason-nvim-dap.nvim",
        commit = "9a10e09",
        dependencies = { "mason.nvim" },
        cmd = { "DapInstall", "DapUninstall" },
        opts = {
          ensure_installed = {
            "js-debug-adapter", -- JavaScript/TypeScript
            "debugpy", -- Python
            "delve", -- Go
          },
          automatic_installation = true,
          handlers = {}, -- Use default handlers
        },
      },
    },
    keys = {
      -- Breakpoints
      {
        "<leader>Db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Toggle Breakpoint",
      },
      {
        "<leader>DB",
        function()
          require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
        desc = "Conditional Breakpoint",
      },
      {
        "<leader>Dl",
        function()
          require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
        end,
        desc = "Log Point",
      },
      -- Session control
      {
        "<leader>Dc",
        function()
          require("dap").continue()
        end,
        desc = "Continue / Start Debugging",
      },
      {
        "<leader>Dt",
        function()
          require("dap").terminate()
        end,
        desc = "Terminate",
      },
      {
        "<leader>Dr",
        function()
          require("dap").run_last()
        end,
        desc = "Run Last",
      },
      {
        "<leader>Dp",
        function()
          require("dap").pause()
        end,
        desc = "Pause",
      },
      -- Stepping
      {
        "<leader>Di",
        function()
          require("dap").step_into()
        end,
        desc = "Step Into",
      },
      {
        "<leader>Do",
        function()
          require("dap").step_over()
        end,
        desc = "Step Over",
      },
      {
        "<leader>DO",
        function()
          require("dap").step_out()
        end,
        desc = "Step Out",
      },
      {
        "<leader>Dj",
        function()
          require("dap").down()
        end,
        desc = "Down Stack Frame",
      },
      {
        "<leader>Dk",
        function()
          require("dap").up()
        end,
        desc = "Up Stack Frame",
      },
      -- UI controls
      {
        "<leader>Du",
        function()
          require("dapui").toggle()
        end,
        desc = "Toggle DAP UI",
      },
      {
        "<leader>De",
        function()
          require("dapui").eval()
        end,
        mode = { "n", "v" },
        desc = "Evaluate Expression",
      },
      {
        "<leader>DR",
        function()
          require("dap").repl.toggle()
        end,
        desc = "Toggle REPL",
      },
      -- Widgets
      {
        "<leader>Dh",
        function()
          require("dap.ui.widgets").hover()
        end,
        desc = "Hover Variables",
      },
      {
        "<leader>Dw",
        function()
          local widgets = require("dap.ui.widgets")
          widgets.centered_float(widgets.scopes)
        end,
        desc = "Scopes Widget",
      },
      {
        "<leader>Df",
        function()
          local widgets = require("dap.ui.widgets")
          widgets.centered_float(widgets.frames)
        end,
        desc = "Frames Widget",
      },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- ===================================================================
      -- DAP UI Setup
      -- ===================================================================
      dapui.setup({
        icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
        mappings = {
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        element_mappings = {},
        expand_lines = true,
        layouts = {
          {
            -- Left sidebar
            elements = {
              { id = "scopes", size = 0.4 },
              { id = "breakpoints", size = 0.3 },
              { id = "stacks", size = 0.3 },
            },
            size = 40,
            position = "left",
          },
          {
            -- Bottom panel
            elements = {
              { id = "repl", size = 0.5 },
              { id = "console", size = 0.5 },
            },
            size = 10,
            position = "bottom",
          },
        },
        controls = {
          enabled = true,
          element = "repl",
          icons = {
            pause = "",
            play = "",
            step_into = "",
            step_over = "",
            step_out = "",
            step_back = "",
            run_last = "↻",
            terminate = "□",
          },
        },
        floating = {
          max_height = nil,
          max_width = nil,
          border = "rounded",
          mappings = {
            close = { "q", "<Esc>" },
          },
        },
        windows = { indent = 1 },
        render = {
          max_type_length = nil,
          max_value_lines = 100,
        },
      })

      -- Auto-open/close DAP UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- ===================================================================
      -- DAP Signs (Breakpoints, Current Line, etc.)
      -- ===================================================================
      vim.fn.sign_define("DapBreakpoint", {
        text = "",
        texthl = "DiagnosticError",
        linehl = "",
        numhl = "",
      })
      vim.fn.sign_define("DapBreakpointCondition", {
        text = "",
        texthl = "DiagnosticWarn",
        linehl = "",
        numhl = "",
      })
      vim.fn.sign_define("DapBreakpointRejected", {
        text = "",
        texthl = "DiagnosticHint",
        linehl = "",
        numhl = "",
      })
      vim.fn.sign_define("DapLogPoint", {
        text = "",
        texthl = "DiagnosticInfo",
        linehl = "",
        numhl = "",
      })
      vim.fn.sign_define("DapStopped", {
        text = "",
        texthl = "DiagnosticWarn",
        linehl = "DapStoppedLine",
        numhl = "",
      })

      -- Highlight for stopped line
      vim.api.nvim_set_hl(0, "DapStoppedLine", { bg = "#3d3d3d" })

      -- ===================================================================
      -- Language-Specific Adapter Configurations
      -- ===================================================================

      -- JavaScript/TypeScript (Node.js)
      -- Uses vscode-js-debug adapter
      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "js-debug-adapter",
          args = { "${port}" },
        },
      }

      -- JavaScript/TypeScript configurations
      for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
        dap.configurations[language] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
            sourceMaps = true,
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
            sourceMaps = true,
          },
          {
            type = "pwa-node",
            request = "launch",
            name = "Debug Jest Tests",
            runtimeExecutable = "node",
            runtimeArgs = {
              "./node_modules/jest/bin/jest.js",
              "--runInBand",
            },
            rootPath = "${workspaceFolder}",
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            internalConsoleOptions = "neverOpen",
          },
          {
            type = "pwa-node",
            request = "launch",
            name = "Debug Vitest Tests",
            runtimeExecutable = "node",
            runtimeArgs = {
              "./node_modules/vitest/vitest.mjs",
              "--run",
              "${file}",
            },
            rootPath = "${workspaceFolder}",
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            internalConsoleOptions = "neverOpen",
          },
        }
      end

      -- Python
      -- Uses debugpy adapter
      dap.adapters.python = function(cb, config)
        if config.request == "attach" then
          local port = (config.connect or config).port
          local host = (config.connect or config).host or "127.0.0.1"
          cb({
            type = "server",
            port = assert(port, "`connect.port` is required for a python `attach` configuration"),
            host = host,
            options = {
              source_filetype = "python",
            },
          })
        else
          cb({
            type = "executable",
            command = vim.fn.exepath("debugpy-adapter"),
            options = {
              source_filetype = "python",
            },
          })
        end
      end

      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          pythonPath = function()
            -- Use virtualenv if available
            local cwd = vim.fn.getcwd()
            if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
              return cwd .. "/venv/bin/python"
            elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
              return cwd .. "/.venv/bin/python"
            else
              return "/usr/bin/python3"
            end
          end,
        },
        {
          type = "python",
          request = "launch",
          name = "Launch file with arguments",
          program = "${file}",
          args = function()
            local args_string = vim.fn.input("Arguments: ")
            return vim.split(args_string, " +")
          end,
          pythonPath = function()
            local cwd = vim.fn.getcwd()
            if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
              return cwd .. "/venv/bin/python"
            elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
              return cwd .. "/.venv/bin/python"
            else
              return "/usr/bin/python3"
            end
          end,
        },
        {
          type = "python",
          request = "attach",
          name = "Attach remote",
          connect = function()
            local host = vim.fn.input("Host [127.0.0.1]: ")
            host = host ~= "" and host or "127.0.0.1"
            local port = tonumber(vim.fn.input("Port [5678]: ")) or 5678
            return { host = host, port = port }
          end,
        },
      }

      -- Go
      -- Uses delve adapter
      dap.adapters.delve = {
        type = "server",
        port = "${port}",
        executable = {
          command = "dlv",
          args = { "dap", "-l", "127.0.0.1:${port}" },
        },
      }

      dap.configurations.go = {
        {
          type = "delve",
          name = "Debug",
          request = "launch",
          program = "${file}",
        },
        {
          type = "delve",
          name = "Debug test (go.mod)",
          request = "launch",
          mode = "test",
          program = "./${relativeFileDirname}",
        },
        {
          type = "delve",
          name = "Debug test current file",
          request = "launch",
          mode = "test",
          program = "${file}",
        },
      }

      -- Lua (Neovim plugin development)
      -- Uses local-lua-debugger-vscode
      -- Note: Requires manual installation of local-lua-debugger-vscode
      -- Install via: git clone https://github.com/tomblind/local-lua-debugger-vscode.git
      -- Or through Mason once available
      dap.adapters["local-lua"] = {
        type = "executable",
        command = "node",
        args = {
          vim.fn.stdpath("data") .. "/mason/packages/local-lua-debugger-vscode/extension/debugAdapter.js",
        },
        enrich_config = function(config, on_config)
          if not config["extensionPath"] then
            local c = vim.deepcopy(config)
            c.extensionPath = vim.fn.stdpath("data") .. "/mason/packages/local-lua-debugger-vscode/"
            on_config(c)
          else
            on_config(config)
          end
        end,
      }

      dap.configurations.lua = {
        {
          type = "local-lua",
          request = "launch",
          name = "Debug current file (local-lua-dbg, lua)",
          cwd = "${workspaceFolder}",
          program = {
            lua = "lua",
            file = "${file}",
          },
        },
        {
          type = "local-lua",
          request = "launch",
          name = "Debug current file (local-lua-dbg, luajit)",
          cwd = "${workspaceFolder}",
          program = {
            lua = "luajit",
            file = "${file}",
          },
        },
        {
          type = "local-lua",
          request = "launch",
          name = "Debug current file (local-lua-dbg, nvim lua)",
          cwd = "${workspaceFolder}",
          program = {
            command = "nvim",
          },
          args = { "-l", "${file}" },
        },
      }
    end,
  },
}
