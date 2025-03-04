return {
  {
    "lewis6991/gitsigns.nvim",
    version = "1.0.1",
    event = {
      "BufReadPost",
      "BufNewFile",
      "BufWritePost",
    },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      signs_staged = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        -- stylua: ignore start
        map("n", "]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.nav_hunk("next")
          end
        end, "Next Hunk")
        map("n", "[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.nav_hunk("prev")
          end
        end, "Prev Hunk")
        map("n", "]H", function() gs.nav_hunk("last") end, "Last Hunk")
        map("n", "[H", function() gs.nav_hunk("first") end, "First Hunk")
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "[S]tage Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "[U]ndo Stage Hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "[R]eset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk_inline, "[P]review Hunk Inline")
        map("n", "<leader>gbl", function() gs.blame_line({ full = true }) end, "Blame [L]ine")
        map("n", "<leader>gbf", function() gs.blame() end, "Blame [F]ile")
        map("n", "<leader>ghd", gs.diffthis, "[D]iff This")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "[D]iff This ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
  },
}
