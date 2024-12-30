----opts

local opt    = vim.opt
opt.showmode = false
local o      = vim.o
local g      = vim.g
local s      = vim.schedule

-- s(function()
--   opt.clipboard = "unnamedplus"
-- end)


--Opts
opt.breakindent = true
opt.smartindent = true
opt.autoindent = true
opt.indentexpr = "nvim_treesitter#indent()"
opt.undofile = true
opt.ignorecase = true
opt.smartcase = true
opt.signcolumn = "yes"
opt.updatetime = 50
opt.timeoutlen = 300
opt.splitright = true
opt.splitbelow = true
opt.scrolloff = 10
opt.inccommand = "split"
opt.whichwrap:append("<>[]hl")
opt.hlsearch         = false
opt.incsearch        = true
opt.relativenumber   = true
opt.number           = true
opt.mouse            = "a"
opt.cmdheight        = 1
opt.fillchars        = { eob = " " }
opt.showmode         = false
opt.ls               = 0

--Os
o.showtabline        = 0
o.expandtab          = true
o.termguicolors      = true
o.pumblend           = 4
o.pumheight          = 15
o.winblend           = 4
--Gs
g.have_nerd_font     = false
g.cursorword_enabled = false
g.netrw_browse_split = 0
g.netrw_banner       = 0
g.netrw_winsize      = 25

--too lazy to switch from vim.cmd
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

--neovide

if g.neovide then
  g.neovide_padding_top = 0
  g.neovide_padding_bottom = 0
  g.neovide_padding_right = 0
  g.neovide_padding_left = 0
  g.neovide_confirm_quit = true
end


--idont remember what this dose
--i remember
--if i am in windows it sets mason to path
local is_windows = vim.fn.has("win32") ~= 0
local sep = is_windows and "\\" or "/"
local delim = is_windows and ";" or ":"
vim.env.PATH = table.concat({ vim.fn.stdpath("data"), "mason", "bin" }, sep) .. delim .. vim.env.PATH



----auto cmds

local autocmd = vim.api.nvim_create_autocmd

autocmd("ModeChanged", {
  pattern = "*",
  callback = function()
    local mode = vim.fn.mode()
    if mode == "v" or mode == "V" or mode == "\22" then
      vim.cmd("highlight Visual guibg=#83a598 guifg=#282828")
    else
      vim.cmd("highlight Visual guibg=#282828 guifg=#fbf1c7")
    end
  end
})


autocmd({ "UIEnter", "BufReadPost", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("FilePost", { clear = true }),
  callback = function(args)
    local file = vim.api.nvim_buf_get_name(args.buf)
    local buftype = vim.api.nvim_get_option_value("buftype", { buf = args.buf })

    if not vim.g.ui_entered and args.event == "UIEnter" then
      vim.g.ui_entered = true
    end

    if file ~= "" and buftype ~= "nofile" and vim.g.ui_entered then
      vim.api.nvim_exec_autocmds("User", { pattern = "FilePost", modeline = false })
      vim.api.nvim_del_augroup_by_name("FilePost")

      vim.schedule(function()
        vim.api.nvim_exec_autocmds("FileType", {})

        if vim.g.editorconfig then
          require("editorconfig").config(args.buf)
        end
      end)
    end
  end,
})


vim.defer_fn(function()
  vim.cmd([[
    highlight SignColumn guibg=NONE ctermbg=NONE
    ]])
end, 100)
---custom commands



vim.api.nvim_create_user_command("LintInfo", function()
  local lint = require("lint")
  local filetype = vim.bo.filetype
  local linters = lint.linters_by_ft[filetype] or {}

  local info = "Linters for " .. filetype .. ":\n"
  if #linters > 0 then
    for _, linter in ipairs(linters) do
      info = info .. "- " .. linter .. "\n"
    end
  else
    info = info .. "No linters configured."
  end

  vim.api.nvim_echo({ { info, "Normal" } }, false, {})
end, {})

--just stright up stole this from kickstart.nvim
-- vim.api.nvim_create_autocmd("TextYankPost", {
--   desc = "Highlight when yanking (copying) text",
--   group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
--   callback = function()
--     vim.highlight.on_yank()
--   end,
-- })

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank({
      higroup = "Accent", -- Replace with your desired highlight group
      timeout = 200
    })
  end,
})

