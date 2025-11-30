
local fzf_lua = require("fzf-lua")

-- Function to get commands + arguments dynamically
local function get_command_list()
  local commands = vim.api.nvim_get_commands({})
  local choices = {}

  for name, cmd in pairs(commands) do
    local possible_args = vim.fn.getcompletion(name .. " ", "cmdline")

    if #possible_args > 0 then
      for _, arg in ipairs(possible_args) do
        table.insert(choices, name .. " " .. arg)
      end
    elseif cmd.nargs == "0" then
      table.insert(choices, name)
    else
      table.insert(choices, name .. " <args>")
    end
  end
  return choices
end

-- Function to run fzf picker
local function command_picker()
  local choices = get_command_list()

  fzf_lua.fzf_exec(choices, {
    prompt = "Select Command > ",
    actions = {
      ["default"] = function(selected)
        local choice = selected[1] -- Get the selected item
        if not choice then return end

        local cmd_name, cmd_arg = choice:match("^(%S+) (.*)$")

        if cmd_arg and cmd_arg ~= "<args>" then
          vim.cmd(cmd_name .. " " .. cmd_arg) -- Execute with predefined args
        else
          vim.ui.input({ prompt = "Enter arguments for " .. cmd_name .. ": " }, function(args)
            if args then
              vim.cmd(cmd_name .. " " .. args) -- Execute with user input
            end
          end)
        end
      end
    }
  })
end

-- Create :FzfCommands command to run this
vim.api.nvim_create_user_command("FzfCommands", command_picker, {})
