-- -- スピナーフレーム（好きに差し替え可能）
-- local spinner_frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
-- local spinner_index = 1
-- local timer = vim.loop.new_timer()
--
-- -- 通知ハンドル保持（同じ通知を更新するため）
-- local notif_id = nil
--
-- -- スピナー開始
-- local function start_lsp_spinner()
--   if timer:is_active() then return end
--
--   timer:start(0, 100, vim.schedule_wrap(function()
--     local status = vim.lsp.status()
--     if status == nil or status == "" then
--       -- LSPがアイドルになったらスピナーを止める
--       if timer:is_active() then
--         timer:stop()
--         notif_id = vim.notify("LSP idle", vim.log.levels.INFO, { replace = notif_id })
--       end
--       return
--     end
--
--     -- スピナー更新
--     spinner_index = (spinner_index % #spinner_frames) + 1
--     local frame = spinner_frames[spinner_index]
--     notif_id = vim.notify(frame .. " " .. status,
--       vim.log.levels.INFO,
--       { replace = notif_id, hide_from_history = true })
--   end))
-- end
--
-- -- 任意のタイミングで呼ぶ（LspAttachでもOK）
-- vim.api.nvim_create_autocmd("LspAttach", {
--   callback = function()
--     start_lsp_spinner()
--   end,
-- })

-- -- シンプルな spinner 実装 (vim.notify版)
-- local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
-- local spinner_index = 1
-- local running = false
-- local notify_id = nil
--
-- local function spin(title)
--   if not running then
--     return
--   end
--
--   spinner_index = (spinner_index % #spinner) + 1
--   local msg = spinner[spinner_index] .. " " .. title
--
--   -- NOTE: vim.notify は "replace" オプションがないので、
--   -- 単純に新しい通知を毎回出すことになる
--   -- （履歴が溜まるのを避けるのは難しい）
--   notify_id = vim.notify(msg, vim.log.levels.INFO, {
--     title = "LSP Progress",
--   })
--
--   vim.defer_fn(function()
--     spin(title)
--   end, 120) -- 120ms ごとに更新
-- end
--
-- -- 開始
-- local function start_progress()
--   if running then
--     return
--   end
--   running = true
--   spinner_index = 1
--   spin("Loading workspace...")
-- end
--
-- -- 停止
-- local function stop_progress()
--   running = false
--   vim.notify("✔ Done", vim.log.levels.INFO, { title = "LSP Progress" })
-- end
--
-- -- デモ用コマンド
-- vim.api.nvim_create_user_command("ProgressDemoStart", start_progress, {})
-- vim.api.nvim_create_user_command("ProgressDemoStop", stop_progress, {})

--

--
-- -- vim.lsp.status() を整形
-- local function format_status()
--   local status = vim.lsp.status()
--   local parts = vim.split(status, ",%s*")
--   local percent, other = {}, {}
--
--   for _, part in ipairs(parts) do
--     part = vim.trim(part)
--     if part:match("%d+%%") then
--       table.insert(percent, part)
--     elseif part ~= "" then
--       table.insert(other, part)
--     end
--   end
--
--   if #percent > 0 then
--     return table.concat(percent, "\n")
--   elseif #other > 0 then
--     return table.concat(vim.list_slice(other, 1, 3), "\n") -- 上位3件だけ
--   else
--     return "Idle"
--   end
-- end
--
-- -- スピナー更新ループ
local spinner = { "⠋", "⠙", "⠸", "⠴", "⠦", "⠇", }
local spinner_index = 1
local function spin()
  if not running then
    return
  end
  spinner_index = (spinner_index % #spinner) + 1
  local spin_msg = spinner[spinner_index]
  print(spin_msg)
  vim.defer_fn(spin, 1000)
end
--
-- 開始
local function start_progress()
  if running then return end
  running = true
  spinner_index = 1
  spin()
end

-- 停止
local function stop_progress()
  running = false
end

-- デモ用コマンド
vim.api.nvim_create_user_command("ProgressDemoStart", start_progress, {})
vim.api.nvim_create_user_command("ProgressDemoStop", stop_progress, {})

-- nvim_echoを使うパターンを模索する。

vim.api.nvim_create_autocmd('LspProgress', {
  callback = function(lsp)
    local value = lsp.data.params.value
    local client_name = vim.lsp.get_client_by_id(lsp.data.client_id).name
    local echo_opt = {
      kind = "progress",
      title = "LSP Progress",
      status = "running",
      percent = value.percentage or 0
    }
    local extui_opt = {
      enable = true,
      msg = {
        target = "msg",
        timeout = 5000
      }
    }
    
    extui_opt.msg.timeout = 1000
    require("vim._extui").enable(extui_opt)

    if value.kind == 'begin' then
      echo_opt.id = vim.api.nvim_echo({ { "LSP initialize" } }, true, echo_opt)
    elseif value.kind == 'end' then
      echo_opt.status = "success"
      echo_opt.id = vim.api.nvim_echo({ { client_name }, { " loaded" } }, true, echo_opt)
    elseif value.kind == 'report' then
      echo_opt.title = ""
      echo_opt.id = vim.api.nvim_echo({ { client_name }, { " loading..." } }, true, echo_opt)
    end

    extui_opt.msg.timeout = 5000
    require("vim._extui").enable(extui_opt)
  end,
})
