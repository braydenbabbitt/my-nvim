-- Markdown rendering - In-buffer rendering for easier-to-read hierarchy and styling
-- Renders headings, code blocks, lists, checkboxes, tables, and callouts inline.
-- Shows raw markdown on the line being edited (cursor line) and rendered text elsewhere.

return {
  "MeanderingProgrammer/render-markdown.nvim",
  commit = "f422cb5",
  -- Treesitter provides the markdown parsing; mini.icons supplies code-block/language icons
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "echasnovski/mini.icons",
  },
  ft = { "markdown", "markdown.mdx" },
  opts = {
    -- Render everywhere except the current line, so editing shows raw syntax
    render_modes = { "n", "c", "t" },

    -- Headings: full-width colored banners with icons, descending size cues
    heading = {
      enabled = true,
      sign = false, -- Keep the sign column clean
      icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
      width = "block", -- Banner only spans the heading text, not the whole window
      min_width = 30,
      border = false,
    },

    -- Code blocks: subtle background + language icon and name in the top-right
    code = {
      enabled = true,
      style = "full",
      width = "block",
      min_width = 45,
      border = "thin",
      position = "left",
      language_name = true,
      sign = false,
    },

    -- Bullets and ordered lists with clean icons
    bullet = {
      enabled = true,
      icons = { "●", "○", "◆", "◇" },
    },

    -- Rendered checkboxes for task lists
    checkbox = {
      enabled = true,
      unchecked = { icon = "󰄱 " },
      checked = { icon = "󰱒 " },
    },

    -- Drawn table borders with aligned cells
    pipe_table = {
      enabled = true,
      style = "full",
      cell = "padded",
    },

    -- Colored quote/callout blocks (Note, Tip, Warning, etc.)
    quote = { enabled = true, icon = "▋" },
    callout = { enabled = true },

    -- Highlight inline code spans
    inline_highlight = { enabled = true },

    -- Render thematic breaks (---) as a full-width divider
    dash = { enabled = true, icon = "─", width = "full" },

    -- Conceal link/image URLs behind their icon for cleaner reading
    link = { enabled = true },
  },
}
