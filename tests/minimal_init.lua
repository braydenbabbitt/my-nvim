-- Minimal init for testing
-- Sets up only what's needed to run tests

-- Add current config to runtimepath
vim.opt.rtp:prepend(vim.fn.getcwd())

-- Bootstrap lazy.nvim for tests
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local lazytag = "85c7ff3" -- Pin to v11.17.5 (matches main config)
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    lazyrepo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
  -- Checkout the pinned commit
  vim.fn.system({ "git", "-C", lazypath, "checkout", lazytag })
end
vim.opt.rtp:prepend(lazypath)

-- Add plenary to runtimepath directly
local plenary_path = vim.fn.stdpath("data") .. "/lazy/plenary.nvim"
vim.opt.rtp:prepend(plenary_path)

-- Ensure plenary is loaded
vim.cmd("runtime! plugin/plenary.vim")

-- Test helpers will be loaded by individual test files
