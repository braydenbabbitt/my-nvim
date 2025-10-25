return {
  {
    "laytan/cloak.nvim",
    commit = "648aca6",
    opts = {
      enabled = true,
      cloak_character = "*",
      cloak_telescope = true,
      try_all_patterns = true,
      patterns = {
        {
          file_pattern = "*",
          cloak_pattern = { "brayden%S*(?:babbitt%S*)?" },
        },
        {
          file_pattern = ".env*",
          cloak_pattern = { "=.+" },
        },
      },
    },
  },
}
