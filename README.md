# Neovim Configuration

A standalone, custom Neovim configuration built from scratch (migrated from LazyVim).

## Philosophy

This config is **fully independent** - no LazyVim dependency, complete control over every plugin and keymap. It maintains the best parts of LazyVim (plugin selection, UI/UX) while eliminating the complexity and friction of fighting with defaults.

**All plugins are pinned to specific commits** for maximum stability and reproducibility, preventing unexpected breaking changes from upstream updates.

## Structure

```
.
├── init.lua                 # Entry point - bootstraps lazy.nvim and loads config
├── lua/
│   ├── core/               # Core Neovim configuration
│   │   ├── options.lua     # Vim options and settings
│   │   ├── keymaps.lua     # All custom keybindings
│   │   └── autocmds.lua    # Autocommands
│   └── plugins/            # Plugin specifications (all pinned to specific commits)
│       ├── autotag.lua     # Auto-close and rename HTML/JSX tags
│       ├── blink.lua       # Completion engine
│       ├── bufferline.lua  # Buffer tabs with diagnostics
│       ├── cloak.lua       # Hide sensitive info
│       ├── colorscheme.lua # Color schemes (vscode, tokyonight, catppuccin)
│       ├── conform.lua     # Code formatting
│       ├── editor.lua      # Editor enhancements (pairs, surround, comment, etc.)
│       ├── git.lua         # Git integration (gitsigns)
│       ├── grug-far.lua    # Find and replace across files
│       ├── lsp.lua         # LSP configuration (vtsls, denols, eslint, etc.)
│       ├── lualine.lua     # Statusline
│       ├── luasnip.lua     # Snippet engine
│       ├── noice.lua       # Enhanced UI for messages and cmdline
│       ├── snacks.lua      # Utilities (dashboard, terminal, picker, etc.)
│       ├── telescope.lua   # Fuzzy finder
│       ├── todo-comments.lua # TODO highlighting
│       ├── treesitter.lua  # Syntax highlighting
│       ├── trouble.lua     # Diagnostics list
│       └── which-key.lua   # Keymap hints
└── README.md               # This file
```

## Key Features

### Language Support
- **TypeScript/JavaScript**: vtsls LSP with prettier formatting and ESLint auto-fix on save
- **HTML/JSX/TSX**: Auto-close and auto-rename tags via nvim-ts-autotag
- **Deno**: Separate LSP for Deno projects (auto-detected via deno.json)
- **Lua**: Full Neovim Lua support with lua_ls
- **SQL**: PostgreSQL LSP support
- Auto-format on save for JS/TS via ESLint (autocmd in `core/autocmds.lua`)

### UI/UX
- **Dashboard**: Custom Neovim ASCII art on startup
- **Statusline**: Custom lualine with 12-hour clock
- **Buffer Tabs**: Bufferline with diagnostics integration and pinning support
- **Enhanced UI**: Noice for floating command palette and improved LSP hover/signature help
- **File Explorer**: Snacks picker with git status integration
- **Fuzzy Finder**: Telescope for files, grep, buffers, etc.
- **Search & Replace**: Grug-far for project-wide find and replace with nice UI
- **Colorscheme**: VSCode theme (default), with Tokyo Night and Catppuccin available

### Custom Keybindings
- `<leader>` = `<Space>`
- `<C-space>` = Exit insert/visual mode (preferred over `<C-c>`)
- `<leader>d/x` = Blackhole register delete (delete without yanking)
- `<leader>aa` = Open Claude terminal (right side)
- `<leader>R` = Reset all windows and buffers
- `gg`/`G` = Jump to start/end of file with cursor at line start/end

#### Buffer Management
- `[b`/`]b` = Previous/next buffer
- `<leader>bp` = Toggle pin buffer
- `<leader>bP` = Delete non-pinned buffers
- `<leader>bo` = Delete other buffers
- `<leader>br`/`<leader>bl` = Delete buffers to the right/left

#### Noice (Enhanced UI)
- `<leader>nl` = Show last message
- `<leader>nh` = Show message history
- `<leader>na` = Show all messages
- `<leader>nd` = Dismiss all notifications
- `<C-f>`/`<C-b>` = Scroll LSP hover/signature help

#### Search & Replace
- `<leader>sr` = Open grug-far for project-wide search and replace

See `lua/core/keymaps.lua` for full list

### LSP Features
- Auto-completion via blink.cmp
- LSP root detection toggle (`<leader>Ll`)
- Custom LSP restart keybind for vtsls/eslint (`<leader>Lrt`)
- Inlay hints disabled by default

### Snippets
- Custom `cc` snippet for JS/TS: `console.log('brayden-test', ...)`
- LuaSnip with friendly-snippets integration
- Navigate snippets with `<C-CR>` and `<C-S-CR>`

## Installation

This config uses lazy.nvim and will auto-install on first launch.

1. Clone/symlink this directory to `~/.config/nvim`
2. Launch Neovim
3. Wait for plugins to install
4. Restart Neovim

## Customization

### Adding Plugins
Create a new file in `lua/plugins/` with your plugin spec. **Always pin to a specific commit**:

