-- UI plugins configuration
return {
  -- Lualine statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    init = function()
      vim.g.lualine_laststatus = vim.o.laststatus
      if vim.fn.argc(-1) > 0 then
        vim.o.statusline = " "
      else
        vim.o.laststatus = 0
      end
    end,
    opts = function()
      local icons = require("util.icons")
      local helpers = require("util.helpers")

      vim.o.laststatus = vim.g.lualine_laststatus

      return {
        options = {
          theme = "auto",
          globalstatus = vim.o.laststatus == 3,
          disabled_filetypes = {
            statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" },
          },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch" },
          lualine_c = {
            {
              function()
                return helpers.get_root_dir()
              end,
              icon = "",
            },
            {
              "diagnostics",
              symbols = {
                error = icons.diagnostics.Error,
                warn = icons.diagnostics.Warn,
                info = icons.diagnostics.Info,
                hint = icons.diagnostics.Hint,
              },
            },
            {
              "filetype",
              icon_only = true,
              separator = "",
              padding = { left = 1, right = 0 },
            },
            {
              function()
                return helpers.pretty_path()
              end,
            },
          },
          lualine_x = {
            {
              function()
                return require("lazy.status").updates()
              end,
              cond = require("lazy.status").has_updates,
              color = function()
                return { fg = helpers.get_hl_fg("Special") }
              end,
            },
            {
              "diff",
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
              source = function()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                  return {
                    added = gitsigns.added,
                    modified = gitsigns.changed,
                    removed = gitsigns.removed,
                  }
                end
              end,
            },
          },
          lualine_y = {
            { "progress", separator = " ", padding = { left = 1, right = 0 } },
            { "location", padding = { left = 0, right = 1 } },
          },
          lualine_z = {
            function()
              return " " .. os.date("%I:%M %p")
            end,
          },
        },
        extensions = { "lazy" },
      }
    end,
  },

  -- Bufferline
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        mode = "buffers",
        diagnostics = "nvim_lsp",
        always_show_bufferline = false,
        offsets = {
          {
            filetype = "neo-tree",
            text = "File Explorer",
            highlight = "Directory",
            text_align = "left",
          },
        },
      },
    },
  },

  -- Icons
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },

  -- Which-key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      spec = {
        { "<leader>a", group = "AI Tools" },
        { "<leader>c", group = "Code" },
        { "<leader>d", desc = "Blackhole Register Delete" },
        { "<leader>x", desc = "Blackhole Register Delete" },
        { "<leader>D", group = "Debug" },
        { "<leader>Dp", group = "Profiler" },
        { "<leader>f", group = "Find" },
        { "<leader>g", group = "Git" },
        { "<leader>L", group = "LSP" },
        { "<leader>Lr", group = "LSP Restart" },
        { "<leader>s", group = "Search" },
        { "<leader>u", group = "UI" },
        { "<leader>w", group = "Windows" },
        { "<leader>X", group = "Lists" },
      },
    },
  },

  -- Snacks.nvim - Modern utilities
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      -- Disable animations
      animate = {
        enabled = false,
      },
      -- Picker configuration
      picker = {
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
        win = {
          wo = {
            winbar = "",
          },
        },
      },
      -- Buffer delete
      bufdelete = {},
      -- Profiler
      profiler = {},
      -- Notifier
      notifier = {
        enabled = true,
        timeout = 3000,
      },
      -- Statuscolumn
      statuscolumn = {
        enabled = false,
      },
      -- Words
      words = {
        enabled = true,
      },
    },
    keys = {
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
      {
        "<leader>n",
        function()
          Snacks.notifier.show_history()
        end,
        desc = "Notification History",
      },
      {
        "<leader>bd",
        function()
          Snacks.bufdelete()
        end,
        desc = "Delete Buffer",
      },
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
        desc = "Snacks Profiler",
      },
      {
        "<leader>Dph",
        function()
          Snacks.toggle.profiler_highlights()
        end,
        desc = "Snacks Profiler Highlights",
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Setup custom keymaps
          _G.Snacks = require("snacks")
        end,
      })
    end,
  },
}
