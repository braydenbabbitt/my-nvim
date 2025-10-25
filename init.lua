-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Load core configuration
require("core.options") -- Must be loaded before keymaps/autocmds
require("core.keymaps")
require("core.autocmds")

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- Import all plugin specs from lua/plugins/
    { import = "plugins" },
  },
  defaults = {
    lazy = false, -- Plugins are not lazy-loaded by default
    version = false, -- Don't use versions, use latest git commit
  },
  install = {
    colorscheme = { "vscode", "tokyonight", "habamax" },
  },
  checker = {
    enabled = true, -- Automatically check for plugin updates
    notify = false, -- Don't notify about updates
  },
  performance = {
    rtp = {
      -- Disable some default vim plugins we don't need
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  ui = {
    border = "rounded",
    backdrop = 100,
  },
})

-- Apply colorscheme
vim.cmd.colorscheme("vscode")