```lua
-- lua/plugins/my-plugin.lua
return {
  "username/plugin-name",
  commit = "abc1234",  -- Always pin to a specific commit
  opts = {
    -- options here
  },
}
```

### Changing Colorscheme
Edit `init.lua` line 59 to change the default colorscheme:
```lua
vim.cmd.colorscheme("vscode")  -- or "tokyonight" or "catppuccin"
```

### Modifying Keymaps
Edit `lua/core/keymaps.lua` to add/remove/modify keybindings.

### Adding LSP Servers
Edit `lua/plugins/lsp.lua`:
1. Add server to `ensure_installed` in mason-lspconfig
2. Add server config to the `servers` table
3. Restart Neovim

## Testing

This config includes comprehensive automated tests to ensure stability and catch regressions early.

### Testing Strategy

The test suite uses **plenary.nvim** (industry standard for Neovim testing) and covers:

1. **Core Module Tests**: All custom Lua logic in `lua/core/` (aicli, options, keymaps, autocmds)
2. **Plugin Pin Validation**: Ensures all 18 plugin files remain pinned to specific commits
3. **Integration Tests**: Plugin loading and LSP configuration validation
4. **CI/CD**: Automated testing on every push/PR via GitHub Actions

**Current Status**: 58/58 plugin validation tests passing ✅

### Running Tests

```bash
# Run all tests
make test

# Run specific test suites
make test-core         # Core module tests only
make test-plugins      # Plugin pin validation (ensures no unpinned plugins)
make test-integration  # Integration tests

# Development
make test-watch        # Watch mode (requires entr)

# Code quality
make lint              # Run luacheck
make format            # Format with stylua
make format-check      # Check formatting without modifying
```

### What's Being Tested

- **AI CLI Module** (`core/aicli.lua`): State persistence, tool detection, installation logic
- **Options Module** (`core/options.lua`): LSP root detection, vim settings
- **Keymaps Module** (`core/keymaps.lua`): Keymap creation and configuration
- **Autocmds Module** (`core/autocmds.lua`): Autocommand setup and behavior
- **Plugin Pinning**: All plugins have `commit = "abc1234"` fields (no branch/tag/version)
- **Plugin Loading**: All plugin specs can be loaded without errors

### Adding Tests for New Plugins

When you add a new plugin, the **pin validation tests automatically verify** it's properly pinned. No additional test code needed!

However, if you add **custom logic** (functions, utilities, complex configs), add corresponding tests:

#### 1. Create a test file

```bash
# For core modules
touch tests/core/my_module_spec.lua

# For plugin-specific tests
touch tests/integration/my_plugin_spec.lua
```

#### 2. Write tests using plenary's busted syntax

```lua
local helpers = require("tests.helpers")

describe("my_module", function()
  before_each(function()
    helpers.setup()  -- Reset state before each test
  end)

  after_each(function()
    helpers.teardown()
  end)

  describe("my_function", function()
    it("should do something", function()
      -- Arrange
      local input = "test"

      -- Act
      local result = require("my_module").my_function(input)

      -- Assert
      assert.are.equal("expected", result)
    end)
  end)
end)
```

#### 3. Use mocking utilities when needed

```lua
local mock = require("tests.helpers.mock")

-- Mock file I/O
local file_io = mock.mock_file_io()
file_io.files["/path/to/file"] = "content"
-- ... test code ...
file_io.restore()

-- Mock vim.fn.executable
local exec_mock = mock.mock_executable({ git = true, node = false })
-- ... test code ...
exec_mock.restore()

-- Mock vim.notify
local notify_mock = mock.mock_notify()
-- ... test code ...
helpers.assert.assert_notified(notify_mock.notifications, "message", vim.log.levels.INFO)
notify_mock.restore()
```

#### 4. Run your new tests

```bash
make test-core  # or make test-integration
```

### CI/CD Integration

Tests run automatically via GitHub Actions on:
- Every push to `main`
- Every pull request
- Weekly schedule (Mondays at 9 AM UTC)

Tests run on both **Ubuntu** and **macOS** with **Neovim stable** and **nightly**.

See `tests/README.md` for detailed testing documentation and best practices.

## Migration Notes

This config was migrated from LazyVim v14.15.1. All LazyVim-specific code has been removed and replaced with direct plugin configurations. Key differences:

- **No LazyVim dependency**: Completely standalone
- **Commit pinning**: All plugins pinned to specific commits for stability
- **Explicit configs**: Every plugin is explicitly configured, no hidden defaults
- **No extras system**: Plugins are manually specified instead of using LazyVim extras
- **Custom keymaps**: All keymaps defined in one place, no need to delete LazyVim defaults

## Backup

A timestamped backup of the previous config was created during migration at:
`nvim.backup.YYYYMMDD_HHMMSS`

## Troubleshooting

- **Plugins not loading**: Run `:Lazy` and check for errors
- **LSP not working**: Run `:LspInfo` to check server status
- **Formatting issues**: Run `:ConformInfo` to check formatter status
- **Mason issues**: Run `:Mason` to manually install LSP servers

## Credits

- Built with [lazy.nvim](https://github.com/folke/lazy.nvim)
- Inspired by [LazyVim](https://github.com/LazyVim/LazyVim)
- Plugin ecosystem from the amazing Neovim community
