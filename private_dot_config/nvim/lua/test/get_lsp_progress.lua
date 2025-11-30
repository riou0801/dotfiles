-- local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
-- local spinner_index = 1
-- local running = false
--
-- local function get_lsp_progress()
--   local status = vim.lsp.status()
--   if status == "" then
--     return nil
--   end
--
--   local parts = vim.split(status, ",%s*")
--   local cleaned = {}
--   for _, part in ipairs(parts) do
--     part = vim.trim(part):gsub('^"', ""):gsub('"$', "") -- 余計な " を除去
--     if part:find("%%") then                             -- パーセント付きだけ残す
--       table.insert(cleaned, part)
--     end
--   end
--
--   return cleaned
-- end
--
-- local function spin()
--   if not running then return end
--
--   spinner_index = (spinner_index % #spinner) + 1
--   local progress = get_lsp_progress()
--   local msg
--   if progress and #progress > 0 then
--     msg = spinner[spinner_index] .. " " .. table.concat(progress, "\n")
--   else
--     msg = "Idle"
--   end
--
--   vim.notify_once(msg, vim.log.levels.INFO, { title = "LSP Progress" })
--   vim.defer_fn(spin, 120)
-- end
--
-- local function start_progress()
--   if running then return end
--   running = true
--   spinner_index = 1
--   spin()
-- end
--
-- local function stop_progress()
--   running = false
--   vim.notify("✔ Done", vim.log.levels.INFO, { title = "LSP Progress" })
-- end
--
-- vim.api.nvim_create_user_command("ProgressDemoStart", start_progress, {})
-- vim.api.nvim_create_user_command("ProgressDemoStop", stop_progress, {})
-- -- テスト表示
-- -- vim.print(get_lsp_progress())
-- --
-- vim.api.nvim_create_autocmd('LspProgress', {
--   callback = function(ev)
--     local value = ev.data.params.value
--     if value.kind == 'begin' then
--       vim.notify('LSP initialize')
--     elseif value.kind == 'end' then
--       vim.notify('LSP loaded')
--     elseif value.kind == 'report' then
--       vim.notify('LSP loading...')
--     end
--   end,
-- })
local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
local spinner_index = 1
local running = false
local current_msg = "Idle"

local function spin()
  if not running then return end
  spinner_index = (spinner_index % #spinner) + 1
  local msg = spinner[spinner_index] .. " " .. current_msg
  vim.notify(msg, vim.log.levels.INFO)
  vim.defer_fn(spin, 120)
end

local function start_spinner()
  if running then return end
  running = true
  spinner_index = 1
  spin()
end

local function stop_spinner()
  running = false
  vim.notify("✔ Done", vim.log.levels.INFO, { title = "LSP Progress" })
end

local function get_lsp_status()
  local status = vim.lsp.status()
  if status == "" then return "Idle" end
  local parts = vim.split(status, ",%s*")
  local cleaned = {}
  for _, part in ipairs(parts) do
    part = vim.trim(part):gsub('^"', ""):gsub('"$', "")
    if part:find("%%") then
      table.insert(cleaned, part)
    end
  end
  if #cleaned == 0 then
    return "Idle"
  end
  return table.concat(cleaned, "\n")
end

-- LspProgress autocmd
vim.api.nvim_create_autocmd('LspProgress', {
  callback = function(ev)
    local value = ev.data.params.value
    if value.kind == 'begin' then
      current_msg = value.title or "LSP Task"
    elseif value.kind == 'end' then
      stop_spinner()
    elseif value.kind == 'report' then
      current_msg = get_lsp_status()
      start_spinner()
    end
  end,
})
