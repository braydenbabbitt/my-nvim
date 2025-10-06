# LazyVim to Standalone Neovim Configuration Migration Plan

## Overview

This document outlines the complete migration from a LazyVim-based configuration to a standalone, minimal Neovim configuration while maintaining core functionality.

**Target Neovim Version**: 0.11.4+

---

## Phase 1: Preparation & Analysis

### 1.1 Backup Current Configuration

- [x] Create a full backup of current config directory (no actually necessary, we're using a new git branch for the migration)
- [ ] Document all current plugins and their versions from `lazy-lock.json`
- [ ] Take screenshots of current UI/setup for reference
- [ ] List all custom keymaps currently in use
- [ ] Test current config and document any issues

### 1.2 Identify Core Dependencies

- [ ] Review LazyVim extras being used:
  - `lazyvim.plugins.extras.ai.copilot`
  - `lazyvim.plugins.extras.formatting.prettier`
  - `lazyvim.plugins.extras.lang.astro`
  - `lazyvim.plugins.extras.lang.go`
  - `lazyvim.plugins.extras.lang.json`
  - `lazyvim.plugins.extras.lang.markdown`
  - `lazyvim.plugins.extras.lang.python`
  - `lazyvim.plugins.extras.lang.tailwind`
  - `lazyvim.plugins.extras.lang.toml`
  - `lazyvim.plugins.extras.lang.typescript`
  - `lazyvim.plugins.extras.linting.eslint`

- [ ] Identify which LazyVim utilities are being used:
  - `LazyVim.config.icons` (in lualine.lua)
  - `LazyVim.lualine.root_dir()` (in lualine.lua)
  - `LazyVim.lualine.pretty_path()` (in lualine.lua)
  - `LazyVim.has()` (in lualine.lua)
  - `Snacks` global (multiple files)

### 1.3 Document Custom Functionality

- [ ] Custom LSP root detection toggle system (options.lua)
- [ ] Blackhole register delete functionality (blackhole-delete-config.lua)
- [ ] Custom keymaps (keymaps.lua)
- [ ] ESLint auto-fix on save (autocmds.lua)
- [ ] Custom snippets (luasnip.lua)
- [ ] Cloak patterns for sensitive data (cloak.lua)

---

## Phase 2: New Configuration Structure

### 2.1 Create New Directory Structure

- [ ] Create new config structure:

  ```
  ~/.config/nvim/
  ├── init.lua                 # Main entry point
  ├── lua/
  │   ├── core/
  │   │   ├── options.lua      # Vim options
  │   │   ├── keymaps.lua      # Global keymaps
  │   │   ├── autocmds.lua     # Autocommands
  │   │   └── lazy.lua         # Lazy.nvim bootstrap
  │   ├── plugins/
  │   │   ├── ui.lua           # UI plugins (lualine, colorscheme, etc)
  │   │   ├── editor.lua       # Editor enhancements
  │   │   ├── lsp.lua          # LSP configuration
  │   │   ├── completion.lua   # Completion setup
  │   │   ├── treesitter.lua   # Treesitter config
  │   │   └── tools.lua        # Additional tools
  │   └── util/
  │       └── icons.lua        # Icon definitions (extract from LazyVim)
  ```

### 2.2 Setup Lazy.nvim Bootstrap

- [ ] Copy lazy.nvim bootstrap logic from `lua/config/lazy.lua`
- [ ] Remove LazyVim imports and dependencies
- [ ] Configure lazy.nvim with minimal settings
- [ ] Set up proper plugin loading structure

---

## Phase 3: Core Plugin Migration

### 3.1 Essential Plugins to Keep

- [ ] **lazy.nvim** - Plugin manager (already bootstrapped)
- [ ] **plenary.nvim** - Lua utility library (dependency)
- [ ] **nvim-web-devicons** or **mini.icons** - Icons

### 3.2 UI Plugins

- [ ] **Colorscheme** (currently using vscode.nvim):
  - Migrate `lua/plugins/colorscheme.lua`
  - Set up vscode.nvim, tokyonight.nvim, catppuccin
  - Recreate color overrides without LazyVim dependency
  - Set default colorscheme

- [ ] **lualine.nvim** - Status line:
  - Extract from `lua/plugins/lualine.lua`
  - Replace `LazyVim.config.icons` with custom icon table
  - Replace `LazyVim.lualine.root_dir()` with custom implementation
  - Replace `LazyVim.lualine.pretty_path()` with custom implementation
  - Replace `Snacks.util.color()` with direct color functions
  - Simplify or remove noice.nvim integration
  - Simplify or remove DAP integration
  - Keep: branch, diagnostics, file info, clock (12-hour format)

- [ ] **snacks.nvim** - Modern Neovim utilities:
  - Migrate terminal functionality (used for Claude Code)
  - Migrate picker/explorer functionality
  - Migrate buffer delete functionality
  - Migrate profiler (if needed)
  - Configure without LazyVim defaults

- [ ] **bufferline.nvim** - Buffer/tab line (if keeping):
  - Migrate with minimal config
  - Or consider removing for simplicity

- [ ] **which-key.nvim** - Keymap hints:
  - Migrate `lua/plugins/which-key.lua`
  - Set up custom groups for LSP, blackhole register, etc.

### 3.3 Editor Plugins

- [ ] **nvim-treesitter** - Syntax highlighting:
  - Set up with languages: typescript, javascript, tsx, jsx, lua, python, go, json, markdown, toml, astro
  - Configure highlight, indent, incremental_selection
  - Add nvim-treesitter-textobjects for text objects

- [ ] **nvim-ts-autotag** - Auto close/rename HTML tags
  - Simple setup for tsx/jsx/html files

- [ ] **flash.nvim** - Enhanced navigation (if keeping)
  - Minimal setup or consider removing

- [ ] **gitsigns.nvim** - Git integration:
  - Basic git signs and hunk navigation
  - Remove LazyVim-specific integrations

- [ ] **mini.ai** - Enhanced text objects (if keeping)
  - Or remove for simplicity

- [ ] **mini.pairs** - Auto pairs:
  - Basic auto-pair functionality
  - Or replace with simpler alternative

- [ ] **ts-comments.nvim** - Better comments:
  - Treesitter-aware commenting

### 3.4 LSP & Completion

- [ ] **nvim-lspconfig** - LSP configurations:
  - Migrate from `lua/plugins/lspconfig.lua`
  - Set up servers: vtsls, denols, eslint, postgres_lsp
  - Implement custom root_dir logic for vtsls/denols conflict
  - Set up LSP keymaps
  - Configure inlay hints (currently disabled)
  - Implement LSP restart functionality from keymaps.lua

- [ ] **mason.nvim** - LSP/tool installer:
  - Basic setup for managing LSP servers
  - Configure auto-install for defined servers

- [ ] **mason-lspconfig.nvim** - Bridge mason and lspconfig:
  - Automatic server setup

- [ ] **blink.cmp** - Completion:
  - Migrate from `lua/plugins/blink.lua`
  - Keep super-tab preset
  - Keep Ctrl-Space to exit insert mode mapping
  - Configure sources: LSP, buffer, snippets

- [ ] **blink.compat** - Compatibility layer (if needed)

- [ ] **LuaSnip** - Snippets:
  - Migrate from `lua/plugins/luasnip.lua`
  - Keep custom "cc" console.log snippet
  - Keep Ctrl-Enter/Ctrl-Shift-Enter navigation
  - Version pinned to 2.4.0

- [ ] **friendly-snippets** - Snippet collection:
  - Basic integration with LuaSnip

### 3.5 Formatting & Linting

- [ ] **conform.nvim** - Formatter:
  - Migrate from `lua/plugins/conform.lua`
  - Set up prettier for typescript, javascript, tsx, jsx, astro
  - Set up format on save
  - Remove LazyVim-specific configurations

- [ ] **nvim-lint** - Linter:
  - Set up eslint for typescript/javascript
  - Configure lint on save/change
  - Integrate with autocmd from autocmds.lua (EslintFixAll)

### 3.6 AI & Productivity Tools

- [ ] **GitHub Copilot** (currently in extras):
  - Decide: keep copilot.lua or copilot.vim
  - Basic setup without LazyVim wrapper

- [ ] **cloak.nvim** - Hide sensitive data:
  - Migrate from `lua/plugins/cloak.lua`
  - Keep patterns for "brayden" and .env files
  - Pin to commit 648aca6

### 3.7 Optional/Consider Removing

- [ ] **noice.nvim** - UI replacement (consider removing for simplicity)
- [ ] **nui.nvim** - UI components (dependency for noice, remove if not needed)
- [ ] **trouble.nvim** - Diagnostics (consider keeping or removing)
- [ ] **todo-comments.nvim** - TODO highlights (consider keeping or removing)
- [ ] **grug-far.nvim** - Search/replace (consider removing)
- [ ] **markdown-preview.nvim** - Markdown preview (keep if used)
- [ ] **render-markdown.nvim** - Markdown rendering (keep if used)
- [ ] **persistence.nvim** - Session management (consider removing)
- [ ] **codecompanion.nvim** - AI assistant (disabled, remove)
- [ ] **mcphub.nvim** - MCP integration (evaluate if needed)
- [ ] **lazydev.nvim** - Lua dev tools (keep for config development)
- [ ] **SchemaStore.nvim** - JSON schemas (keep if using JSON)
- [ ] **venv-selector.nvim** - Python venv selector (keep if using Python)

---

## Phase 4: Configuration Migration

### 4.1 Options (lua/core/options.lua)

- [ ] Copy basic vim options from LazyVim defaults
- [ ] Migrate custom options from current `lua/config/options.lua`:
  - `vim.g.snacks_animate = false`
- [ ] Migrate LSP root detection functions:
  - `HasLspInRootSpec()`
  - `ToggleLspRootSpec(enable, should_notify)`
  - User command `:ToggleLspRoot`
- [ ] Add standard options:
  - Line numbers, relative numbers
  - Indentation (spaces vs tabs, width)
  - Search settings (ignorecase, smartcase)
  - Split behavior
  - Clipboard integration
  - Undo/backup settings
  - Mouse support
  - Scroll offset
  - Sign column

### 4.2 Keymaps (lua/core/keymaps.lua)

- [ ] Define leader key (probably space)
- [ ] Migrate custom keymaps from `lua/config/keymaps.lua`:
  - LSP keymaps (leader+L prefix):
    - `<leader>Lrt` - Restart vtsls & eslint
    - `<leader>Li` - LSP Info
    - `<leader>Ll` - Toggle LSP Root Detection
  - Navigation:
    - `G` -> `G$` (end of file goes to end of line)
    - `gg` -> `gg0` (start of file goes to start of line)
  - Window management:
    - `<leader>R` - Reset windows and buffers (using Snacks)
  - Go to definition:
    - `<leader>gd` - Go to definition
  - Insert mode exit:
    - `<C-space>` and `<C-@>` - Exit insert (visual mode)
    - `<C-c>` warning message
  - Diagnostic lists:
    - `<leader>Xl` - Toggle location list
    - `<leader>Xq` - Toggle quickfix list
  - AI tools:
    - `<leader>aa` - Open Claude in right terminal
    - `<leader>at` - Toggle Claude terminal
  - Blackhole register:
    - See section 4.4

- [ ] Add standard keymaps:
  - Window navigation (Ctrl+hjkl)
  - Buffer navigation
  - LSP defaults (gd, gr, K, etc.)
  - Diagnostic navigation
  - Save, quit shortcuts

### 4.3 Autocommands (lua/core/autocmds.lua)

- [ ] Migrate from `lua/config/autocmds.lua`:
  - ESLint fix all on save for TS/JS files:

    ```lua
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = { "*.tsx", "*.ts", "*.jsx", "*.js" },
      command = "silent! EslintFixAll",
    })
    ```

- [ ] Add standard autocmds:
  - Highlight on yank
  - Auto-create missing directories on save
  - Restore cursor position
  - File type specific settings

### 4.4 Blackhole Register Keymaps

- [ ] Migrate from `lua/plugins/blackhole-delete-config.lua`:
  - Keymaps:
    - `<leader>x` - Black hole delete/cut (normal & visual)
    - `<leader>d` - Black hole delete (normal & visual)
  - Remap conflicting plugin keymaps:
    - Snacks profiler: `<leader>dps` -> `<leader>Dps`
    - Snacks profiler: `<leader>dpp` -> `<leader>Dpp`
    - Snacks profiler: `<leader>dph` -> `<leader>Dph`
    - Todo comments: `<leader>xt` -> `<leader>Xt`
    - Todo comments: `<leader>xT` -> `<leader>XT`
    - Trouble: `<leader>xx` -> `<leader>Xx`
    - Trouble: `<leader>xX` -> `<leader>XX`
    - Trouble: `<leader>xL` -> `<leader>XL`
    - Trouble: `<leader>xQ` -> `<leader>XQ`
  - Which-key groups:
    - `<leader>d` - "Blackhole Register Delete"
    - `<leader>x` - "Blackhole Register Delete"
    - `<leader>D` - "Debug" group
    - `<leader>Dp` - "profiler" group

### 4.5 Icons Utility (lua/util/icons.lua)

- [ ] Extract icon definitions from LazyVim
- [ ] Create custom icons table with:
  - diagnostics (Error, Warn, Info, Hint)
  - git (added, modified, removed)
  - kinds (LSP completion kinds)
  - ui elements
- [ ] Make icons accessible to plugins (lualine, etc.)

---

## Phase 5: Replace LazyVim Utilities

### 5.1 Lualine Utilities

- [ ] Implement `root_dir()` function:
  - Detect project root (git, package.json, etc.)
  - Display in lualine

- [ ] Implement `pretty_path()` function:
  - Shorten file path intelligently
  - Handle buffers, special windows

- [ ] Implement color helper:
  - Replace `Snacks.util.color()`
  - Get highlight group colors
  - Use in lualine components

### 5.2 Snacks Global

- [ ] Ensure snacks.nvim is properly configured
- [ ] Verify global `Snacks` is available
- [ ] Test used functions:
  - `Snacks.bufdelete.all()`
  - `Snacks.terminal()`
  - `Snacks.terminal.toggle()`
  - `Snacks.profiler.status()`
  - `Snacks.profiler.scratch()`
  - `Snacks.toggle.profiler()`
  - `Snacks.toggle.profiler_highlights()`

---

## Phase 6: Language-Specific Setup

### 6.1 TypeScript/JavaScript

- [ ] LSP: vtsls (for package.json projects)
- [ ] LSP: denols (for deno.json projects)
- [ ] Linter: eslint with EslintFixAll on save
- [ ] Formatter: prettier
- [ ] Treesitter: typescript, tsx, javascript, jsx
- [ ] Auto-tag support

### 6.2 Python

- [ ] LSP: pyright or basedpyright
- [ ] Formatter: black or ruff
- [ ] Linter: ruff
- [ ] Treesitter: python
- [ ] Virtual env selector (venv-selector.nvim)

### 6.3 Go

- [ ] LSP: gopls
- [ ] Formatter: gofmt/goimports
- [ ] Linter: golangci-lint
- [ ] Treesitter: go

### 6.4 Other Languages

- [ ] JSON: LSP (jsonls), SchemaStore integration
- [ ] Markdown: LSP (marksman), treesitter, preview/render
- [ ] Astro: LSP, formatter (prettier), treesitter
- [ ] TOML: treesitter
- [ ] Tailwind: LSP (tailwindcss), integration
- [ ] SQL: postgres_lsp

---

## Phase 7: Testing & Validation

### 7.1 Initial Testing

- [ ] Start Neovim with new config
- [ ] Verify lazy.nvim loads correctly
- [ ] Check for errors in `:checkhealth`
- [ ] Verify all plugins install correctly
- [ ] Test colorscheme loads

### 7.2 Feature Testing

- [ ] LSP functionality:
  - [ ] Hover documentation (K)
  - [ ] Go to definition (gd, <leader>gd)
  - [ ] Rename (leader+cr)
  - [ ] Code actions
  - [ ] LSP restart (<leader>Lrt)
  - [ ] LSP info (<leader>Li)
  - [ ] LSP root toggle (<leader>Ll)
- [ ] Completion:
  - [ ] LSP completions
  - [ ] Snippet completions
  - [ ] Custom "cc" snippet
  - [ ] Super-tab navigation
  - [ ] Ctrl-Space to exit insert
- [ ] Formatting:
  - [ ] Prettier format on save
  - [ ] ESLint fix on save
  - [ ] Manual format
- [ ] Treesitter:
  - [ ] Syntax highlighting
  - [ ] Indentation
  - [ ] Text objects
- [ ] UI:
  - [ ] Lualine displays correctly
  - [ ] Icons show properly
  - [ ] Colorscheme correct
  - [ ] Bufferline (if kept)
- [ ] Tools:
  - [ ] Claude terminal (<leader>aa, <leader>at)
  - [ ] Cloak sensitive data
  - [ ] Which-key displays
  - [ ] Git signs
- [ ] Navigation:
  - [ ] Flash/jump (if kept)
  - [ ] G/gg custom behavior
- [ ] Keymaps:
  - [ ] All custom keymaps work
  - [ ] Blackhole register delete
  - [ ] No conflicts

### 7.3 Language-Specific Testing

- [ ] TypeScript/JavaScript project (package.json)
- [ ] Deno project (deno.json)
- [ ] Python project
- [ ] Go project
- [ ] Markdown files
- [ ] JSON files
- [ ] Astro files

### 7.4 Performance Testing

- [ ] Startup time (`:Lazy profile`)
- [ ] Lazy loading working
- [ ] No performance regressions
- [ ] File size limits

---

## Phase 8: Cleanup & Documentation

### 8.1 Remove LazyVim References

- [ ] Delete `lazyvim.json`
- [ ] Delete LazyVim plugin entries
- [ ] Remove LazyVim version pins
- [ ] Clean up lazy-lock.json
- [ ] Remove unused plugins

### 8.2 Configuration Cleanup

- [ ] Remove disabled plugins directory
- [ ] Remove .neoconf.json (if LazyVim specific)
- [ ] Remove .luarc.json (if LazyVim specific)
- [ ] Clean up comments referencing LazyVim
- [ ] Remove unused files

### 8.3 Documentation

- [ ] Create README.md with:
  - [ ] Installation instructions
  - [ ] Plugin list with descriptions
  - [ ] Custom keymaps reference
  - [ ] Configuration structure
  - [ ] Requirements (Neovim version, external tools)
- [ ] Document custom functions
- [ ] Add comments to complex configurations
- [ ] Create PLUGINS.md listing all plugins and their purpose

### 8.4 Optimization

- [ ] Review lazy loading configuration
- [ ] Optimize startup time
- [ ] Remove unnecessary dependencies
- [ ] Consolidate similar functionality

---

## Phase 9: Final Steps

### 9.1 Version Control

- [ ] Commit new configuration with clear message
- [ ] Tag the commit as stable migration point
- [ ] Create backup branch with old config
- [ ] Document migration in git history

### 9.2 Portability

- [ ] Test on different machines
- [ ] Verify Mason installs work
- [ ] Check external dependencies
- [ ] Document any OS-specific setup

### 9.3 Maintenance Plan

- [ ] Document how to update plugins
- [ ] Create update strategy (lazy.nvim update, lock file)
- [ ] Plan for future plugin additions
- [ ] Decide on version pinning strategy

---

## Appendix

### A. Current Plugin Count

**Total plugins in lazy-lock.json: 45**

**After migration (estimated): 20-30**

- Removing LazyVim framework and unused extras
- Keeping only essential and actively used plugins

### B. Critical Custom Features to Preserve

1. LSP root detection toggle system
2. Blackhole register delete (leader+d/x)
3. vtsls/denols root_dir conflict resolution
4. Custom console.log snippet ("cc")
5. Claude Code terminal integration
6. Cloak sensitive data patterns
7. ESLint auto-fix on save
8. 12-hour clock in lualine
9. G/gg navigation behavior
10. Ctrl-Space insert mode exit

### C. Plugins to Definitely Remove

- LazyVim (framework)
- codecompanion.nvim (disabled)
- avante.nvim (in disabled folder)
- Potentially: noice.nvim, trouble.nvim, persistence.nvim (evaluate usage)

### D. External Dependencies to Document

- Node.js (for vtsls, eslint, prettier)
- Deno (for denols)
- Python (for python LSPs)
- Go (for gopls)
- ripgrep (for telescope/grep)
- fd (for file finding)
- Git (for gitsigns)
- Claude CLI (for terminal integration)

### E. Key File Locations

- Main config: `~/.config/nvim/`
- Data directory: `~/.local/share/nvim/`
- State directory: `~/.local/state/nvim/`
- Cache directory: `~/.cache/nvim/`

### F. Migration Risks & Mitigation

**Risks:**

1. Breaking LSP functionality
   - Mitigation: Test each LSP server individually
2. Losing custom keymaps
   - Mitigation: Document all before migration
3. Missing LazyVim utilities
   - Mitigation: Implement replacements before removing
4. Plugin conflicts
   - Mitigation: Gradual migration, test frequently

---

## Quick Start Migration Commands

```bash
# 1. Backup current config
cp -r ~/.config/nvim ~/.config/nvim.lazyvim.backup

# 2. Create new structure (after completing phases)
# (Will be done programmatically during migration)

# 3. Test new config
nvim --headless "+Lazy! sync" +qa
nvim

# 4. Compare startup time
# Old: nvim --startuptime old.log +qa
# New: nvim --startuptime new.log +qa
```

---

## Session Checklist for Implementation

When implementing this plan across multiple sessions, track progress using this checklist:

- [ ] **Session 1**: Phases 1-2 (Preparation & Structure)
- [ ] **Session 2**: Phase 3.1-3.2 (Essential & UI Plugins)
- [ ] **Session 3**: Phase 3.3-3.4 (Editor & LSP Plugins)
- [ ] **Session 4**: Phase 3.5-3.7 (Formatting & Optional Plugins)
- [ ] **Session 5**: Phase 4 (Configuration Migration)
- [ ] **Session 6**: Phase 5 (Replace Utilities)
- [ ] **Session 7**: Phase 6 (Language Setup)
- [ ] **Session 8**: Phase 7 (Testing)
- [ ] **Session 9**: Phases 8-9 (Cleanup & Final Steps)

Each session should end with a working configuration that can be tested.

---

**Last Updated**: 2025-10-05
**Migration Status**: Planning Phase
**Target Neovim Version**: 0.11.4+
