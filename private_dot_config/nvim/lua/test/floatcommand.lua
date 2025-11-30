
local function create_floating_window()
  local buf = vim.api.nvim_create_buf(false, true) -- Create a scratch buffer
  local width = math.floor(vim.o.columns * 0.6)
  local height = math.floor(vim.o.lines * 0.6)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded"
  })

  return buf, win
end

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

local function fuzzy_select_command()
  local choices = get_command_list()
  if #choices == 0 then return end

  local buf, win = create_floating_window()
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, choices)
  vim.api.nvim_win_set_option(win, "cursorline", true) -- Highlight current selection

  local function execute_command(selected_line)
    vim.api.nvim_win_close(win, true) -- Close the floating window

    local choice = choices[selected_line + 1]
    if not choice then return end

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
  end

  -- Keybindings inside floating window
  vim.api.nvim_buf_set_keymap(buf, "n", "<CR>", "<Cmd>lua execute_command(vim.fn.line('.'))<CR>", { noremap = true, silent = true })
  vim.api.nvim_buf_set_keymap(buf, "n", "q", "<Cmd>lua vim.api.nvim_win_close(" .. win .. ", true)<CR>", { noremap = true, silent = true })
end

-- Create :FloatingCommands command
vim.api.nvim_create_user_command("FloatingCommands", fuzzy_select_command, {})

