-- Bootstrap lazy.nvim
vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46_cache/"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = " "


-- Setup lazy.nvim
require("lazy").setup({
  defaults = { lazy = true },

  ui = {
    icons = {
      ft = "ft | ",
      lazy = "Lazy | ",
      loaded = "loaded | ",
      not_loaded = "Not loaded | ",
      cmd = "",
      config = "",
      event = "",
      init = "",
      import = "",
      keys = "",
      plugin = "",
      runtime = "",
      source = "",
      start = "",
      task = "",
      list = {
        "■",
        ">",
        "│",
        "─",
      },
    },
  },

  performance = {
    rtp = {
      -- disabled_plugins = {
      --   "2html_plugin",
      --   "tohtml",
      --   "getscript",
      --   "getscriptPlugin",
      --   "gzip",
      --   { "netrw", "netrwPlugin", "netrwSettings", cmd = "Ex" },
      --   "logipat",
      --   "matchit",
      --   "tar",
      --   "tarPlugin",
      --   "rrhelper",
      --   "spellfile_plugin",
      --   "vimball",
      --   "vimballPlugin",
      --   "zip",
      --   "zipPlugin",
      --   "tutor",
      --   "rplugin",
      --   "syntax",
      --   "synmenu",
      --   "optwin",
      --   "compiler",
      --   "bugreport",
      --   "ftplugin",
      -- },
    },
  },
  spec = {
    { import = "plugin" } },
  install = {
    colorscheme = { "gruvbox" },
  },
})

