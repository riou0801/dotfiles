-- Chronicle Manager - fzf-lua Integration
-- Use chronicle read/write files as path lists for fzf-lua selection

local fzf = require('fzf-lua')
local utils = require('fzf-lua.utils')

local M = {}

-- Get chronicle file paths from global variables with fallbacks
local function get_chronicle_paths()
  local read_path = vim.g.chronicle_read_path or vim.fn.expand('~/.cache/chronicle/read')
  local write_path = vim.g.chronicle_write_path or vim.fn.expand('~/.cache/chronicle/write')
  return { read = read_path, write = write_path }
end

-- Read each line from the given file path and treat it as a file path
local function get_paths_from_file(file_path, label)
  local files = {}
  local f = io.open(file_path, "r")
  if not f then return files end

  for line in f:lines() do
    local trimmed = vim.trim(line)
    if trimmed ~= "" and vim.fn.filereadable(trimmed) == 1 then
      table.insert(files, {
        path = trimmed,
        display = trimmed,  -- or use vim.fn.fnamemodify(trimmed, ":t") for filename only
        type = label,
        relative = trimmed,
      })
    end
  end

  f:close()
  return files
end

-- Combine read/write chronicle paths, deduplicated
local function get_all_chronicle_files(prefer_read)
  local paths = get_chronicle_paths()
  local files = {}
  local path_map = {}

  if prefer_read == nil then prefer_read = true end

  local first_source, second_source
  if prefer_read then
    first_source = get_paths_from_file(paths.read, 'read')
    second_source = get_paths_from_file(paths.write, 'write')
  else
    first_source = get_paths_from_file(paths.write, 'write')
    second_source = get_paths_from_file(paths.read, 'read')
  end

  for _, file in ipairs(first_source) do
    path_map[file.relative] = true
    table.insert(files, file)
  end

  for _, file in ipairs(second_source) do
    if not path_map[file.relative] then
      path_map[file.relative] = true
      table.insert(files, file)
    end
  end

  return files
end

-- Common picker logic
local function open_file_picker(files, opts)
  if #files == 0 then
    utils.info('No valid file paths found.')
    return
  end

  local file_list = {}
  for _, file in ipairs(files) do
    table.insert(file_list, file.display)
  end

  opts = opts or {}
  opts.actions = {
    ['default'] = function(selected)
      if selected and #selected > 0 then
        local selected_file = selected[1]
        -- Find the actual file path from our files list
        for _, file in ipairs(files) do
          if file.display == selected_file then
            vim.cmd('edit ' .. vim.fn.fnameescape(file.path))
            break
          end
        end
      end
    end
  }

  fzf.fzf_exec(file_list, opts)
end

-- Main picker (read/write merged)
function M.chronicle_files(opts)
  local files = get_all_chronicle_files(opts and opts.prefer_read)
  local picker_opts = vim.tbl_extend("force", { prompt = "Chronicle... >", previewer = "builtin" }, opts or {})
  open_file_picker(files, picker_opts)
end

-- Read file only
function M.chronicle_read_files(opts)
  local paths = get_chronicle_paths()
  local files = get_paths_from_file(paths.read, 'read')
  local picker_opts = vim.tbl_extend("force", { prompt = "Chronicle read... >", previewer = "builtin" }, opts or {})
  open_file_picker(files, picker_opts)
end

-- Write file only
function M.chronicle_write_files(opts)
  local paths = get_chronicle_paths()
  local files = get_paths_from_file(paths.write, 'write')
  local picker_opts = vim.tbl_extend("force", { prompt = "Chronicle write... >", previewer = "builtin" }, opts or {})
  open_file_picker(files, picker_opts)
end

-- Setup commands and keymaps
function M.setup(opts)
  opts = opts or {}

  vim.api.nvim_create_user_command('ChronicleFiles', function()
    M.chronicle_files()
  end, { desc = 'Open Chronicle files picker (deduplicated, prefer read)' })

  vim.api.nvim_create_user_command('ChronicleReadFiles', function()
    M.chronicle_read_files()
  end, { desc = 'Open Chronicle read file list' })

  vim.api.nvim_create_user_command('ChronicleWriteFiles', function()
    M.chronicle_write_files()
  end, { desc = 'Open Chronicle write file list' })

  local keymap = vim.keymap.set
  keymap('n', '<Space>mm', M.chronicle_files, { desc = 'Chronicle Files (prefer read)' })
  keymap('n', '<Space>mr', M.chronicle_read_files, { desc = 'Chronicle Read Files' })
  keymap('n', '<Space>mw', M.chronicle_write_files, { desc = 'Chronicle Write Files' })
end

return M
