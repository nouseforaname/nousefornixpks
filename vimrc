set clipboard=unnamedplus

" https://vonheikemen.github.io/devlog/tools/setup-nvim-lspconfig-plus-nvim-cmp/
" RUBY SETUP 
lua << EOF
  local nvim_lsp = require('lspconfig')
  local lsp_defaults = nvim_lsp.util.default_config
  lsp_defaults.capabilities = vim.tbl_deep_extend(
    'force',
    lsp_defaults.capabilities,
    require('cmp_nvim_lsp').default_capabilities()
  )
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

  nvim_lsp.solargraph.setup({
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
    settings = {
      filetypes = {"ruby"};
      capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities()),
      cmd = {"bundle", "exec", "solargraph", "stdio"},
      solargraph = {
        useBundler = true,
        diagnostics = true,
        completion = true
      }
    }
  })
EOF

" ENABLE AUTOCOMPLETION


" ff for file search
nnoremap ff :Files<CR>
nnoremap fs :Rg<CR>


" GENERAL SETTINGS
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


" LanguageClient Go ruby was super slow
let g:LanguageClient_autoStart = 1
let g:LanguageClient_autoStop = 0
let g:LanguageClient_hasSnippetSupport = 1
let g:LanguageClient_loadSettings = 1

let g:LanguageClient_serverCommands = {
  \ 'go': ['gopls'],
\ }

" GOLANG

" KEY BINDINGS
autocmd FileType go nmap <leader>d  <Plug>(go-def)
autocmd FileType go nmap <leader>D  <Plug>(go-def-pop)
autocmd FileType go nmap <F9> :GoDebugStart<CR>
autocmd FileType go nmap <F10> :GoDebugTest<CR>
autocmd FileType go nmap <F11> :GoDebugStop<CR>
autocmd FileType go nmap <F6> :GoDebugBreakpoint<CR>

autocmd FileType go nmap gr  :GoReferrers<CR>

" autoimports
let g:go_fmt_command = "goimports"

" Run gofmt on save
autocmd BufWritePre *.go :call LanguageClient#textDocument_formatting_sync()

" Linting
let g:go_metalinter_enabled = ['vet', 'golint', 'errcheck','revive','staticcheck','unused','varcheck']
let g:go_metalinter_autosave = 1

" show type info
let g:go_auto_type_info = 1
" highlighting

let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_build_constraints = 1

" auto suggestions / completion

let g:deoplete#enable_at_startup = 1
call deoplete#custom#option('omni_patterns', { 'go': '[^. *\t]\.\w*', 'ruby': '[^. *\t]\.\h\w*\|\h\w*::'})

