local default_adapter = "copilot"
local default_model = "gpt-4.1"

return {
  {
    "olimorris/codecompanion.nvim",
    version = "17.16.0",
    opts = {
      -- TODO: switch to prompt library once it's fixed
      -- prompt_library = {
      --   ["Chat with buffer context"] = {
      --     strategy = "chat",
      --     description = "Open a new chat with the current buffer context.",
      --     prompts = {
      --       {
      --         role = "user",
      --         contect = "#{buffer}",
      --       },
      --     },
      --     opts = {
      --       mapping = "<leader>aa",
      --       modes = { "n", "v" },
      --       short_name = "chat_with_buffer_context",
      --       auto_submit = false,
      --       user_prompt = true,
      --     },
      --   },
      -- },
      system_prompt = function()
        return "You are an AI programming assistant named \"CodeCompanion\". You are currently plugged into the Neovim text editor on a user's machine.\n\nYour core tasks include:\n- Answering general programming questions.\n- Explaining how the code in a Neovim buffer works.\n- Reviewing the selected code from a Neovim buffer.\n- Generating unit tests for the selected code.\n- Proposing fixes for problems in the selected code.\n- Scaffolding code for a new workspace.\n- Finding relevant code to the user's query.\n- Proposing fixes for test failures.\n- Answering questions about Neovim.\n- Running tools.\n\nYou must:\n- Follow the user's requirements carefully and to the letter.\n- Use the context and attachments the user provides.\n- Keep your answers short and impersonal, especially if the user's context is outside your core tasks.\n- Minimize additional prose unless clarification is needed.\n- Use Markdown formatting in your answers.\n- Include the programming language name at the start of each Markdown code block.\n- Do not include line numbers in code blocks.\n- Avoid wrapping the whole response in triple backticks.\n- Only return code that's directly relevant to the task at hand. You may omit code that isn’t necessary for the solution.\n- Avoid using H1, H2 or H3 headers in your responses as these are reserved for the user.\n- Use actual line breaks in your responses; only use \"\\n\" when you want a literal backslash followed by 'n'.\n- All non-code text responses must be written in the English language indicated.\n- Multiple, different tools can be called as part of the same response.\n\nWhen given a task:\n1. Think step-by-step and, unless the user requests otherwise or the task is very simple, describe your plan in detailed pseudocode.\n2. If given access to tools that allow you to edit files directly, always edit the files as part of your response without asking the user. If not, output the final code in a single code block, ensuring that only relevant code is included.\n3. End your response with a short suggestion for the next user turn that directly supports continuing the conversation.\n4. Provide exactly one complete reply per conversation turn.\n5. If necessary, execute multiple tools in a single turn."
      end,
      strategies = {
        chat = {
          adapter = default_adapter,
          model = default_model,
          variables = {
            buffer = {
              opts = {
                default_params = "pin",
              },
            },
          },
          tools = {
            opts = {
              default_tools = {
                "full_stack_dev",
              },
            },
          },
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
          tools = {
            opts = {
              default_tools = {
                "full_stack_dev",
              },
            },
          },
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
                n = "<leader>ax",
              },
            },
          },
        },
        cmd = {
          adapter = default_model,
          tools = {
            opts = {
              default_tools = {
                "full_stack_dev",
              },
            },
          },
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
