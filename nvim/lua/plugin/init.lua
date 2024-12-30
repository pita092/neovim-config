return {
  -- {
  --   "iguanacucumber/magazine.nvim",
  --   event = "InsertEnter",
  --   name = "nvim-cmp",
  --   dependencies = {
  --     { "hrsh7th/cmp-nvim-lsp" },
  --     { "hrsh7th/cmp-nvim-lua" },
  --     { "hrsh7th/cmp-buffer" },
  --     { "lukas-reineke/cmp-under-comparator" },
  --     {
  --       "L3MON4D3/LuaSnip",
  --       dependencies = { "rafamadriz/friendly-snippets", "saadparwaiz1/cmp_luasnip" },
  --       config = function()
  --         return require("luasnip.loaders.from_vscode").lazy_load()
  --       end,
  --     },
  --   },
  --   config = function()
  --     return require("plugin.plugin_opts.cmp")
  --   end,
  -- },
  {
    {
      "nvim-treesitter/nvim-treesitter",
      event = "VeryLazy",
      build = ":TSUpdate",
      config = function()
        require 'nvim-treesitter.configs'.setup {
          sync_install = true,
          auto_install = true,
          ensure_installed = { "c", "lua" },
          highlight = { enable = true, disable = {} },
          indent = { enable = true, disable = {} },
          incremental_selection = {
            enable = true,
          },
          keymaps = {
            init_selection = "<leader>qq",
          },
        }
      end
    }
  },
  {
    'neovim/nvim-lspconfig',
    event = "VeryLazy",
  },

  {
    "pita092/statusline.nvim",
    event = "VeryLazy",
    config = function()
      require('statusline').setup({
        pos = "down",
        colors = "gruvbox",
        padding = 23,
        separator = {
          enabled = false,
          separator = "|",
        },
        git = {
          enabled = true,
          icon = "|\\",
        },
        filename = {
          enabled = false
        }
      })
    end
  },
  {
    'brenoprata10/nvim-highlight-colors',
    event = { "BufReadPost" },
    opts = {},
  },
  {
    "L3MON4D3/LuaSnip",
    lazy = false,
    version = "v2.*",
    build = "make install_jsregexp",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end
  },
  {
    "OXY2DEV/markview.nvim",
    lazy = false,

    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons"
    },
    opts = {
          highlight_groups = "dark",
    }
  }
}
