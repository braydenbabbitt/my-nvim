-- Luacheck configuration
globals = {
  "vim",
  "describe",
  "it",
  "before_each",
  "after_each",
  "setup",
  "teardown",
  "assert",
  "pending",
  "Snacks",
  "HasLspInRootSpec",
  "ToggleLspRootSpec",
}

read_globals = {
  "vim",
}

-- Ignore certain warnings
ignore = {
  "212", -- Unused argument
  "631", -- Line is too long
}

-- Exclude certain files/directories
exclude_files = {
  ".tests",
  "tests/minimal_init.lua",
}
