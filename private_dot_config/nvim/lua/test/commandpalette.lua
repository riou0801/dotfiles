
local commands = vim.api.nvim_get_commands({})
local choices = {}

for name, cmd in pairs(commands) do
  local possible_args = vim.fn.getcompletion(name .. " ", "cmdline")

  if #possible_args > 0 then
    -- If arguments exist, add them as choices
    for _, arg in ipairs(possible_args) do
      table.insert(choices, name .. " " .. arg)
    end
  elseif cmd.nargs == "0" then
    table.insert(choices, name) -- No args needed
  else
    table.insert(choices, name .. " <args>") -- Unknown args
  end
end

vim.ui.select(choices, { prompt = "Select a command:" }, function(choice)
  if not choice then return end

  -- Extract command and argument separately
  local cmd_name, cmd_arg = choice:match("^(%S+) (.*)$")

  if cmd_arg and cmd_arg ~= "<args>" then
    vim.cmd(cmd_name .. " " .. cmd_arg)
  else
    vim.ui.input({ prompt = "Enter arguments for " .. cmd_name .. ": " }, function(args)
      if args then
        vim.cmd(cmd_name .. " " .. args)
      end
    end)
  end
end)
