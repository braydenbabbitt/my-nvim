-- LSP Restart Module
-- Restarts the LSP clients attached to the current buffer in three tracked
-- phases, reporting progress via a Snacks notification:
--   1. Stopping   (0..33%)  -- wait for the old server processes to exit
--   2. Attaching  (33..66%) -- re-trigger filetype and wait for re-attach
--   3. Indexing   (66..100%) -- follow each server's workspace indexing via
--                               LSP `$/progress` (workDoneProgress) reports

local M = {}

-- Tick interval and per-phase timeouts (in 50ms ticks)
local TICK_MS = 50
local STOP_TIMEOUT = 40 -- ~2s for clients to stop
local ATTACH_TIMEOUT = 60 -- ~3s for buffers to re-attach
local INDEX_GRACE = 30 -- ~1.5s to let servers begin reporting before assuming idle
local INDEX_TIMEOUT = 600 -- ~30s cap on waiting for indexing to finish

-- Render a fixed-width progress bar for the given fraction (0..1)
local function progress_bar(fraction)
  local width = 20
  local filled = math.floor(fraction * width + 0.5)
  return string.format(
    "[%s%s] %d%%",
    string.rep("█", filled),
    string.rep("░", width - filled),
    math.floor(fraction * 100 + 0.5)
  )
end

