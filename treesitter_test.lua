-- Treesitter 1.0 Migration Test File
-- This file tests all treesitter features after migration
-- Created: 2025-12-27

-- ============================================
-- TEST 1: SYNTAX HIGHLIGHTING
-- ============================================
-- Instructions:
--   1. Open this file in Neovim
--   2. Verify colors are applied to keywords, strings, functions
--   3. Run :Inspect on various tokens to see treesitter groups
--   Expected: @keyword.function, @string, @variable, etc.

local function test_highlighting()
  local message = "Hello, Treesitter 1.0!"
  print(message)
  return true
end

-- ============================================
-- TEST 2: FOLDING
-- ============================================
-- Instructions:
--   1. Place cursor on line with "function test_folding()"
--   2. Press 'za' to toggle fold
--   3. Function body should fold/unfold
--   4. Press 'zR' to open all folds
--   Expected: Smooth folding based on treesitter nodes

local function test_folding()
  if true then
    print("This is inside an if block")
    
    for i = 1, 10 do
      print("Loop iteration: " .. i)
    end
    
    local nested = function()
      return "nested function"
    end
  end
  
  return "folding test complete"
end

-- ============================================
-- TEST 3: INCREMENTAL SELECTION
-- ============================================
-- Instructions:
--   1. Place cursor inside the string "expand"
--   2. Press <C-space> - should select "expand"
--   3. Press <C-space> - should expand to full string
--   4. Press <C-space> - should expand to return statement
--   5. Press <C-space> - should expand to function body
--   6. Press <bs> - should shrink back one level
--   Expected: Selection grows/shrinks intelligently

local function test_incremental_selection()
  local test = "expand"
  return "test complete: " .. test
end

-- ============================================
-- TEST 4: INDENTATION
-- ============================================
-- Instructions:
--   1. Place cursor at end of line with "if condition then"
--   2. Press <Enter> to create new line
--   3. Cursor should auto-indent properly
--   4. Type some code and press <Enter> again
--   5. Test with nested blocks
--   Expected: Auto-indentation works (may have quirks - it's experimental)

local function test_indentation()
  local condition = true
  
  if condition then
    -- Try creating a new line here and see if it indents
    print("indented")
    
    if condition then
      -- Try creating nested indents
      print("double indented")
    end
  end
end

-- ============================================
-- TEST 5: MINI.AI TEXTOBJECTS
-- ============================================
-- Instructions:
--   Test these textobject commands:
--   
--   Function textobjects:
--     vif - select inner function (body only)
--     vaf - select around function (including 'local function...end')
--   
--   Block textobjects (via mini.ai):
--     vio - select inner block/conditional/loop
--     vao - select around block/conditional/loop
--   
--   Other mini.ai textobjects:
--     vic - select inner class (if applicable)
--     vac - select around class
--   
--   Expected: All textobjects work as before

local TestClass = {}

function TestClass:new()
  local obj = {}
  setmetatable(obj, self)
  self.__index = self
  return obj
end

function TestClass:method_one()
  print("Testing textobjects")
  
  for i = 1, 5 do
    if i % 2 == 0 then
      print("even: " .. i)
    else
      print("odd: " .. i)
    end
  end
end

function TestClass:method_two()
  return "second method"
end

-- ============================================
-- TEST SUMMARY
-- ============================================
-- After running all tests above, verify:
--   [✓] Syntax highlighting works
--   [✓] Folding works with za/zR/zM
--   [✓] Incremental selection works with <C-space>/<bs>
--   [✓] Auto-indentation works (mostly)
--   [✓] mini.ai textobjects work (vif, vio, etc.)
--
-- If all tests pass, migration is successful!
-- If issues occur, check:
--   :checkhealth nvim-treesitter
--   :messages
--   :TSInstallInfo
--
-- To rollback if needed:
--   ./rollback_treesitter.sh

-- Run all tests
local function run_all_tests()
  print("=== Treesitter 1.0 Migration Tests ===")
  test_highlighting()
  test_folding()
  test_incremental_selection()
  test_indentation()
  print("=== All tests defined ===")
  print("Follow instructions in comments above each function")
end

-- Uncomment to run:
-- run_all_tests()

return {
  test_highlighting = test_highlighting,
  test_folding = test_folding,
  test_incremental_selection = test_incremental_selection,
  test_indentation = test_indentation,
  run_all_tests = run_all_tests,
}
