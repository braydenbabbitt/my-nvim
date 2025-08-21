local default_adapter = "copilot"
local default_model = "gpt-4.1"

return {
  {
    "olimorris/codecompanion.nvim",
    opts = {
      strategies = {
        chat = {
          adapter = default_adapter,
          model = default_model,
          keymaps = {
            send = {
              modes = {
                n = "<CR>",
                i = "<C-s>",
              },
            },
            close = {
              modes = {
                n = { "<Esc>", "q" },
                i = "<C-c>",
              },
            },
            regenerate = {
              modes = {
                n = "<leader>ar",
              },
            },
            stop = {
              modes = {
                n = "<leader>as",
                i = "<C-q>",
              },
            },
            clear = {
              modes = {
                n = "<leader>ac",
              },
            },
            codeblock = {
              modes = {
                n = "<leader>aC",
              },
            },
            yank_code = {
              modes = {
                n = "<leader>ay",
              },
            },
            pin = {
              modes = {
                n = "<leader>aP",
              },
            },
            watch = {
              modes = {
                n = "<leader>aw",
              },
            },
            change_adapter = {
              modes = {
                n = "<leader>aA",
              },
            },
            fold_code = {
              modes = {
                n = "<leader>az",
              },
            },
            debug = {
              modes = {
                n = "<leader>ad",
              },
            },
            system_prompt = {
              modes = {
                n = "<leader>aS",
              },
            },
            auto_tool_mode = {
              modes = {
                n = "<leader>att",
              },
            },
            goto_file_under_cursor = {
              modes = {
                n = "<leader>agd",
              },
            },
            copilot_stats = {
              modes = {
                n = "<leader>aI",
              },
            },
            super_diff = {
              modes = {
                n = "<leader>aD",
              },
            },
          },
        },
        inline = {
          adapter = default_adapter,
          model = default_model,
          keymaps = {
            accept_change = {
              modes = {
                n = "<leader>a<CR>",
              },
            },
            reject_change = {
              modes = {
                n = "<leader>ad",
              },
            },
            always_accept = {
              modes = {
                n = "<leader>aa",
              },
            },
          },
        },
        cmd = {
          adapter = default_model,
        },
      },
      extensions = {
        mcphub = {
          callback = "mcphub.extensions.codecompanion",
          opts = {
            make_vars = true,
            make_slash_commands = true,
            show_result_in_chat = true,
            show_server_tools_in_chat = true,
          },
        },
        history = {
          enabled = true,
          opts = {
            keymap = "<leader>h",
            expiration_days = 30,
            summary = {
              create_summary_keymap = "<leader>Sc",
              browse_summary_keymap = "<leader>Sb",
            },
          },
        },
      },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "ravitemer/mcphub.nvim",
      "ravitemer/codecompanion-history.nvim",
    },
  },
}