-- Restart the LSP clients for the current buffer (and every other buffer those
-- clients serve, since stopping a client kills its server for all of them).
function M.restart_buffer_clients()
  local buf = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = buf })

  if #clients == 0 then
    vim.notify("No active LSP clients for current buffer", vim.log.levels.WARN)
    return
  end

  local client_names = {}
  local client_ids = {}
  -- Collect every buffer these clients serve, not just the current one, so we
  -- can re-attach all of them after the servers stop (stop_client kills the
  -- server process for ALL its buffers).
  local affected_bufs = {}
  for _, client in ipairs(clients) do
    table.insert(client_names, client.name)
    table.insert(client_ids, client.id)
    for attached_buf in pairs(client.attached_buffers) do
      affected_bufs[attached_buf] = true
    end
  end

  local names = table.concat(client_names, ", ")
  local notif_id = "lsp-restart"
  local total = #client_ids

  local function update(fraction, message, opts)
    Snacks.notifier.notify(
      progress_bar(fraction) .. "  " .. message,
      (opts and opts.level) or vim.log.levels.INFO,
      vim.tbl_extend("force", { id = notif_id, title = "LSP Restart", timeout = false }, opts or {})
    )
  end

  -- Track workspace-indexing progress per client via the LSP `$/progress`
  -- (workDoneProgress) notifications surfaced by the LspProgress autocmd.
  -- Registered BEFORE re-triggering attach so we don't miss early `begin`
  -- events that fire the moment a server initializes.
  local progress = {} -- client_id -> { active = N, ever_began = bool, pct = number? }
  local aug = vim.api.nvim_create_augroup("lsp-restart-progress", { clear = true })
  local function cleanup_autocmd()
    pcall(vim.api.nvim_del_augroup_by_id, aug)
  end
  vim.api.nvim_create_autocmd("LspProgress", {
    group = aug,
    callback = function(ev)
      local cid = ev.data and ev.data.client_id
      local value = ev.data and ev.data.params and ev.data.params.value
      if not cid or type(value) ~= "table" then
        return
      end
      local e = progress[cid] or { active = 0, ever_began = false, pct = nil }
      if value.kind == "begin" then
        e.active = e.active + 1
        e.ever_began = true
        e.pct = value.percentage
      elseif value.kind == "report" then
        if value.percentage ~= nil then
          e.pct = value.percentage
        end
      elseif value.kind == "end" then
        e.active = math.max(0, e.active - 1)
      end
      progress[cid] = e
    end,
  })

  update(0, "Stopping " .. names)

  -- Clear stale diagnostics for the affected buffers across all namespaces
  for affected_buf in pairs(affected_bufs) do
    if vim.api.nvim_buf_is_valid(affected_buf) then
      vim.diagnostic.reset(nil, affected_buf)
    end
  end

  -- Stop the clients (force) so the server process actually exits
  vim.lsp.stop_client(client_ids, true)

  local timer = vim.uv.new_timer()
  local done = false
  local phase = "stopping"
  local stop_attempts = 0
  local attach_attempts = 0
  local index_attempts = 0
  -- Buffers we expect to get a client back after re-triggering filetype
  local target_bufs = {}

  -- Resolve the run: stop the timer, tear down the autocmd, emit a final message
  local function finish(fraction, message, opts)
    done = true
    if not timer:is_closing() then
      timer:stop()
      timer:close()
    end
    cleanup_autocmd()
    update(fraction, message, opts)
  end

  -- The set of clients currently serving the buffers we re-attached
  local function monitored_clients()
    local ids = {}
    for target_buf in pairs(target_bufs) do
      for _, client in ipairs(vim.lsp.get_clients({ bufnr = target_buf })) do
        ids[client.id] = true
      end
    end
    return ids
  end

  timer:start(TICK_MS, TICK_MS, vim.schedule_wrap(function()
    if done then
      return
    end

    if phase == "stopping" then
      stop_attempts = stop_attempts + 1

      local stopped = 0
      for _, id in ipairs(client_ids) do
        if not vim.lsp.get_client_by_id(id) then
          stopped = stopped + 1
        end
      end

      update(0.33 * (stopped / total), string.format("Stopping %s (%d/%d)", names, stopped, total))

      if stopped == total then
        -- Re-trigger attach on every affected buffer and move to phase 2
        for affected_buf in pairs(affected_bufs) do
          if vim.api.nvim_buf_is_valid(affected_buf) and vim.api.nvim_buf_is_loaded(affected_buf) then
            -- Reassigning the filetype re-fires the FileType autocmd that
            -- vim.lsp.enable() listens on, triggering re-attach.
            vim.bo[affected_buf].filetype = vim.bo[affected_buf].filetype
            target_bufs[affected_buf] = true
          end
        end
        phase = "attaching"
      elseif stop_attempts > STOP_TIMEOUT then
        finish(0.33 * (stopped / total), "Timed out waiting for clients to stop: " .. names, {
          level = vim.log.levels.WARN,
          icon = "",
          timeout = 4000,
        })
      end
    elseif phase == "attaching" then
      attach_attempts = attach_attempts + 1

      local target_total, attached = 0, 0
      for target_buf in pairs(target_bufs) do
        target_total = target_total + 1
        if #vim.lsp.get_clients({ bufnr = target_buf }) > 0 then
          attached = attached + 1
        end
      end

      local frac = target_total > 0 and (attached / target_total) or 1
      update(0.33 + 0.33 * frac, string.format("Re-attaching %s (%d/%d buffers)", names, attached, target_total))

      if attached >= target_total then
        phase = "indexing"
      elseif attach_attempts > ATTACH_TIMEOUT then
        finish(0.33 + 0.33 * frac, string.format("Re-attached %d/%d buffers for %s", attached, target_total, names), {
          level = vim.log.levels.WARN,
          icon = "",
          timeout = 4000,
        })
      end
    elseif phase == "indexing" then
      index_attempts = index_attempts + 1

      -- Aggregate each monitored client's indexing progress into one fraction.
      local n, sum, any_active = 0, 0, false
      for cid in pairs(monitored_clients()) do
        n = n + 1
        local e = progress[cid]
        if e and e.active > 0 then
          -- Still indexing: use reported percentage if the server gives one
          any_active = true
          sum = sum + (e.pct or 0) / 100
        elseif e and e.ever_began then
          -- Began and all tokens ended: this client finished indexing
          sum = sum + 1
        else
          -- No progress seen yet. During the grace window assume it may still
          -- begin; afterwards treat it as "nothing to index" so we don't hang.
          if index_attempts <= INDEX_GRACE then
            any_active = true
          else
            sum = sum + 1
          end
        end
      end

      local frac = n > 0 and (sum / n) or 1
      update(0.66 + 0.34 * frac, string.format("Indexing %s", names))

      -- Done once past the grace window with no client actively indexing
      if not any_active and index_attempts > INDEX_GRACE then
        finish(1, string.format("Restarted %s across %d buffer%s", names, n, n == 1 and "" or "s"), {
          icon = "",
          timeout = 2500,
        })
      elseif index_attempts > INDEX_TIMEOUT then
        finish(0.66 + 0.34 * frac, "Restarted " .. names .. "; indexing still in progress", {
          level = vim.log.levels.WARN,
          icon = "",
          timeout = 4000,
        })
      end
    end
  end))
end

return M
