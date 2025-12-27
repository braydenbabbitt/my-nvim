# nvim-treesitter 1.0 Migration - Complete

**Date:** 2025-12-27  
**Status:** ✅ Complete  
**tree-sitter-cli version:** 0.25.10 → 0.26.3

---

## Summary

Successfully migrated from legacy nvim-treesitter (commit-pinned) to nvim-treesitter 1.0 rewrite with the following major changes:

### Core Changes
- ✅ Removed commit pins from nvim-treesitter
- ✅ Removed nvim-treesitter-textobjects dependency (using mini.ai exclusively)
- ✅ Updated configuration API: `nvim-treesitter.configs.setup()` → `nvim-treesitter.setup()`
- ✅ Moved feature enablement from plugin opts to autocmds
- ✅ Fixed vim parser query incompatibilities with updated grammar

---

## Files Modified

### 1. `lua/plugins/treesitter.lua`
- Removed `commit = "42fc28b"` pin
- Removed nvim-treesitter-textobjects dependency
- Simplified configuration (removed highlight/indent/textobjects opts)
- Updated to new API: `require("nvim-treesitter").setup()`
- Added runtimepath configuration for query priority
- Kept incremental_selection (still supported in 1.0)

### 2. `lua/core/autocmds.lua`
- Added autocmd to enable treesitter features per-filetype:
  - `vim.treesitter.start()` for highlighting
  - Per-filetype foldexpr for folding
  - Per-filetype indentexpr for indentation

### 3. `lua/core/options.lua`
- Commented out global `foldexpr` (now set per-filetype via autocmd)

### 4. Parser Query Fix
**Fixed:** `~/.local/share/nvim/lazy/nvim-treesitter/runtime/queries/vim/highlights.scm`

The vim parser grammar was updated to remove certain node types, but the highlights query still referenced them. Fixed by commenting out:
- Line 113: `"tab"` node
- Line 131: `"substitute"` node  
- Lines 254-255: `heredoc` block with `parameter` node
- Lines 257-258: `script` block with `parameter` node

---

## Issue: noice.nvim Query Errors

### Problem
After migration, noice.nvim was triggering errors:
```
Query error at 113:4. Invalid node type "tab"
Query error at 131:0. Invalid node type "substitute"
Query error at 255:0. Invalid node type "parameter"
```

### Root Cause
The vim tree-sitter parser was updated with breaking grammar changes that removed certain node types (`tab`, `substitute`, `parameter`), but the bundled highlight queries in nvim-treesitter still referenced them.

### Solution Applied
1. **Prepended nvim-treesitter runtime to runtimepath** to give nvim-treesitter queries priority over Neovim's built-in queries
2. **Manually patched the vim highlights query** to comment out invalid node references
3. **Installed all parsers noice needs:** vim, lua, regex, bash, markdown

---

## Scripts Created

### 1. `rollback_treesitter.sh`
Rollback script to restore pre-migration state:
- Restores git config from `backup-treesitter-legacy` branch
- Restores parser directory from backup
- Optionally downgrades tree-sitter-cli
- Restores plugins from lazy-lock.json

### 2. `fix_vim_query.sh`
Automated fix for vim highlights query issues:
- Backs up original query file
- Comments out invalid node types
- Can be run after nvim-treesitter updates if errors recur

### 3. `treesitter_test.lua`
Comprehensive test file with instructions for:
- Syntax highlighting
- Folding
- Incremental selection
- Indentation
- mini.ai textobjects

---

## Parsers Installed

Located in: `~/.local/share/nvim/lazy/nvim-treesitter/parser/`

Installed parsers (20+):
- bash, c, diff, html, javascript, jsdoc, json, jsonc
- lua, luadoc, luap, markdown, markdown_inline, python
- query, regex, toml, tsx, typescript, vim, vimdoc
- xml, yaml

---

## Known Issues & Notes

### 1. Vim Query Requires Manual Patching
The vim highlights query may need re-patching after nvim-treesitter updates. If you see query errors about "tab", "substitute", or "parameter", run:
```bash
./fix_vim_query.sh
```

### 2. Indentation is Experimental
Treesitter-based indentation may have quirks. If specific languages have issues, remove them from the autocmd pattern list in `lua/core/autocmds.lua`.

### 3. No Textobject Move Commands
Lost `]f`, `[c`, etc. from nvim-treesitter-textobjects. Using mini.ai for all textobject operations now.

### 4. Parser Location Changed
Parsers now live in the plugin directory (`lazy/nvim-treesitter/parser/`) instead of Neovim's data directory (`site/parser/`). This is normal for the new version.

---

## Testing Checklist

- [x] Neovim starts without errors
- [x] Syntax highlighting works (tested: lua, python, vim)
- [x] Folding works with `za`/`zR`/`zM`
- [x] Incremental selection works with `<C-space>`
- [x] mini.ai textobjects work (`vif`, `vio`, etc.)
- [x] noice.nvim UI displays without query errors
- [x] All required parsers load successfully
- [x] `:checkhealth nvim-treesitter` passes

---

## Rollback Instructions

If you need to rollback:

```bash
# From nvim config directory:
./rollback_treesitter.sh

# Then restart Neovim
```

Or manually:
```bash
git reset --hard backup-treesitter-legacy
nvim --headless "+Lazy! restore" +qa
```

---

## Upstream Issue

The vim query incompatibility should be reported to nvim-treesitter repository. The vim parser grammar update removed nodes that the highlight queries still reference.

**Temporary workaround:** Manual query patching (automated via `fix_vim_query.sh`)

**Permanent fix:** Awaiting nvim-treesitter upstream fix

---

## Success Criteria Met ✅

- ✅ tree-sitter-cli upgraded to 0.26.3
- ✅ nvim-treesitter updated to latest (1.0 rewrite)
- ✅ All parsers installed and working
- ✅ All queries load without errors
- ✅ noice.nvim works without query errors
- ✅ All treesitter features functional
- ✅ Rollback script created
- ✅ Migration fully documented

---

## Next Steps

1. **Monitor for errors** during regular use
2. **Check for nvim-treesitter updates** - may fix vim query issue upstream
3. **Report vim query issue** to nvim-treesitter if not already reported
4. **Consider updating noice.nvim** - it's also pinned to an old commit

---

## Notes for Future Updates

When updating nvim-treesitter in the future:

1. Check if vim highlights query was fixed upstream
2. If query errors return, run `./fix_vim_query.sh`
3. Test all features in `treesitter_test.lua`
4. Check `:messages` for any new errors

