-- general formating
vim.cmd [[set encoding=UTF-8]] -- codificação de caracteres para UTF-8
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ruler = true -- é o indicador do número da linha e coluna
vim.opt.cursorline = true -- destaca a linha atual
vim.opt.showmatch = true -- mostra parênteses, chaves ou colchetes correspondentes

vim.opt.linebreak = true -- quebra de linha em certa quantidade de caracteres
vim.opt.wrap = true -- quebra de linha
vim.bo.textwidth = 120 -- largura máxima da linha em caracteres

vim.opt.hlsearch = true
vim.opt.incsearch = true -- busca incremental, ou seja, conforme digitamos o texto vai sendo destacado
vim.opt.smartcase = true -- ignora case se não tiver maiúscula
vim.opt.expandtab = true -- expande tab para espaços
vim.opt.ignorecase = true -- torna a busca case insensitive

vim.opt.autoindent = true
vim.opt.smartindent = true -- identação inteligente
vim.opt.smarttab = true -- identação inteligente
vim.bo.shiftwidth = 2 -- número de espaços para identação
vim.bo.softtabstop = 2 
vim.bo.tabstop = 2

require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  -- colorscheme
  use 'folke/tokyonight.nvim'
  -- statusbar
  use 'ryanoasis/vim-devicons'
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'ryanoasis/vim-devicons', opt = true }
  }
  -- lsp
  use 'neovim/nvim-lspconfig'
  use "williamboman/mason.nvim"
  use "williamboman/mason-lspconfig.nvim"

  -- autocompletion 
  use {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'hrsh7th/nvim-cmp',
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
    'rafamadriz/friendly-snippets',
    'ray-x/lsp_signature.nvim'
  }
  -- copilot
  use 'github/copilot.vim'
  -- telescope
  use "nvim-lua/plenary.nvim"
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.1',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
  -- treesitter
  use 'nvim-treesitter/nvim-treesitter'


end)
-- colorscheme
vim.cmd [[colorscheme tokyonight-moon]]

-- statusbar
require('lualine').setup {
  options = {
    theme = 'tokyonight'
  }
}

-- telescope
require('telescope').setup()

-- lsp
local nvim_lsp = require('lspconfig')
require('mason').setup()
require('mason-lspconfig').setup({
  automatic_installation = true
})

local on_attach = function(_, _)
  vim.keymap.set('n', '<leader>gr', require('telescope.builtin').lsp_references(), {})
  require "lsp_signature".on_attach()
end
local capabilities = require('cmp_nvim_lsp').default_capabilities()

nvim_lsp.tsserver.setup{
  on_attach = on_attach,
  capabilities = capabilities
}
nvim_lsp.angularls.setup{
  on_attach = on_attach,
  capabilities = capabilities
}

-- autocompletion
local cmp = require'cmp'

require('luasnip.loaders.from_vscode').load()

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
  })
})

cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'git' },
  }, {
    { name = 'buffer' },
  })
})

cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- treesitter
require('nvim-treesitter.configs').setup({
  highlight = {
    enable = true,
  }
})

-- keybindings
-- leader
vim.g.mapleader = ','
-- telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
-- lsp
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})
