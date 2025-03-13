return {
  {
    "mfussenegger/nvim-dap",
    keys = {
      {
        "<leader>DB",
        function()
          require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
        desc = "Breakpoint Condition",
      },
      {
        "<leader>Db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Toggle Breakpoint",
      },
      {
        "<leader>Dc",
        function()
          require("dap").continue()
        end,
        desc = "Run/Continue",
      },
      {
        "<leader>Da",
        function()
          require("dap").continue({ before = get_args })
        end,
        desc = "Run with Args",
      },
      {
        "<leader>DC",
        function()
          require("dap").run_to_cursor()
        end,
        desc = "Run to Cursor",
      },
      {
        "<leader>Dg",
        function()
          require("dap").goto_()
        end,
        desc = "Go to Line (No Execute)",
      },
      {
        "<leader>Di",
        function()
          require("dap").step_into()
        end,
        desc = "Step Into",
      },
      {
        "<leader>Dj",
        function()
          require("dap").down()
        end,
        desc = "Down",
      },
      {
        "<leader>Dk",
        function()
          require("dap").up()
        end,
        desc = "Up",
      },
      {
        "<leader>Dl",
        function()
          require("dap").run_last()
        end,
        desc = "Run Last",
      },
      {
        "<leader>Do",
        function()
          require("dap").step_out()
        end,
        desc = "Step Out",
      },
      {
        "<leader>DO",
        function()
          require("dap").step_over()
        end,
        desc = "Step Over",
      },
      {
        "<leader>DP",
        function()
          require("dap").pause()
        end,
        desc = "Pause",
      },
      {
        "<leader>Dr",
        function()
          require("dap").repl.toggle()
        end,
        desc = "Toggle REPL",
      },
      {
        "<leader>Ds",
        function()
          require("dap").session()
        end,
        desc = "Session",
      },
      {
        "<leader>Dt",
        function()
          require("dap").terminate()
        end,
        desc = "Terminate",
      },
      {
        "<leader>Dw",
        function()
          require("dap.ui.widgets").hover()
        end,
        desc = "Widgets",
      },
      { "<leader>dB", false },
      {
        "<leader>db",
        false,
      },
      {
        "<leader>dc",
        false,
      },
      {
        "<leader>da",
        false,
      },
      {
        "<leader>dC",
        false,
      },
      {
        "<leader>dg",
        false,
      },
      {
        "<leader>di",
        false,
      },
      {
        "<leader>dj",
        false,
      },
      {
        "<leader>dk",
        false,
      },
      {
        "<leader>dl",
        false,
      },
      {
        "<leader>do",
        false,
      },
      {
        "<leader>dO",
        false,
      },
      {
        "<leader>dP",
        false,
      },
      {
        "<leader>dr",
        false,
      },
      {
        "<leader>ds",
        false,
      },
      {
        "<leader>dt",
        false,
      },
      {
        "<leader>dw",
        false,
      },
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    keys = {
      { "<leader>de", false },
      {
        "<leader>De",
        function()
          require("dapui").eval()
        end,
        desc = "Eval",
        mode = { "n", "v" },
      },
      { "<leader>du", false },
      {
        "<leader>Du",
        function()
          require("dapui").toggle({})
        end,
        desc = "Dap UI",
      },
    },
  },
}
