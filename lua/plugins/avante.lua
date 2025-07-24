local avante_prefix = "<leader>a"

return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = true,
    commit = "bd69ae",
    opts = {
      provider = "copilot",
      providers = {
        copilot = {
          model = "gpt-4.1",
        },
      },
      mappings = {
        ask = avante_prefix .. "A", -- Changed from "a" to "A" to make room for custom mapping
        edit = avante_prefix .. "e",
        refresh = avante_prefix .. "r",
        focus = avante_prefix .. "f",
        toggle = {
          default = avante_prefix .. "t",
          debug = avante_prefix .. "d",
          hint = avante_prefix .. "H",
          suggestion = avante_prefix .. "s",
          repomap = avante_prefix .. "R",
        },
        diff = {
          next = "<down>",
          prev = "<up>",
        },
        files = {
          add_current = avante_prefix .. "F",
        },
        history = avante_prefix .. "h",
      },
      behaviour = {
        auto_suggestions = false, -- Disable this to avoid copilot account suspension until avante fixes the issue
      },
    },
    -- Build command for initial plugin installation
    build = vim.fn.has("win32") == 1 and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
      or "make",
    config = function(_, opts)
      require("avante").setup(opts)
      vim.cmd("AvanteBuild")

      -- Custom keymap for <leader>aa to create new chat and ask
      vim.keymap.set("n", "<leader>aa", function()
        vim.cmd("AvanteChatNew")
        vim.cmd("AvanteToggle")
        vim.cmd("AvanteAsk")
      end, { desc = "Avante: New chat and ask" })
      vim.keymap.set("v", "<leader>aa", function()
        vim.cmd("AvanteChatNew")
        vim.cmd("AvanteToggle")
        vim.cmd("AvanteAsk")
      end, { desc = "Avante: New chat and ask" })
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
      {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            use_absolute_path = true,
          },
        },
      },
      {
        "MeanderingProgrammer/render-markdown.nvim",
        dependencies = {
          "yetone/avante.nvim",
        },
        opts = function(_, opts)
          opts.file_types = opts.file_types or { "markdown", "norg", "rmd", "org" }
          vim.list_extend(opts.file_types, { "Avante" })
        end,
      },
    },
  },
}
