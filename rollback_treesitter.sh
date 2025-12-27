#!/bin/bash
# Rollback script for treesitter 1.0 migration
# Created: 2025-12-27
# Purpose: Restore nvim-treesitter to pre-migration state if issues occur

set -e

echo "🔄 Rolling back nvim-treesitter migration..."
echo ""

# Get the directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# 1. Restore git state
echo "📂 Restoring git configuration..."
cd "$SCRIPT_DIR"
git reset --hard backup-treesitter-legacy
echo "✅ Git config restored to backup-treesitter-legacy branch"
echo ""

# 2. Restore old parsers
echo "📦 Restoring parser directory..."
if [ -d ~/.local/share/nvim/site/parser.backup ]; then
  rm -rf ~/.local/share/nvim/site/parser
  mv ~/.local/share/nvim/site/parser.backup ~/.local/share/nvim/site/parser
  echo "✅ Parser directory restored from backup"
else
  echo "⚠️  No parser backup found at ~/.local/share/nvim/site/parser.backup"
  echo "   Parsers will be reinstalled on next Neovim launch"
fi
echo ""

# 3. Downgrade tree-sitter-cli (optional)
echo "🔧 tree-sitter-cli downgrade (optional)"
read -p "Downgrade tree-sitter-cli from 0.26.3 to 0.25.10? (y/N) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
  npm install -g tree-sitter-cli@0.25.10
  echo "✅ tree-sitter-cli downgraded to 0.25.10"
else
  echo "⏭️  Keeping tree-sitter-cli at current version"
fi
echo ""

# 4. Clean and reinstall plugins
echo "🔌 Restoring plugins from lazy-lock.json..."
nvim --headless "+Lazy! restore" +qa 2>/dev/null || true
echo "✅ Plugins restored"
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🎉 Rollback complete!"
echo ""
echo "Changes applied:"
echo "  ✅ Config files restored to pre-migration state"
echo "  ✅ Parser directory restored (if backup existed)"
echo "  ✅ Plugins restored from lazy-lock.json"
if [[ $REPLY =~ ^[Yy]$ ]]; then
  echo "  ✅ tree-sitter-cli downgraded to 0.25.10"
fi
echo ""
echo "Next steps:"
echo "  1. Restart Neovim"
echo "  2. Run :checkhealth nvim-treesitter"
echo "  3. Run :TSUpdate if needed"
echo ""
echo "Note: If you want to try the migration again,"
echo "      delete the backup branch first:"
echo "      git branch -D backup-treesitter-legacy"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
