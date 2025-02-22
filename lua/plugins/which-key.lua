return {
  {
    "folke/which-key.nvim",
    opts = {
      preset = "helix",
      defaults = {},
      spec = {
        {
          mode = { "n", "v" },
          { "<leader><tab>", group = "tabs" },
          { "<leader>c", group = "code" },
          { "<leader>`", group = "debug" },
          { "<leader>`p", group = "profiler" },
          { "<leader>f", group = "file/find" },
          { "<leader>g", group = "git" },
          { "<leader>gh", group = "hunks" },
          { "<leader>q", group = "quit/session" },
          { "<leader>s", group = "search" },
          { "<leader>u", group = "ui", icon = { icon = "󰙵 ", color = "cyan" } },
          { "<leader>L", group = "lsp/diagnostics/quickfix", icon = { icon = "󱖫 ", color = "green" } },
          { "[", group = "prev" },
          { "]", group = "next" },
          { "g", group = "goto" },
          { "gs", group = "surround" },
          { "z", group = "fold" },
          {
            "<leader>b",
            group = "buffer",
            expand = function()
              return require("which-key.extras").expand.buf()
            end,
          },
          {
            "<leader>w",
            group = "windows",
            proxy = "<c-w>",
            expand = function()
              return require("which-key.extras").expand.win()
            end,
          },
          -- better descriptions
          { "gx", desc = "Open with system app" },
        },
      },
    },
    config = function(opts)
      local function remap_leader_group(old_prefix, new_prefix, modes)
        local resolved_modes = { "n", "v" }
        if modes then
          if type(modes) == "string" then
            resolved_modes = { modes }
          else
            resolved_modes = modes
          end
        end

        for _, mode in ipairs(resolved_modes) do
          local maps = vim.api.nvim_get_keymap(mode)
          for _, map in ipairs(maps) do
            if map.lhs and map.lhs:match("^" .. old_prefix) then
              local new_lhs = map.lhs:gsub("^" .. old_prefix, new_prefix)

              local new_mapping = {
                rhs = map.rhs,
                silent = map.silent == 1,
                noremap = map.noremap == 1,
                expr = map.expr == 1,
                desc = map.desc,
              }

              vim.keymap.del(mode, map.lhs)
              vim.keymap.set(mode, new_lhs, new_mapping.rhs, new_mapping)
            end
          end
        end
      end

      local which_key = require("which-key")

      which_key.setup(opts)

      remap_leader_group("<leader>x", "<leader>L")
      remap_leader_group("<leader>d", "<leader>`")

      -- Black hole register for deletions with leader
      vim.keymap.set({ "n", "v" }, "<leader>x", '"_x', { desc = "Black Hole Register", remap = true })
      vim.keymap.set({ "n", "v" }, "<leader>d", '"_d', { desc = "Black Hole Register", remap = true })
    end,
  },
}
