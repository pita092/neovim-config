local luasnip = require('luasnip')
local function fetch_snippets_for_current_filetype()
  -- Get the current filetype from the buffer
  local filetype = vim.bo.filetype
  local snippets = luasnip.get_snippets(filetype) -- Correct way to get snippets for filetype
  local snippet_list = {}

  if snippets then
    for _, snip in ipairs(snippets) do
      table.insert(snippet_list, {
        word = snip.trigger,         -- Use the trigger text as the completion word
        label = snip.trigger,        -- Label is the same as the trigger
        kind = "LuaSnip",
        data = { snip_id = snip.id } -- Additional data like snippet id
      })
    end
  end

  return snippet_list
end


local function fetch()
  local bufnr = vim.api.nvim_get_current_buf()
  local line = vim.fn.line('.') - 1
  local word = vim.fn.expand("<cword>") -- i think this part works\
  local col = vim.fn.col('.') - #word   -- this too               /

  vim.lsp.buf_request(bufnr, 'textDocument/completion', {
    textDocument = { uri = vim.uri_from_bufnr(bufnr) },
    position = { line = line, character = col },
  }, function(_, result)
    local list = {}


    -- Handle LSP completions
    if result and result.items then
      for _, comp in ipairs(result.items) do
        local insert_text = comp.insertText or comp.label
        local sanitized_text = insert_text                      -- chatgpt -\|
        sanitized_text = sanitized_text:gsub("${[^}]*}", "")    -- chatgpt -\|
        sanitized_text = sanitized_text:gsub("$[%d]+", "")      -- chatgpt -\|
        sanitized_text = sanitized_text:gsub("\0", "")          -- chatgpt -\|
        sanitized_text = sanitized_text:gsub("[\128-\255]", "") -- chatgpt -\|
        sanitized_text = sanitized_text:gsub("%c", " ")         -- chatgpt -\|
        sanitized_text = sanitized_text:gsub(",$", "")          -- chatgpt -\|
        -- sanitized_text = sanitized_text:gsub("${[^}]*},", "")   -- chatgpt -\|
        -- sanitized_text = sanitized_text:gsub("$[%d]+", "")      -- chatgpt -\|
        -- sanitized_text = sanitized_text:gsub("\0", "")          -- chatgpt -\|
        -- sanitized_text = sanitized_text:gsub("[\128-\255]", "") -- chatgpt -\|
        -- sanitized_text = sanitized_text:gsub("%c", "")          -- chatgpt -\|

        table.insert(list, { word = sanitized_text, kind = "Lsp" })
      end
    end

    local snippet_list = fetch_snippets_for_current_filetype()
    for _, snippet in ipairs(snippet_list) do
      table.insert(list, snippet)
    end

    -- If there are completion items, show them
    if #list > 0 then
      vim.fn.complete(col, list)
    end
  end)
end
-- just the auto command , (thanks remrevo2048)
vim.api.nvim_create_autocmd("TextChangedI", {
  pattern = "*",
  callback = fetch,
})
vim.cmd [[inoremap <expr> <c-j> ("\<C-n>")
inoremap <expr> <c-k> ("\<C-p>")]]

