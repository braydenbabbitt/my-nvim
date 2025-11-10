-- Auto-close and auto-rename HTML/JSX tags
return {
  "windwp/nvim-ts-autotag",
  commit = "c4ca798",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    opts = {
      enable_close = true,
      enable_rename = true,
      enable_close_on_slash = false,
    },
  },
}
