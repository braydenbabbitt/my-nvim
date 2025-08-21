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
                n = "ar",
              },
            },
            stop = {
              modes = {
                n = "as",
                i = "<C-q>",
              },
            },
            clear = {
              modes = {
                n = "ac",
              },
            },
            codeblock = {
              modes = {
                n = "aC",
              },
            },
            yank_code = {
              modes = {
                n = "ay",
              },
            },
            pin = {
              modes = {
                n = "ap",
              },
            },
            watch = {
              modes = {
                n = "aw",
              },
            },
            change_adapter = {
              modes = {
                n = "aA",
              },
            },
            fold_code = {
              modes = {
                n = "az",
              },
            },
            debug = {
              modes = {
                n = "ad",
              },
            },
            system_prompt = {
              modes = {
                n = "aS",
              },
            },
            auto_tool_mode = {
              modes = {
                n = "att",
              },
            },
            goto_file_under_cursor = {
              modes = {
                n = "agd",
              },
            },
            copilot_stats = {
              modes = {
                n = "aI",
              },
            },
            super_diff = {
              modes = {
                n = "aD",
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
            keymap = "ah",
            expiration_days = 30,
            summary = {
              create_summary_keymap = "aHsc",
              browse_summary_keymap = "aHsb",
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
