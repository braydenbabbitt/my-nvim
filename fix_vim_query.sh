#!/bin/bash
# Fix vim highlights query for nvim-treesitter
# This patches invalid node types that were removed in the vim parser update
# Run this after updating nvim-treesitter if you get query errors

QUERY_FILE="$HOME/.local/share/nvim/lazy/nvim-treesitter/runtime/queries/vim/highlights.scm"

if [ ! -f "$QUERY_FILE" ]; then
    echo "Error: vim highlights query not found at $QUERY_FILE"
    exit 1
fi

echo "Fixing vim highlights query..."

# Backup original if not already done
if [ ! -f "$QUERY_FILE.original" ]; then
    cp "$QUERY_FILE" "$QUERY_FILE.original"
    echo "✓ Created backup at $QUERY_FILE.original"
fi

# Fix line 113: comment out "tab" node
sed -i '113s/^  "tab"$/  ; "tab" -- Removed: not a valid node in updated vim parser/' "$QUERY_FILE"

# Fix line 131: comment out "substitute" node
sed -i '131s/^  "substitute"$/  ; "substitute" -- Removed: not a valid node in updated vim parser/' "$QUERY_FILE"

# Fix lines 254-255: comment out heredoc block with parameter
sed -i '254,255s/^/; /' "$QUERY_FILE"

# Fix lines 257-258: comment out script block with parameter  
sed -i '257,258s/^/; /' "$QUERY_FILE"

# Fix lines 321-322: comment out lua_statement block
sed -i '321,322s/^/; /' "$QUERY_FILE"

echo "✓ Applied fixes to vim highlights query"
echo ""
echo "Fixed nodes:"
echo "  - Line 113: 'tab' (invalid node)"
echo "  - Line 131: 'substitute' (invalid node)"
echo "  - Lines 254-255: 'heredoc' with parameter (invalid node)"
echo "  - Lines 257-258: 'script' with parameter (invalid node)"
echo "  - Lines 321-322: 'lua_statement' (invalid pattern)"
echo ""
echo "To restore original query: cp $QUERY_FILE.original $QUERY_FILE"
