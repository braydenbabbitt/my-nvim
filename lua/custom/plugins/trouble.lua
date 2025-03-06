return {
  {
    "folke/trouble.nvim",
    version = "3.7.1",
    cmd = { "Trouble" },
    opts = {
      modes = {
        lsp = {
          win = {
            position = "right",
          },
        },
      },
    },
    keys = {
      { "<leader>td", "<cmd>Trouble diagnostics toggle<cr>", desc = "[D]iagnostics" },
      { "<leader>tb", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "[B]uffer Diagnostics" },
      { "<leader>ts", "<cmd>Trouble symbols toggle<cr>", desc = "[S]ymbols" },
      { "<leader>tl", "<cmd>Trouble lsp toggle<cr>", desc = "[L]SP references/definitions/..." },
      { "<leader>tL", "<cmd>Trouble loclist toggle<cr>", desc = "[L]ocation List" },
      { "<leader>tq", "<cmd>Trouble qflist toggle<cr>", desc = "[Q]uickfix List" },
      {
        "<leader>t[",
        function()
          local trouble = require("trouble")
          if trouble.is_open() then
            trouble.prev({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Previous Item",
      },
      {
        "<leader>t]",
        function()
          local trouble = require("trouble")
          if trouble.is_open() then
            trouble.next({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Next Item",
      },
    },
  },
}
