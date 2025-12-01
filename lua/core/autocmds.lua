-- Autocommands
-- Automatic commands triggered on specific events

-- Auto-format JavaScript/TypeScript files with ESLint on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.tsx", "*.ts", "*.jsx", "*.js" },
  command = "silent! EslintFixAll",
  desc = "Auto-fix ESLint errors on save",
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  pattern = {
    "qf",
    "help",
    "man",
    "notify",
    "lspinfo",
    "startuptime",
    "checkhealth",
    "grug-far",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true, desc = "Close window" })
  end,
})

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = vim.api.nvim_create_augroup("checktime", { clear = true }),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- Resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = vim.api.nvim_create_augroup("resize_splits", { clear = true }),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- Go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = vim.api.nvim_create_augroup("last_loc", { clear = true }),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].last_loc then
      return
    end
    vim.b[buf].last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Enable text wrapping for markdown and text files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "text" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true -- Break lines at word boundaries
  end,
  desc = "Enable text wrapping for markdown and text files",
})

-- Fix Snacks terminal to allow global :q/:qa commands
-- Snacks terminal creates buffer-local keymaps and autocmds that intercept quit commands
vim.api.nvim_create_autocmd("FileType", {
  pattern = "snacks_terminal",
  callback = function(event)
    -- Use a longer delay to ensure Snacks has finished setting up
    vim.defer_fn(function()
      if not vim.api.nvim_buf_is_valid(event.buf) then
        return
      end

      -- Clear ALL autocmds on this buffer for ExitPre
      local autocmds = vim.api.nvim_get_autocmds({ event = "ExitPre", buffer = event.buf })
      for _, au in ipairs(autocmds) do
        pcall(vim.api.nvim_del_autocmd, au.id)
      end

      -- Also clear global ExitPre autocmds that might reference this buffer
      local all_exit_autocmds = vim.api.nvim_get_autocmds({ event = "ExitPre" })
      for _, au in ipairs(all_exit_autocmds) do
        if au.buflocal == false then
          -- Check if this is a Snacks autocmd by looking at the group name
          if au.group_name and au.group_name:match("snacks") then
            pcall(vim.api.nvim_del_autocmd, au.id)
          end
        end
      end

      -- Remove the buffer-local 'q' keymap that hides the terminal
      pcall(vim.keymap.del, "n", "q", { buffer = event.buf })

      -- Set a new 'q' keymap that just closes the terminal window
      vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true, desc = "Close terminal window" })
    end, 100)
  end,
})
