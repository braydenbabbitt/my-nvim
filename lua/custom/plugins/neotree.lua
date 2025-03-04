return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    branch = "v3.x",
    version = "3.30",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      sources = {
        "filesystem",
        "buffers",
        "git_status",
      },
      filesystem = {
        filtered_items = {
          visible = true,
        },
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false,
        },
        use_libuv_file_watcher = true,
      },
      event_handlers = {
        {
          event = "file_open_requested",
          handler = function()
            require("neo-tree.command").execute({ action = "close" })
          end,
        },
      },
      default_component_configs = {
        indent = {
          with_expanders = false,
          -- expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
        git_status = {
          symbols = {
            unstaged = "󰄱",
            staged = "󰱒",
          },
        },
      },
    },
    keys = {
      {
        "<leader>e",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
        end,
        desc = "Toggle File [E]xplorer",
      },
    },
  },
}
