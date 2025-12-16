describe("plugin commit pinning", function()
  local plugin_files = {
    "autotag.lua",
    "blink.lua",
    "bufferline.lua",
    "cloak.lua",
    "colorscheme.lua",
    "conform.lua",
    "editor.lua",
    "git.lua",
    "grug-far.lua",
    "lsp.lua",
    "lualine.lua",
    "luasnip.lua",
    "noice.lua",
    "snacks.lua",
    "telescope.lua",
    "todo-comments.lua",
    "treesitter.lua",
    "trouble.lua",
    "which-key.lua",
  }

  for _, file in ipairs(plugin_files) do
    describe(file, function()
      it("should have all plugins pinned to commits", function()
        local path = vim.fn.getcwd() .. "/lua/plugins/" .. file
        local content = table.concat(vim.fn.readfile(path), "\n")

        -- Find all plugin specs (tables with string values starting with ")
        local commit_count = 0

        for line in content:gmatch("[^\r\n]+") do
          -- Match commit pin
          if line:match('commit%s*=%s*"[%w]+"') then
            commit_count = commit_count + 1
          end
        end

        -- Special cases:
        -- - Some files have multiple plugins
        if file == "lsp.lua" then
          -- mason.nvim, mason-lspconfig.nvim, nvim-lspconfig = 3 commits
          assert.is_true(commit_count >= 3, string.format("Expected at least 3 commits in lsp.lua, found %d", commit_count))
        elseif file == "editor.lua" then
          -- mini.pairs, mini.surround, mini.comment, mini.ai, better-escape, indent-blankline, nvim-ts-context-commentstring = 7 commits
          assert.is_true(
            commit_count >= 7,
            string.format("Expected at least 7 commits in editor.lua, found %d", commit_count)
          )
        elseif file == "telescope.lua" then
          -- telescope + plenary + fzf-native = 3 commits
          assert.is_true(
            commit_count >= 3,
            string.format("Expected at least 3 commits in telescope.lua, found %d", commit_count)
          )
        elseif file == "colorscheme.lua" then
          -- vscode + tokyonight + catppuccin = 3 commits
          assert.is_true(
            commit_count >= 3,
            string.format("Expected at least 3 commits in colorscheme.lua, found %d", commit_count)
          )
        elseif file == "git.lua" then
          -- gitsigns = 1 commit
          assert.is_true(commit_count >= 1, string.format("Expected at least 1 commit in git.lua, found %d", commit_count))
        else
          -- Most files have 1 main plugin
          assert.is_true(commit_count >= 1, string.format("Expected at least 1 commit in %s, found %d", file, commit_count))
        end
      end)

      it("should not use branch or tag pinning", function()
        local path = vim.fn.getcwd() .. "/lua/plugins/" .. file
        local content = table.concat(vim.fn.readfile(path), "\n")

        -- Check for branch or tag fields (which we want to avoid)
        local has_branch = content:match('branch%s*=%s*"')
        local has_tag = content:match('tag%s*=%s*"')

        assert.is_nil(has_branch, string.format("%s should not use branch pinning", file))
        assert.is_nil(has_tag, string.format("%s should not use tag pinning", file))

        -- version can be false (we explicitly set version = false in lazy config)
        -- so we only check if it's set to a string value for plugin pinning
        -- Exclude runtime settings like `runtime = { version = "LuaJIT" }`
        local version_value = content:match('[^_]version%s*=%s*"([^"]+)"%s*,')
        if version_value and version_value ~= "LuaJIT" then
          assert.fail(string.format("%s should not use version pinning (found: %s)", file, version_value))
        end
      end)

      it("should have valid 7-character commit hashes", function()
        local path = vim.fn.getcwd() .. "/lua/plugins/" .. file
        local content = table.concat(vim.fn.readfile(path), "\n")

        for commit in content:gmatch('commit%s*=%s*"([%w]+)"') do
          -- Check that commit hash is 7 characters (standard short hash)
          assert.are.equal(
            7,
            #commit,
            string.format("Commit hash should be 7 characters, got %s (%d chars)", commit, #commit)
          )

          -- Check that it only contains valid hex characters
          assert.is_not_nil(
            commit:match("^[a-f0-9]+$"),
            string.format("Commit hash should only contain hex characters, got %s", commit)
          )
        end
      end)
    end)
  end

  describe("lazy.nvim bootstrap", function()
    it("should pin lazy.nvim to a specific commit", function()
      local path = vim.fn.getcwd() .. "/init.lua"
      local content = table.concat(vim.fn.readfile(path), "\n")

      local lazytag = content:match('local lazytag = "([%w]+)"')
      assert.is_not_nil(lazytag, "lazy.nvim should be pinned to a commit")
      assert.are.equal(7, #lazytag, "lazy.nvim commit hash should be 7 characters")
    end)
  end)
end)
