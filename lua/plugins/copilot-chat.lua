return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    cmd = "CopilotChat",
    opts = function()
      local user = vim.env.USER or "User"
      user = user:sub(1, 1):upper() .. user:sub(2)
      return {
        auto_insert_mode = true,
        show_help = true,
        question_header = "  " .. user .. " ",
        answer_header = "  Copilot ",
        window = {
          width = 0.4,
        },
        model = "o1-preview",
        mappings = {
          -- Use tab for completion
          complete = {
            detail = "Use @<Tab> or /<Tab> for options.",
            insert = "<Tab>",
          },
          -- Close the chat
          close = {
            normal = "q",
            insert = "<C-x>",
          },
          -- Reset the chat buffer
          reset = {
            normal = "<C-x>",
            insert = "<C-x>",
          },
          -- Submit the prompt to Copilot
          submit_prompt = {
            normal = "<CR>",
            insert = "<C-CR>",
          },
          -- Accept the diff
          accept_diff = {
            normal = "<C-y>",
            insert = "<C-y>",
          },
          -- Yank the diff in the response to register
          yank_diff = {
            normal = "gmy",
          },
          -- Show the diff
          show_diff = {
            normal = "gmd",
          },
          -- Show the prompt
          show_system_prompt = {
            normal = "gmp",
          },
          -- Show the user selection
          show_user_selection = {
            normal = "gms",
          },
          -- Show help
          show_help = {
            normal = "gmh",
          },
        },
        selection = function(source)
          local select = require("CopilotChat.select")
          return select.visual(source) or select.buffer(source)
        end,
      }
    end,
    keys = {
      { "<c-s>", "<CR>", ft = "copilot-chat", desc = "Submit Prompt", remap = true },
      { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
      {
        "<leader>aa",
        function()
          return require("CopilotChat").toggle()
        end,
        desc = "Toggle (CopilotChat)",
        mode = { "n", "v" },
      },
      {
        "<leader>ax",
        function()
          return require("CopilotChat").reset()
        end,
        desc = "Clear (CopilotChat)",
        mode = { "n", "v" },
      },
      {
        "<leader>aq",
        function()
          local input = vim.fn.input("Quick Chat: ")
          if input ~= "" then
            require("CopilotChat").ask(input)
          end
        end,
        desc = "Quick Chat (CopilotChat)",
        mode = { "n", "v" },
      },
    },
    config = function(_, opts)
      local chat = require("CopilotChat")
      require("CopilotChat.integrations.cmp").setup()

      vim.api.nvim_create_autocmd("BufEnter", {
        pattern = "copilot-chat",
        callback = function()
          vim.opt_local.relativenumber = false
          vim.opt_local.number = false
        end,
      })

      chat.setup(opts)
    end,
  },
}
