-- Lualine - Statusline
-- Custom statusline configuration with 12-hour clock

return {
  "nvim-lualine/lualine.nvim",
  commit = "b8c2315",
  dependencies = { "nvim-tree/nvim-web-devicons", commit = "8dcb311" },
  event = "VeryLazy",
  opts = function()
    -- Icons for diagnostics and git
    local icons = {
      diagnostics = {
        Error = " ",
        Warn = " ",
        Hint = " ",
        Info = " ",
      },
      git = {
        added = " ",
        modified = " ",
        removed = " ",
      },
    }

    return {
      options = {
        theme = "auto",
        globalstatus = true,
        disabled_filetypes = {
          statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" },
        },
        component_separators = { left = "|", right = "|" },
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = {
          "branch",
          -- Macro recording indicator
          {
            function()
              local reg = vim.fn.reg_recording()
              if reg == "" then
                return ""
              end
              return "recording @" .. reg
            end,
            color = { fg = "#ff9e64", gui = "bold" },
          },
        },
        lualine_c = {
          {
            "diagnostics",
            symbols = {
              error = icons.diagnostics.Error,
              warn = icons.diagnostics.Warn,
              info = icons.diagnostics.Info,
              hint = icons.diagnostics.Hint,
            },
          },
          {
            "filetype",
            icon_only = true,
            separator = "",
            padding = { left = 1, right = 0 },
          },
          {
            "filename",
            path = 1, -- Relative path
            symbols = {
              modified = " ●",
              readonly = " ",
              unnamed = "[No Name]",
            },
          },
        },
        lualine_x = {
          -- LSP status
          {
            function()
              local clients = vim.lsp.get_clients({ bufnr = 0 })
              if #clients == 0 then
                return ""
              end
              local client_names = {}
              for _, client in ipairs(clients) do
                table.insert(client_names, client.name)
              end
              return " " .. table.concat(client_names, ", ")
            end,
            cond = function()
              return #vim.lsp.get_clients({ bufnr = 0 }) > 0
            end,
          },
          -- Git diff
          {
            "diff",
            symbols = {
              added = icons.git.added,
              modified = icons.git.modified,
              removed = icons.git.removed,
            },
            source = function()
              local gitsigns = vim.b.gitsigns_status_dict
              if gitsigns then
                return {
                  added = gitsigns.added,
                  modified = gitsigns.changed,
                  removed = gitsigns.removed,
                }
              end
            end,
          },
        },
        lualine_y = {
          { "progress", separator = " ", padding = { left = 1, right = 0 } },
          { "location", padding = { left = 0, right = 1 } },
        },
        lualine_z = {
          -- 12-hour clock format
          function()
            return " " .. os.date("%I:%M %p")
          end,
        },
      },
      extensions = { "lazy", "mason" },
    }
  end,
}