-- vim.api.nvim_create_autocmd("BufWritePre", {
-- 	pattern = "*",
-- 	callback = function(args)
-- 		require("conform").format({ bufnr = args.buf })
-- 	end,
-- })

vim.api.nvim_create_autocmd('FileType', {
  callback = function()
    vim.api.nvim_create_autocmd('BufWritePre', {
      pattern = '<buffer>',
      callback = function()
        local curpos = vim.api.nvim_win_get_cursor(0)
        vim.cmd([[keeppatterns %s/\s\+$//e]])
        vim.api.nvim_win_set_cursor(0, curpos)
      end,
    })
  end,
})
vim.api.nvim_create_autocmd('FileType', {
  callback = function()
    vim.api.nvim_create_autocmd('BufWritePre', {
      pattern = '<buffer>',
      callback = function()
        local curpos = vim.api.nvim_win_get_cursor(0)
        vim.cmd([[keeppatterns %s/\s\+$//e]])
        vim.api.nvim_win_set_cursor(0, curpos)
      end,
    })
  end,
})

vim.api.nvim_create_autocmd({ "InsertEnter" }, {
  callback = function()
    vim.o.cursorline    = true
    vim.o.cursorlineopt = "both"
    vim.opt.colorcolumn = "80"
  end
})

----mapings


local map = vim.keymap.set

vim.api.nvim_set_keymap('i', '<S-Tab>', [[<Cmd>lua require("luasnip").expand_or_jump()<CR>]], { noremap = true, silent = true })
--stuff
map('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
map('t', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
map('t', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
map('t', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
map('t', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
map('t', '<Esc>', [[<C-\><C-n>]])
map('n', '<leader>nt', '<CMD>CenteredFloatTerm<CR>')
map('t', '<leader>t', '<CMD>CenteredFloatTerm<CR>')


--custom netrw mappings
--
vim.api.nvim_create_autocmd("FileType", {
  pattern = "netrw",
  callback = function()
    vim.api.nvim_buf_set_keymap(0, 'n', '<C-q>', '<CMD>q!<CR>', { noremap = true, silent = true })
  end
})


--mini stuff
-- map("n", "<leader>o", "<cmd>Pick grep_live<CR>", { silent = true, desc = "Grep Live" })
-- map("n", "<leader>bb", "<cmd>Pick buffers<CR>", { silent = true, desc = "Buffer Buffers" })
-- map("n", "<leader>ff", "<cmd>Pick files<CR>", { silent = true, desc = "Find Files" })
-- map("n", "<leader>cd", "<cmd>Pick files<CR>", { silent = true, desc = "Find Files" })
-- map("n", "<leader>ht", "<cmd>Pick help<CR>", { silent = true, desc = "Help Tags" })
-- map("n", "<leader>gb", "<cmd>Pick git_branches <CR>", { silent = true, desc = "Help Tags" })
-- map("n", "<leader>gc", "<cmd>Pick git_commits<CR>", { silent = true, desc = "Git Commits" })
-- map("n", "<leader>gf", "<cmd>Pick git_files<CR>", { silent = true, desc = "Git Files" })
-- map("n","<leader>xx", "<cmd>Pick diagnostic<CR>", { silent = true, desc = "LSP Diagnostic" })

--normal vim stuff
map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '>-2<CR>gv=gv", { silent = true })
map("n", "<C-d>", "zz")
-- Copy to system clipboard
map('v', 'gy', '"+y', { noremap = true, silent = true })
map('n', 'gy', '"+yy', { noremap = true, silent = true })



map("n", "<leader>tr", "<cmd>let netrw_liststyle=3 | Lex!<CR>", { silent = true })
map("n", "<leader>ex", "<cmd>let netrw_liststyle=0 | Ex<CR>", { silent = true })
map("n", "<Esc>", "<cmd>noh<CR>", { desc = "General Clear highlights" })
map("n", "<leader>ds", vim.diagnostic.setloclist)
map("n", "<leader>gd", vim.lsp.buf.definition, { buffer = 0 })
map("n", "K", vim.lsp.buf.hover, { buffer = 0 })
map("n", "<leader>ca", vim.lsp.buf.code_action, { buffer = 0 })
map("n", "<leader>rn", vim.lsp.buf.rename)

----lsp stuff

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc)
      vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    end

    vim.keymap.set("n", "<leader>th", function()
      vim.lsp.inlay_hint(0, nil)
    end, { desc = "Toggle Inlay Hints" })

    -- require("clangd_extensions.inlay_hints").setup_autocmd()
    -- require("clangd_extensions.inlay_hints").set_inlay_hints()
    map("gr", vim.lsp.buf.references, "[G]oto [R]eferences ")
    map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
    map("<leader>bf", vim.lsp.buf.format, "[F]ormat [B]uffer")



    map("gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
    map("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
    map("<leader>w", vim.lsp.buf.rename, "[R]e[n]ame")
    map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
    map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
      local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd("LspDetach", {
        group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds({ group = "lsp-highlight", buffer = event2.buf })
        end,
      })
    end
  end,
})

vim.diagnostic.config({
  virtual_text = true,
  underline = true,
  update_in_insert = false,
  severity_sort = false,
  signs = {

    text = {
      [vim.diagnostic.severity.ERROR] = 'E',
      [vim.diagnostic.severity.WARN] = 'W',
      [vim.diagnostic.severity.HINT] = 'H',
      [vim.diagnostic.severity.INFO] = 'I',
    },

  },
})
-- local signs = { Error = "E ", Warn = "W ", Hint = "H ", Info = "i " }
-- for type, icon in pairs(signs) do
--   local hl = "DiagnosticSign" .. type
--   vim.fn.sign_define(hl, { text = icon, texthl = hl })
-- end


vim.diagnostic.config({
  virtual_text = {
    source = "always", -- Or "if_many"
  },
  float = {
    source = "always", -- Or "if_many"
  },
})

local lspconfig = require("lspconfig")
-- local capabilities = require('cmp_nvim_lsp').default_capabilities()


lspconfig.lua_ls.setup({
  -- capabilities = capabilities,
  diagnostics = { globals = { "vim", "bit", "jit", "utf8" } },
  root_dir = vim.fs.dirname(vim.fs.find({ ".luarc.json", ".git" }, { upward = true })[1]),
  Lua = {
    workspace = { checkThridParty = false },
    telemtry = { enable = false },
    hint = { enable = true },
  }
})

lspconfig.clangd.setup({
  -- capabilities = capabilities,
  cmd = {
    "clangd",
    "--background-index",
    "-j=12",
    "--query-driver=/usr/bin/**/clang-*,/bin/clang,/bin/clang++,/usr/bin/gcc,/usr/bin/g++",
    "--clang-tidy",
    "--clang-tidy-checks=*",
    "--all-scopes-completion",
    "--cross-file-rename",
    "--completion-style=detailed",
    "--header-insertion-decorators",
    "--header-insertion=iwyu",
    "--pch-storage=memory",
  },
})
--
-- --
-- lspconfig.csharp_ls.setup(coq.lsp_ensure_capabilities{ })
-- lspconfig.gopls.setup(coq.lsp_ensure_capabilities{  })
-- lspconfig.hls.setup(coq.lsp_ensure_capabilities{ })
-- lspconfig.nixd.setup(coq.lsp_ensure_capabilities{ })
-- lspconfig.zls.setup(coq.lsp_ensure_capabilities{ })


-- lspconfig.csharp_ls.setup({ capabilities = capabilities, })
-- lspconfig.gopls.setup({ capabilities = capabilities, })
-- lspconfig.hls.setup({ capabilities = capabilities, })
-- lspconfig.nixd.setup({ capabilities = capabilities, })
-- lspconfig.zls.setup({ capabilities = capabilities, })

lspconfig.csharp_ls.setup({})
lspconfig.gopls.setup({})
lspconfig.hls.setup({})
lspconfig.nixd.setup({})
lspconfig.zls.setup({})




--formating

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'nix',
  callback = function()
    vim.keymap.set("n", "<C-f>", "<CMD>silent !nixfmt %<CR>", { silent = true })
  end,
})



local lspconfig = require('lspconfig')

lspconfig.pyright.setup {
  on_attach = function(client, bufnr)
    -- Enable completion triggered by <C-Space>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Set up key mappings for LSP functions
    local opts = { noremap = true, silent = true }
    vim.api.nvim_buf_set_keymap(bufnr, 'i', '<C-Space>', 'v:lua.vim.lsp.omnifunc', opts)
  end,
}


vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
