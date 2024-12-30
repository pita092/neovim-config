local function create_centered_float_terminal()
  local width = vim.api.nvim_get_option("columns")
  local height = vim.api.nvim_get_option("lines")

  local win_width = math.floor(width * 0.7)
  local win_height = math.floor(height * 0.7)

  local row = math.floor((height - win_height) / 2)
  local col = math.floor((width - win_width) / 2)

  local buf = vim.api.nvim_create_buf(false, true)

  local opts = {
    relative = "editor",
    width = win_width,
    height = win_height,
    row = row - 3,
    col = col,
    style = "minimal",
    border = "shadow"
  }

  local win = vim.api.nvim_open_win(buf, true, opts)

  vim.fn.termopen(vim.o.shell)

  vim.cmd('startinsert')

  -- Set up autocmd to close window on <ESC> and delete buffer
  vim.api.nvim_create_autocmd({ "TermEnter" }, {
    buffer = buf,
    callback = function()
      -- Map <ESC> to exit terminal mode and delete the buffer
      vim.api.nvim_buf_set_keymap(buf, 't', '<ESC>', '<C-\\><C-n>:bd!<CR>', { noremap = true, silent = true })
    end
  })

  return buf, win
end

-- Function to open the centered floating terminal
function OpenCenteredFloatTerminal()
  create_centered_float_terminal()
end

-- Command to open the centered floating terminal
vim.api.nvim_create_user_command('CenteredFloatTerm', OpenCenteredFloatTerminal, {})

-- local state = {
--   floating = {
--     buf = -1,
--     win = -1,
--   }
-- }
--
-- local function Floatterm(opts)
--   opts = opts or {}
--
--   local width = opts.width or math.floor(vim.o.columns * 0.5)
--   local height = opts.width or math.floor(vim.o.lines * 0.5)
--
--   local col = math.floor((vim.o.columns - width) / 2)
--   local row = math.floor((vim.o.lines - height) / 2)
--
--   local buf = nil
--   if vim.api.nvim_buf_is_valid(opts.buf) then
--     buf = opts.buf
--   else
--     buf = vim.api.nvim_create_buf(false, true)
--   end
--
--   local win_conf = {
--     relative = "editor",
--     width = width,
--     height = height,
--     col = col,
--     row = row,
--     style = "minimal",
--     border = "shadow",
--   }
--
--   local win = vim.api.nvim_open_win(buf, true, win_conf)
--
--   return { buf = buf, win = win }
-- end
--
-- vim.api.nvim_create_user_command('CenteredFloatTerm', function()
--   if not vim.api.nvim_win_is_valid(state.floating.win) then
--     state.floating = Floatterm({ buf = state.floating.buf })
--     if vim.bo[state.floating.buf].buftype ~= "terminal" then
--       vim.cmd.term()
--     end
--     vim.cmd.startinsert()
--   else
--     vim.api.nvim_win_hide(state.floating.win)
--   end
-- end, {})
