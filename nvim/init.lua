-- Set leader key first
vim.g.mapleader = " "

-- Basic keymaps
vim.keymap.set('n', '<leader>q', ':quit<CR>', {desc = 'Quit'})
vim.keymap.set('n', '<leader>w', ':write<CR>', {desc = 'Write'})
vim.keymap.set('n', '<leader>o', ':update<CR> :source<CR>', {desc = 'Update and source'})

-- Better window navigation
vim.keymap.set('n', '<C-h>', '<C-w>h', {desc = 'Move to left window'})
vim.keymap.set('n', '<C-j>', '<C-w>j', {desc = 'Move to bottom window'})
vim.keymap.set('n', '<C-k>', '<C-w>k', {desc = 'Move to top window'})
vim.keymap.set('n', '<C-l>', '<C-w>l', {desc = 'Move to right window'})

-- Better indenting
vim.keymap.set('v', '<', '<gv', {desc = 'Indent left'})
vim.keymap.set('v', '>', '>gv', {desc = 'Indent right'})

-- Move lines up/down
vim.keymap.set('n', '<A-j>', ':m .+1<CR>==', {desc = 'Move line down'})
vim.keymap.set('n', '<A-k>', ':m .-2<CR>==', {desc = 'Move line up'})
vim.keymap.set('v', '<A-j>', ':m \'>+1<CR>gv=gv', {desc = 'Move selection down'})
vim.keymap.set('v', '<A-k>', ':m \'<-2<CR>gv=gv', {desc = 'Move selection up'})

-- Options
vim.o.swapfile = false
vim.o.tabstop = 4
vim.o.wrap = false
vim.o.relativenumber = true
vim.o.number = true
vim.o.undofile = true              -- Persistent undo
vim.o.ignorecase = true            -- Ignore case in search
vim.o.smartcase = true             -- Override ignorecase if uppercase used
vim.o.splitbelow = true            -- Force all horizontal splits below
vim.o.splitright = true            -- Force all vertical splits to the right
vim.o.termguicolors = true         -- Enable 24-bit colors
vim.o.timeoutlen = 300             -- Faster key sequence timeout
vim.o.updatetime = 250             -- Faster completion
vim.o.scrolloff = 8                -- Lines to keep above/below cursor
vim.o.sidescrolloff = 8            -- Lines to keep left/right of cursor

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Setup plugins
require("lazy").setup({
  -- Colorscheme
  { 
    "vague2k/vague.nvim",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme('vague')
      vim.cmd(":hi statusline guibg=NONE")
    end
  },

  -- File explorer
  { 
    "stevearc/oil.nvim",
    config = function()
      require("oil").setup()
      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
    end
  },

  -- Fuzzy finder
  { 
    "echasnovski/mini.pick",
    config = function()
      require('mini.pick').setup()
      vim.keymap.set('n', '<leader>ff', function() require('mini.pick').builtin.files() end, {desc = 'Find files'})
      vim.keymap.set('n', '<leader>fg', function() require('mini.pick').builtin.grep_live() end, {desc = 'Live grep'})
      vim.keymap.set('n', '<leader>fb', function() require('mini.pick').builtin.buffers() end, {desc = 'Find buffers'})
    end
  },

  -- Treesitter
  { 
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "vim", "vimdoc", "markdown", "json", "yaml" },
        highlight = {
          enable = true,
        },
        indent = {
          enable = true,
        },
      })
    end,
  },

  -- LSP Configuration
  { 
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require('lspconfig')
      
      -- Configure common LSP servers
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            diagnostics = { globals = {'vim'} }
          }
        }
      })
      
      -- Add keymaps for LSP functions
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {desc = 'Go to definition'})
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, {desc = 'Show hover'})
      vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, {desc = 'Rename'})
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {desc = 'Code action'})
      vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, {desc = 'Show diagnostics'})
    end
  },

  -- Auto-completion
  { 
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require('cmp')
      cmp.setup({
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-d>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping.select_next_item(),
          ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        }, {
          { name = 'buffer' },
          { name = 'path' },
        })
      })
    end
  },

  -- Status line
  { 
    "nvim-lualine/lualine.nvim",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup({
        options = { 
          theme = 'auto',
          globalstatus = true,
        }
      })
    end
  },

  -- Git integration
  { 
    "lewis6991/gitsigns.nvim",
    config = function()
      require('gitsigns').setup({
        signs = {
          add = { text = '+' },
          change = { text = '~' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
        }
      })
    end
  },

  -- Enhanced search and replace
  { 
    "nvim-pack/nvim-spectre",
    config = function()
      vim.keymap.set('n', '<leader>S', '<cmd>lua require("spectre").toggle()<CR>', {desc = "Toggle Spectre"})
      vim.keymap.set('n', '<leader>sw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {desc = "Search current word"})
    end
  },

  -- Typst preview
  { "chomosuke/typst-preview.nvim" },

  -- Web devicons (for file icons)
  { "nvim-tree/nvim-web-devicons" },
})


