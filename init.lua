-----------------------------
-- Basic Settings
-----------------------------
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.g.mapleader = " "

-----------------------------
-- lazy.nvim Bootstrap
-----------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-----------------------------
-- Plugins
-----------------------------
require("lazy").setup({
  -------------------------
  -- File Explorer (Neo-tree)
  -------------------------
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({})
    end,
  },

  -------------------------
  -- Telescope (Fuzzy Finder)
  -------------------------
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local telescope = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", telescope.find_files, {})
      vim.keymap.set("n", "<leader>fg", telescope.live_grep, {})
      vim.keymap.set("n", "<leader>fb", telescope.buffers, {})
      vim.keymap.set("n", "<leader>fh", telescope.help_tags, {})
    end,
  },

  -------------------------
  -- Git Signs (inline diff)
  -------------------------
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },

  -------------------------
  -- Neogit (Git UI)
  -------------------------
  {
    "NeogitOrg/neogit",
    dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
    config = function()
      require("neogit").setup({})
    end,
  },


  -----------------------
  -- lps config 
  -----------------------
{
  "neovim/nvim-lspconfig",
},

{
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "L3MON4D3/LuaSnip",
  },
  config = function()
    local cmp = require("cmp")
    cmp.setup({
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
      mapping = {
        ["<Tab>"] = cmp.mapping.select_next_item(),
        ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
      },
      sources = {
        { name = "nvim_lsp" },
        { name = "buffer" },
        { name = "path" },
      },
    })
  end,
},

  -------------------------
  -- Colorscheme
  -------------------------
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd("colorscheme tokyonight")
    end,
  },
})
-- === MASON + LSP SETUP (paste after your lazy.setup) ===
-- make sure these plugins are present in your lazy.setup plugins table:
-- "williamboman/mason.nvim"
-- "williamboman/mason-lspconfig.nvim"
-- "neovim/nvim-lspconfig"

-- require and configure mason
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "yamlls", "ansiblels" }, -- ensure these are available
  automatic_installation = true,
})

local lspconfig = require("lspconfig")

-- Common on_attach to enable keymaps when LSP attaches
local on_attach = function(client, bufnr)
  local opts = { buffer = bufnr, silent = true }
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
end

-- YAML language server (yaml-language-server)
lspconfig.yamlls.setup({
  on_attach = on_attach,
  settings = {
    yaml = {
      schemaStore = { enable = true }, -- use schemastore for common schema lookup
      validate = true,
      hover = true,
      completion = true,
      schemas = {
        -- optional: explicit mapping for Ansible playbooks (uncomment if you want)
        -- ["https://json.schemastore.org/ansible-stable-2.9.json"] = { "playbook*.yml", "*/tasks/*.yml", "**/playbook.yml" },
      },
    },
  },
})

-- Ansible language server (ansible-ls)
-- Note: ansiblels provides ansible-specific completions/diagnostics
lspconfig.ansiblels.setup({
  on_attach = on_attach,
  settings = {
    ansible = {
      python = "auto", -- let it discover interpreter; set path if needed
    },
  },
})
-----------------------------
-- Keymaps
-----------------------------
-- Open Neo-tree
vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>")

-- Open Neogit
vim.keymap.set("n", "<leader>g", ":Neogit<CR>")

