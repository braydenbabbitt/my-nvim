-- Treesitter - Syntax highlighting and more
-- Better syntax highlighting, text objects, and code understanding

return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
  keys = {
    { "<c-space>", desc = "Increment Selection" },
    { "<bs>", desc = "Decrement Selection", mode = "x" },
  },
  opts = {
    -- Note: install_dir is handled by the plugin itself in lazy.nvim setup
    -- Parsers are installed in the plugin's parser directory
    
    -- Enable treesitter-based syntax highlighting
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    
    ensure_installed = {
      "bash",
      "c",
      "diff",
      "html",
      "javascript",
      "jsdoc",
      "json",
      "jsonc",
      "lua",
      "luadoc",
      "luap",
      "markdown",
      "markdown_inline",
      "python",
      "query",
      "regex",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "xml",
      "yaml",
    },
    auto_install = true,
    
    -- Incremental selection (still supported in 1.0)
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-space>",
        node_incremental = "<C-space>",
        scope_incremental = false,
        node_decremental = "<bs>",
      },
    },
  },
  config = function(_, opts)
    -- Prepend nvim-treesitter runtime to runtimepath for query priority
    local runtime_path = vim.fn.stdpath("data") .. "/lazy/nvim-treesitter/runtime"
    vim.opt.runtimepath:prepend(runtime_path)
    
    -- Add parser directory to treesitter parser search path
    local parser_install_dir = vim.fn.stdpath("data") .. "/lazy/nvim-treesitter"
    vim.opt.runtimepath:append(parser_install_dir)
    
    -- Correct API: require('nvim-treesitter.configs').setup() to configure modules
    require("nvim-treesitter.configs").setup(opts)
  end,
}
