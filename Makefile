.PHONY: test test-watch test-core test-plugins test-integration lint format setup

# Run all tests
test:
	@echo "Running all tests..."
	nvim --headless --noplugin -u tests/minimal_init.lua \
		-c "PlenaryBustedDirectory tests/ { minimal_init = 'tests/minimal_init.lua' }"

# Run tests in watch mode (requires entr)
test-watch:
	@echo "Running tests in watch mode (requires 'entr')..."
	find lua/ tests/ -name '*.lua' | entr -c make test

# Run only core module tests
test-core:
	@echo "Running core module tests..."
	nvim --headless --noplugin -u tests/minimal_init.lua \
		-c "PlenaryBustedDirectory tests/core/ { minimal_init = 'tests/minimal_init.lua' }"

# Run only plugin validation tests
test-plugins:
	@echo "Running plugin validation tests..."
	nvim --headless --noplugin -u tests/minimal_init.lua \
		-c "PlenaryBustedDirectory tests/plugins/ { minimal_init = 'tests/minimal_init.lua' }"

# Run integration tests
test-integration:
	@echo "Running integration tests..."
	nvim --headless --noplugin -u tests/minimal_init.lua \
		-c "PlenaryBustedDirectory tests/integration/ { minimal_init = 'tests/minimal_init.lua' }"

# Lint Lua files
lint:
	@echo "Linting Lua files..."
	@if command -v luacheck >/dev/null 2>&1; then \
		luacheck lua/ tests/ --globals vim; \
	else \
		echo "luacheck not installed. Install with: luarocks install luacheck"; \
		exit 1; \
	fi

# Format Lua files
format:
	@echo "Formatting Lua files..."
	@if command -v stylua >/dev/null 2>&1; then \
		stylua lua/ tests/; \
	else \
		echo "stylua not installed. Install with: cargo install stylua"; \
		exit 1; \
	fi

# Check formatting without modifying files
format-check:
	@echo "Checking Lua file formatting..."
	@if command -v stylua >/dev/null 2>&1; then \
		stylua --check lua/ tests/; \
	else \
		echo "stylua not installed. Install with: cargo install stylua"; \
		exit 1; \
	fi

# Install test dependencies
setup:
	@echo "Test setup instructions:"
	@echo "1. plenary.nvim is automatically installed via lazy.nvim"
	@echo "2. For linting: luarocks install luacheck"
	@echo "3. For formatting: cargo install stylua"
	@echo "4. For watch mode: brew install entr (macOS) or apt-get install entr (Linux)"
