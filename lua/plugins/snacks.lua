-- Snacks.nvim - Collection of useful utilities
-- Provides dashboard, terminal, picker, bufdelete, etc.

return {
  "folke/snacks.nvim",
  commit = "d67a477",
  priority = 1000,
  lazy = false,
  opts = {
    -- Disable animations (set in options.lua via vim.g.snacks_animate)
    bigfile = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    statusline = { enabled = false }, -- Disable Snacks statusline (using lualine instead)

    -- Dashboard configuration
    dashboard = {
      enabled = true,
      preset = {
        header = [[
██████╗ ██████╗  █████╗ ██╗   ██╗██╗   ██╗██╗███╗   ███╗
██╔══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝██║   ██║██║████╗ ████║
██████╔╝██████╔╝███████║ ╚████╔╝ ██║   ██║██║██╔████╔██║
██╔══██╗██╔══██╗██╔══██║  ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║
██████╔╝██║  ██║██║  ██║   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║
╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝
]],
      },
    },

    -- File picker configuration
    picker = {
      enabled = true,
      sources = {
        explorer = {
          auto_close = true,
          git_status_open = false,
          hidden = true,
          ignored = true,
        },
      },
    },

    -- Terminal configuration
    terminal = {
      enabled = true,
      win = {
        wo = {
          winbar = "",
        },
      },
    },
  },
  keys = {
    -- Dashboard
    {
      "<leader>.",
      function()
        Snacks.scratch()
      end,
      desc = "Toggle Scratch Buffer",
    },
    {
      "<leader>S",
      function()
        Snacks.scratch.select()
      end,
      desc = "Select Scratch Buffer",
    },

    -- Notifications
    {
      "<leader>un",
      function()
        Snacks.notifier.hide()
      end,
      desc = "Dismiss All Notifications",
    },
    {
      "<leader>nh",
      function()
        Snacks.notifier.show_history()
      end,
      desc = "Notification History",
    },

    -- Buffer management
    {
      "<leader>bd",
      function()
        Snacks.bufdelete()
      end,
      desc = "Delete Buffer",
    },
    {
      "<leader>bo",
      function()
        Snacks.bufdelete.other()
      end,
      desc = "Delete Other Buffers",
    },

    -- Git utilities
    {
      "<leader>gg",
      function()
        Snacks.lazygit()
      end,
      desc = "Lazygit",
    },
    {
      "<leader>gb",
      function()
        Snacks.git.blame_line()
      end,
      desc = "Git Blame Line",
    },
    {
      "<leader>gB",
      function()
        Snacks.gitbrowse()
      end,
      desc = "Git Browse",
    },

    -- File picker/explorer
    {
      "<leader>e",
      function()
        Snacks.picker.explorer()
      end,
      desc = "Explorer (Snacks)",
    },

    -- Search/Grep
    {
      "<leader>/",
      function()
        Snacks.picker.grep()
      end,
      desc = "Grep (Snacks)",
    },

    -- Profiler keymaps (moved from blackhole-delete config)
    {
      "<leader>Dps",
      function()
        Snacks.profiler.scratch()
      end,
      desc = "Profiler Scratch Buffer",
    },
    {
      "<leader>Dpp",
      function()
        Snacks.toggle.profiler()
      end,
      desc = "Snacks profiler",
    },
    {
      "<leader>Dph",
      function()
        Snacks.toggle.profiler_highlights()
      end,
      desc = "Snacks profiler highlights",
    },
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Setup some globals for convenience
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
        vim.print = _G.dd

        -- Create some toggle commands
        Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
        Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
        Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
        Snacks.toggle.diagnostics():map("<leader>ud")
        Snacks.toggle.line_number():map("<leader>ul")
        Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map(
          "<leader>uc"
        )
        Snacks.toggle.treesitter():map("<leader>uT")
        Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
        Snacks.toggle.inlay_hints():map("<leader>uh")
      end,
    })
  end,
}
