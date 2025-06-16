-- Plugin configuration for Root Dir as CWD toggle functionality
return {
  {
    "LazyVim/LazyVim",
    opts = function()
      -- Apply the root override on startup
      local utils = require("config.utils")
      utils.apply_root_override()

      -- Create a user command to toggle the setting
      vim.api.nvim_create_user_command("ToggleRootDirAsCwd", function()
        utils.toggle_use_root_dir_as_cwd()
      end, { desc = "Toggle Use Root Dir as CWD setting" })

      -- Create a user command to show the current status
      vim.api.nvim_create_user_command("RootDirAsCwdStatus", function()
        local status = utils.get_use_root_dir_as_cwd_status()
        vim.notify("Current directory mode: " .. status, vim.log.levels.INFO)
      end, { desc = "Show current Root Dir as CWD status" })
    end,
  },
}

