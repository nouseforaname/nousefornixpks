" GENERAL SETTINGS
set clipboard=unnamedplus
set paste
set tabstop=2
set expandtab
set shiftwidth=2
set mouse=
set noautoindent
set nocindent
set nosmartindent
set nu
colorscheme koehler
hi CursorLineNr guibg=#ff0000 ctermbg=red
set cursorline
set cursorlineopt=number


" ff for file search
nnoremap ff :Files<CR>
" rigpgrep alias
nnoremap fs :Rg<CR>

" run ShellCheck on save
augroup sh_autocmd
  autocmd!
  au BufWrite *.sh ShellCheck
  autocmd QuickFixCmdPost [^l]* nested cwindow
  autocmd QuickFixCmdPost    l* nested lwindow
augroup END

" au! BufRead,BufNewFile *.json set filetype=json
" augroup json_autocmd
"   autocmd!
"   autocmd FileType json set autoindent
"   autocmd FileType json set formatoptions=tcq2l
"   autocmd FileType json set textwidth=78 shiftwidth=2
"   autocmd FileType json set softtabstop=2 tabstop=8
"   autocmd FileType json set expandtab
"   autocmd FileType json set foldmethod=syntax
" augroup END

" https://vonheikemen.github.io/devlog/tools/setup-nvim-lspconfig-plus-nvim-cmp/
" RUBY SETUP 

lua << EOF

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

-- empty setup using defaults
require("nvim-tree").setup()

-- OR setup with some options
require("nvim-tree").setup({
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})

local lspconfig = require'lspconfig'
local lsp_defaults = lspconfig.util.default_config

lsp_defaults.capabilities = vim.tbl_deep_extend(
  'force',
  lsp_defaults.capabilities,
  require('cmp_nvim_lsp').default_capabilities()
)
local cmp = require 'cmp'
local select_opts = {behavior = cmp.SelectBehavior.Select}
vim.opt.completeopt = {'menu', 'menuone', 'noselect'}
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
    end,
  },
 	view = {
 		entries = "native",
 	},
  mapping = {
    ['<CR>'] = cmp.mapping(cmp.mapping.confirm({ select = true }), { "i", "s", "c" }),
    ['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item(select_opts), { "i", "s", "c" }),
    ['<Down>'] = cmp.mapping(cmp.mapping.select_next_item(select_opts), { "i", "s", "c" }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      local col = vim.fn.col('.') - 1
      if cmp.visible() then
        cmp.select_next_item(select_opts)
      elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        fallback()
      else
        cmp.complete()
      end
    end, {'i', 's', 'c'}),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item(select_opts)
      else
        fallback()
      end
    end, {'i', 's', 'c'}),
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  formatting = {
    fields = {'menu', 'abbr', 'kind'},
    format = function(entry, item)
      local menu_icon = {
        nvim_lsp = 'λ',
        luasnip = '⋗',
        buffer = 'Ω',
        path = '🖫',
      }
      item.menu = menu_icon[entry.source.name]
      return item
    end,
  },
  sources = cmp.config.sources({
    {name = 'path'},
    {name = 'nvim_lsp', keyword_length = 1},
    {name = 'fuzzy_buffer', keyword_length = 3},
  }),
})


-- SETUP LSPs
lspconfig.cmake.setup({})

lspconfig.clangd.setup({
    on_attach=lsp_keybindings,
    capabilities = capabilites,
    filetypes = { 'arduino', 'ino', 'c', 'cpp', 'c++', 'h' },
    cmd = { 'clangd', '--query-driver=/nix/store/*/bin/xtensa-lx106-elf-*', '--clang-tidy', '--background-index' } 
})

lspconfig.nil_ls.setup({
  autostart = true,
  capabilities = caps,
  cmd = { 'nil' },
  settings = {
    ['nil'] = {
      formatting = {
        command = { "nixpkgs-fmt" },
      },
    },
  },
})
lspconfig.wgsl_analyzer.setup({})

lspconfig.rust_analyzer.setup({
  cmd = {'rust-analyzer'};
  filetypes={ 'rust' };
  settings = {
    ['rust-analyzer'] = {
      diagnostics = {
        enable = true;
      },
      checkOnSave = true,
      imports = {
        granularity = { group = "module" },
      },
    }
  }
})

lspconfig.gopls.setup({
  cmd = {'gopls'},
  filetypes = {"go"};
  settings = {
    gopls = {
      gofumpt = true,
      codelenses = {
        gc_details = false,
        generate = true,
        regenerate_cgo = true,
        run_govulncheck = true,
        test = true,
        tidy = true,
      },
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
      analyses = {
        nilness = true,
        unusedparams = true,
        unusedwrite = true,
        useany = true,
        shadow = true,
      },
      usePlaceholders = true,
      completeUnimported = true,
      staticcheck = true,
      directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
      semanticTokens = true,
    },
  },
})

lspconfig.solargraph.setup({
  flags = {
    debounce_text_changes = 150,
  },
  cmd = { "solargraph", "stdio" },
  filetypes = {"ruby", "rakefile"};
  settings = {
    solargraph = {
      useBundler = true,
      autoformat = true,
      completion = true,
      diagnostic = true,
      folding = true,
      references = true,
      rename = true,
      symbols = true
    }
  }
})
-- SETUP LSPs END

-- FORMAT ON SAVE
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.rs",
  callback = function()
    vim.lsp.buf.format()
  end,
})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.rb",
  callback = function()
    vim.lsp.buf.format()
  end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = {"*.go"},
  callback = function()
    vim.lsp.buf.format()
    vim.lsp.buf.code_action({ 
      context = { only = { 'source.organizeImports' } },
      apply = true
    }) 
  end
})
-- FORMAT ON SAVE END
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function()
    local bufmap = function(mode, lhs, rhs)
      local opts = {buffer = true}
      vim.keymap.set(mode, lhs, rhs, opts)
    end
    bufmap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')
    -- Jump to the definition
    bufmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')
    -- Jump to declaration
    bufmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')
    -- Lists all the implementations for the symbol under the cursor
    bufmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')
    -- Jumps to the definition of the type symbol
    bufmap('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>')
    -- Lists all the references 
    bufmap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')
    -- Displays a function's signature information
    bufmap('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>')
    -- Renames all references to the symbol under the cursor
    bufmap('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>')
    -- Selects a code action available at the current cursor position
    bufmap('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>')
    bufmap('x', '<F4>', '<cmd>lua vim.lsp.buf.range_code_action()<cr>')
    -- Show diagnostics in a floating window
    bufmap('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')
    -- Move to the previous diagnostic
    bufmap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
    -- Move to the next diagnostic
    bufmap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')
  end

})
EOF

