-- Telescope - Fuzzy finder
-- Powerful fuzzy finder for files, buffers, grep, etc.

return {
  "nvim-telescope/telescope.nvim",
  commit = "b4da76b",
  cmd = "Telescope",
  dependencies = {
    { "nvim-lua/plenary.nvim", commit = "b9fd522" },
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      commit = "1f08ed6",
      build = "make",
      enabled = vim.fn.executable("make") == 1,
    },
  },
  keys = {
    -- File pickers (using Snacks instead)
    {
      "<leader>ff",
      function()
        Snacks.picker.files()
      end,
      desc = "Find Files",
    },
    {
      "<leader>fr",
      function()
        Snacks.picker.recent()
      end,
      desc = "Recent Files",
    },
    {
      "<leader>fg",
      function()
        Snacks.picker.git_files()
      end,
      desc = "Find Git Files",
    },

    -- Search
    {
      "<leader>sg",
      function()
        require("telescope.builtin").live_grep()
      end,
      desc = "Grep (root dir)",
    },
    {
      "<leader>sh",
      function()
        require("telescope.builtin").help_tags()
      end,
      desc = "Help Pages",
    },
    {
      "<leader>sk",
      function()
        require("telescope.builtin").keymaps()
      end,
      desc = "Key Maps",
    },
    {
      "<leader>sC",
      function()
        require("telescope.builtin").commands()
      end,
      desc = "Commands",
    },

    -- Buffers
    {
      "<leader>fb",
      function()
        require("telescope.builtin").buffers()
      end,
      desc = "Buffers",
    },
    {
      "<leader>,",
      function()
        require("telescope.builtin").buffers()
      end,
      desc = "Switch Buffer",
    },

    -- Git
    {
      "<leader>gc",
      function()
        require("telescope.builtin").git_commits()
      end,
      desc = "Commits",
    },
    {
      "<leader>gs",
      function()
        require("telescope.builtin").git_status()
      end,
      desc = "Status",
    },

    -- Config
    {
      "<leader>fc",
      function()
        require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
      end,
      desc = "Find Config File",
    },
  },
  opts = function()
    local actions = require("telescope.actions")

    return {
      defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
        path_display = { "smart" },
        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-n>"] = actions.cycle_history_next,
            ["<C-p>"] = actions.cycle_history_prev,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<C-s>"] = actions.select_horizontal,
          },
          n = {
            ["q"] = actions.close,
          },
        },
      },
      pickers = {
        find_files = {
          find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
        },
      },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
      },
    }
  end,
  config = function(_, opts)
    require("telescope").setup(opts)
    -- Load fzf extension if available
    pcall(require("telescope").load_extension, "fzf")
  end,
}
