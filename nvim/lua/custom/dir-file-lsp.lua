local api = vim.api
local buffer = nil
local window = nil

local function get_file_name()
  local file_name = vim.fn.expand("%:t") -- Current file name
  if file_name == "" then
    return "no-file"
  else
    return file_name
  end
end



local M = {}

-- Function to set up custom highlight groups for the floating window
local function set_highlight_groups()
  api.nvim_set_hl(0, "FloatLSPName", { fg = "#b8bb26", bold = true })  -- LSP name color
  api.nvim_set_hl(0, "FloatNoLSP", { fg = "#fb4934", bold = true })    -- No LSP color (red)
  api.nvim_set_hl(0, "FloatFileName", { fg = "#e2d2ab", bold = true }) -- File name color
  api.nvim_set_hl(0, "FloatFolderName", { fg = "#665c54" })            -- Folder name color
  api.nvim_set_hl(0, "FloatBackground", { bg = "#252525" })            -- Background color
end

local function get_lsp_client_name()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if next(clients) ~= nil then
    return "■", "FloatLSPName"
  end
  return "■", "FloatNoLSP"
end


-- Function to create a floating window displaying "name -> folder"
function M.create_floating_window()
  -- Get the current file name and its parent folder
  local file_name = get_file_name()
  local folder_name = vim.fn.expand("%:p:h:t")                -- Parent folder name
  local lsp_name, lsp_highlight_group = get_lsp_client_name() -- Get the LSP client name and highlight group

  local content = {

    string.format(" %s %s %s ", lsp_name, file_name, folder_name),
  }

  -- Get Neovim UI dimensions
  local ui = api.nvim_list_uis()[1]

  -- Define the size and position of the floating window
  local width = vim.fn.strdisplaywidth(content[1]) -- Add padding for aesthetics
  local height = #content                          -- Height based on number of lines

  local opts = {
    relative = 'editor',
    width = width,
    height = height,
    col = ui.width - width, -- Position near the top-right corner
    row = 0,                -- Slight padding from the top
    anchor = 'NW',
    style = 'minimal',
    border = { "", "", "", "", "", "", "", "" },
    focusable = false,
  }

  -- Create a new buffer for the floating window
  buffer = api.nvim_create_buf(false, true) -- [false: listed, true: scratch]

  -- Set the content of the buffer
  api.nvim_buf_set_lines(buffer, 0, -1, false, content)

  -- Apply highlights to specific parts of the line using a namespace
  local ns_id = api.nvim_create_namespace("float_window")

  local lsp_start = string.find(content[1], lsp_name)
  local file_start = string.find(content[1], file_name)
  local folder_start = string.find(content[1], folder_name)

  if lsp_start then
    api.nvim_buf_add_highlight(buffer, ns_id, "FloatLSPName", 0, lsp_start - 1, lsp_start + #lsp_name - 1)
  end

  if lsp_start then
    api.nvim_buf_add_highlight(buffer, ns_id, lsp_highlight_group, 0, lsp_start - 1, lsp_start + #lsp_name - 1)
  end


  if folder_start then
    api.nvim_buf_add_highlight(buffer, ns_id, "FloatFolderName", 0, folder_start - 1, folder_start + #folder_name - 1)
  end

  -- Open the floating window with the specified options
  window = api.nvim_open_win(buffer, false, opts)

  -- Apply background highlights specifically to this window
  api.nvim_win_set_option(window, "winhl", "Normal:FloatBackground")

  -- Make the buffer non-editable and set additional options
  api.nvim_buf_set_option(buffer, "modifiable", false)
end

-- Autocommand to create/update the floating window on buffer enter
api.nvim_create_autocmd({ "BufEnter", "LspAttach" }, {
  callback = function()
    if window and api.nvim_win_is_valid(window) then
      api.nvim_win_close(window, true)
    end
    M.create_floating_window()
  end,
})


-- Set up highlight groups when loading this module
set_highlight_groups()
