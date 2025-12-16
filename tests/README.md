# Test Suite Documentation

This directory contains comprehensive automated tests for the Neovim configuration.

## Structure

- `minimal_init.lua` - Minimal Neovim config for running tests
- `helpers/` - Test utilities, mocks, and assertions
- `core/` - Tests for core modules (aicli, options, keymaps, autocmds)
- `plugins/` - Plugin validation tests (commit pinning)
- `integration/` - Integration tests for LSP and plugin loading

## Running Tests

### All tests

```bash
make test
```

### Specific test suites

```bash
make test-core         # Core module tests only
make test-plugins      # Plugin validation only
make test-integration  # Integration tests only
```

### Watch mode (requires `entr`)

```bash
make test-watch
```

### Linting and formatting

```bash
make lint           # Run luacheck
make format         # Run stylua
make format-check   # Check formatting without modifying files
```

## Writing Tests

### Test Structure

Use plenary.nvim's `describe`/`it` syntax:

```lua
local helpers = require("tests.helpers")

describe("module_name", function()
  before_each(function()
    helpers.setup()  -- Reset state
  end)

  after_each(function()
    helpers.teardown()
  end)

  describe("function_name", function()
    it("should do something", function()
      -- Arrange
      local input = "test"

      -- Act
      local result = some_function(input)

      -- Assert
      assert.are.equal("expected", result)
    end)
  end)
end)
```

### Mocking

Use test helpers for mocking:

```lua
local mock = require("tests.helpers.mock")

-- Mock file I/O
local file_io = mock.mock_file_io()
file_io.files["/path/to/file"] = "content"
-- ... test code ...
file_io.restore()

-- Mock executables
local exec_mock = mock.mock_executable({ git = true, node = false })
-- ... test code ...
exec_mock.restore()

-- Mock vim.fn.system
local system_mock = mock.mock_system({
  ["git status"] = "clean",
})
assert.are.equal(1, system_mock.call_count["git status"])
system_mock.restore()
```

### Best Practices

1. **Isolation**: Each test should be independent and not affect other tests
2. **Reset State**: Use `helpers.setup()` and `helpers.teardown()` consistently
3. **Mock External Calls**: Mock file I/O, system calls, and vim APIs
4. **Descriptive Names**: Use clear test names that describe what is being tested
5. **Arrange-Act-Assert**: Follow AAA pattern for test clarity
6. **Edge Cases**: Test both happy path and error conditions
7. **Async Operations**: Use `helpers.wait_for()` for async tests

### Handling Flaky Tests

- Use `vim.wait()` for async operations instead of fixed delays
- Mock `vim.defer_fn` to execute immediately in tests
- Isolate tests that depend on timing
- Use retry logic for unavoidable timing issues

## CI Integration

Tests run automatically on:

- Push to `main` branch
- Pull requests
- Weekly schedule (Mondays at 9 AM UTC)

Tests run on:

- Ubuntu and macOS
- Neovim stable and nightly versions

## Troubleshooting

### Tests fail locally but pass in CI

- Check Neovim version (`nvim --version`)
- Ensure plenary.nvim is installed
- Clear plugin cache: `rm -rf ~/.local/share/nvim`

### Plugin validation fails

- Ensure all plugins have `commit = "abc1234"` fields
- Commit hashes must be exactly 7 characters
- Don't use `branch`, `tag`, or `version` fields

### Mock not working

- Ensure you call `.restore()` on mocks in `after_each`
- Check that mock is applied before requiring the module under test
- For persistent mocks, clear `package.loaded["module"]` first

## Test Coverage

Current test coverage:

- **aicli.lua**: Comprehensive state/I/O/tool detection testing
- **options.lua**: All utility functions covered
- **keymaps.lua**: Keymap creation verified
- **autocmds.lua**: Autocmd creation and behavior tested
- **Plugin pinning**: All 18 files + lazy.nvim validated
- **Plugin loading**: All specs loadable without errors
