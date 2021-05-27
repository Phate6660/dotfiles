-- Helpers
local b = vim.bo     -- Access to buffer-local options
local cmd = vim.cmd  -- To execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- To call Vim functions e.g. fn.bufnr()
local g = vim.g      -- Access to global options (can be non-existant, e.g. a plugin's settings)
local o = vim.o      -- Access to global options (has to exist in base nvim)
local w = vim.wo     -- Access to window-local options

-- Settings
local indent, width = 4, 100
cmd('colorscheme desert')       -- Set the colorscheme
b.expandtab = true              -- Use spaces instead of tabs
b.shiftwidth = indent           -- Size of an indent
b.smartindent = true            -- Insert indents automatically
b.tabstop = indent              -- Number of spaces tabs count for
o.splitbelow = true             -- Put new windows below current
o.splitright = true             -- Put new windows right of current
o.termguicolors = true          -- True color support
w.colorcolumn = tostring(width) -- Line length marker
w.cursorline = true             -- Highlight cursor line
w.number = true                 -- Print line number
w.relativenumber = true         -- Relative line numbers
w.wrap = false                  -- Disable line wrap

cmd('autocmd Filetype css setlocal sw=2 ts=2')  -- 2 space indentation for CSS
cmd('autocmd Filetype html setlocal sw=2 ts=2') -- 2 space indentation for HTML
cmd('autocmd Filetype lua setlocal sw=2 ts=2')  -- 2 space indentation for Lua
cmd('autocmd Filetype xml setlocal sw=2 ts=2')  -- 2 space indentation for XML

-- Package Management
cmd 'packadd paq-nvim'                  -- Load the package manager
local paq = require('paq-nvim').paq     -- A convenient alias
paq {'savq/paq-nvim', opt = true}       -- paq-nvim manages itself
paq {'nvim-treesitter/nvim-treesitter'} -- An awesome parser generator
paq {'nvim-treesitter/playground'}      -- Use this if you don't understand what treesitter does
paq {'neovim/nvim-lspconfig'}           -- Setup builtin lsp in latest nvim
paq {'hrsh7th/nvim-compe'}              -- Completion
paq {'nvim-lua/plenary.nvim'}
paq {'nvim-lua/popup.nvim'}
paq {'nvim-telescope/telescope.nvim'} 
paq {'vim-syntastic/syntastic'}         -- Syntax checking
paq {'rust-lang/rust.vim'}              -- Rust support

-- LSP
local lsp = require 'lspconfig'
lsp.bashls.setup {} -- bash
lsp.rls.setup {} -- rust

-- nvim-compe
local compe = require 'compe'
o.completeopt = 'menuone,noselect'
compe.setup {
  enabled = true;
  autocomplete = true; -- Note: this does NOT mean auto-complete, it means tab-complete
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = true;

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    treesitter = true;
  };
}

-- Syntastic
g.syntastic_always_populate_loc_list = 1
g.syntastic_auto_loc_list = 1
g.syntastic_check_on_open = 1
g.syntastic_check_on_wq = 0

-- Telescope
local telescope = require 'telescope'
telescope.setup {}

-- Treesitter
local ts = require 'nvim-treesitter.configs'
ts.setup {
  ensure_installed = 'maintained',
  highlight = {
      enable = true
  }
}
