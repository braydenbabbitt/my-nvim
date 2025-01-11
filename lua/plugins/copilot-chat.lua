return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    model = "claude-3.5-sonnet",
    opts = {
      mappings = {
        close = {
          normal = "q",
          insert = "<C-x>",
        },
        reset = {
          normal = "<C-x>",
          insert = "<C-x>",
        },
        submit_prompt = {
          normal = "<CR>",
          insert = "<C-CR>",
        },
      },
    },
  },
}
