" Vim Plug
call plug#begin()
	Plug 'neoclide/coc.nvim', {'branch': 'release'}
	Plug 'itchyny/lightline.vim'
	Plug 'ryanoasis/vim-devicons'
	Plug 'junegunn/limelight.vim'
	Plug 'junegunn/goyo.vim'
	Plug 'preservim/nerdtree'
	Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
	Plug 'junegunn/fzf.vim'
	Plug 'drewtempelmeyer/palenight.vim'
	Plug 'sheerun/vim-polyglot'
call plug#end()

" Configuração geral
let mapleader = ","
set encoding=utf-8
set number relativenumber

set textwidth=140
set showmatch
set visualbell

set hlsearch
set smartcase
set ignorecase
set incsearch

set smartindent
set smarttab
set softtabstop=2
set tabstop=2
set shiftwidth=2

set ruler
set cursorline

" Configuração do tema
syntax on
set background=dark
colorscheme palenight
let g:palenight_terminal_italics=1

if (has("nvim"))
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
endif

if (has("termguicolors"))
  set termguicolors
endif


" Configuração de plugins

" Lighline
let g:lightline = {
      \ 'colorscheme': 'palenight',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }

" NERDTree
nnoremap <leader>n :NERDTreeFocus<CR>
nnoremap <C-n> :NERDTreeToggle<CR>
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'

" FZF
nnoremap <C-p> :FZF<CR>
let g:fzf_preview_window = ['right:50%', 'ctrl-/']

" Goyo
nnoremap <C-g> :Goyo<CR>
let g:goyo_width = '85%'
let g:goyo_height = '95%'

" Limelight
let g:limelight_conceal_ctermfg = 'gray'
let g:limelight_conceal_ctermfg = 240
let g:limelight_conceal_guifg = 'DarkGray'
let g:limelight_conceal_guifg = '#777777'
let g:limelight_default_coefficient = 0.7
let g:limelight_paragraph_span = 1
let g:limelight_bop = '^\s'
let g:limelight_eop = '\ze\n^\s'
let g:limelight_priority = -1

autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!

" COC Vim
set encoding=utf-8

set hidden

set nobackup
set nowritebackup

set cmdheight=2

set updatetime=300

set shortmess+=c

if has("patch-8.1.1564")
  set signcolumn=number
else
  set signcolumn=yes
endif

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

autocmd CursorHold * silent call CocActionAsync('highlight')

nmap <leader>rn <Plug>(coc-rename)

xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

nmap <leader>ac  <Plug>(coc-codeaction)
nmap <leader>qf  <Plug>(coc-fix-current)

xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

command! -nargs=0 Format :call CocAction('format')
command! -nargs=? Fold :call     CocAction('fold', <f-args>)
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

let g:coc_global_extensions = ['coc-json', 'coc-git', 'coc-angular', 'coc-browser', 'coc-clangd', 'coc-css', 'coc-cssmodules', 'coc-eslint', 'coc-explorer', 'coc-flutter', 'coc-fzf-preview', 'coc-gist', 'coc-graphql', 'coc-html', 'coc-htmlhint', 'coc-html-css-support', 'coc-stylelint', 'coc-sql', 'coc-svg', 'coc-tailwindcss', 'coc-tsserver', 'coc-vetur', 'coc-xml', 'coc-yaml']





#include <stdio.h>
#include <stdlib.h>

#define QTDMAXPROJETOS 5

struct tp_projetos {
  int codigo;
  char titulo[70];
  char descricao[140];
  int ano;
  int status;
  char repsonsavel[50];
  char dataInicio[10];
  char dataFim[10];
  int tpEmpreendimento;
} tpprojetos;

// Declaração de funções
cadastrarProjeto(int codigo);
mostrarTipoImpressao();
mostrarStatus();
statusProjeto(int opcaoStatus);
tipoEmpreendimento(int tipoEmpreendimento);
menuPrincipal(int opcaoMenu);
menuImpressao(int opcaoImpressao)


int main() {

  int opcaoMenu;
  int executarAcao = 0;
  
  printf("============================================\n");
  printf("\n\tGerenciador de Projetos de Edificações\n");
  printf("============================================\n");

  printf("\nEscolha uma opção\n");
  printf("\n1 - Cadastrar Projeto\n");
  printf("\n2 - Ver Status de Projetos\n");

  scanf("%d", &opcaoMenu);

  menuPrincipal(executarAcao);


  
  return 0;
}

void statusProjeto(int opcaoStatus) {
  switch(opcaoStatus) {

    case 1:
      printf("A Fazer");
      break;

    case 2:
      printf("Fazendo\n");
      break;

    case 3:
      printf("Concluído");
      break;
    
  }
}

void tipoEmpreendimento(int tipoEmpreendimento) {
  switch(tipoEmpreendimento) {

    case 1:
      printf("\nComercial");
      break;

    case 2:
      printf("\nResidencial");
      break;

    default:
      printf("Opção inválida");

  }
}

void mostrarTipoImpressao() {
  printf("1 - A fazer\n");
  printf("2 - Fazendo\n");
  printf("3 - Concluído\n");
  printf("4 - Tipo de Empreendimento\n");
}

void mostrarStatus() {
  printf("1 - A fazer\n");
  printf("2 - Fazendo\n");
  printf("3 - Concluído\n");
}

int menuPrincipal(int opcaoMenu) {

  int executarAcao = 0;

  while(executarAcao == 0) {
    
    switch(opcaoMenu) {
      case 1: 
        printf("\nCadastrar Projeto\n");
        ++executarAcao;
      break;

      case 2:
        printf("Imprimir projetos\n");
        ++executarAcao;
      break;

      case 3:
        printf("Encerrar");
      break;

      default:
        printf("Escolha uma opcao válida\n");
        printf("\n1 - Cadastrar Projeto\n");
        printf("2 - Ver Status de Projetos\n");
        printf("3 - Encerrar");
        
        scanf("%d", &opcaoMenu);
    }

  }

  return opcaoMenu;
}

int menuImpressao(int opcaoImpressao) {
  int menuImpressao = 0;

  while(menuImpressao == 0) {
    
    switch(opcaoImpressao) {
      case 1: 
        printf("\nCadastrar Projeto\n");
        ++menuImpressao;
      break;

      case 2:
        printf("Imprimir projetos\n");
        ++menuImpressao;
      break;

      case 3:
        printf("Voltar ao menu principal");
      break;

      default:
        printf("Escolha uma opcao válida\n");
        printf("\n1 - Cadastrar Projeto\n");
        printf("2 - Ver Status de Projetos\n");
        printf("3 - Voltar ao menu principal");
        
        scanf("%d", &opcaoImpressao);
    }

  }

  return opcaoImpressao;
}

void imprimirProjetos(int opcaoMostrar, tpprojetos projetos[QTDMAXPROJETOS], int contador){
  for(int i=0; i < contador; i++) {
    if(projetos[i].statusProjeto == opcaoMostrar) {
      printf("======================================================================\n\n");

      printf("Código do projeto: %c \n", projetos[i].codigo);
      printf("Título do projeto: %c \n", projetos[i].titulo);
      printf("Descrição do projeto: %c \n", projetos[i].descricao);
      printf("Tipo de empreendimento: %c \n", tipoEmpreendimento(int projetos[i].tipoEmpreendimento));
      printf("Status do projeto: %c \n", statusProjeto(projetos[i].statusProjeto));
      printf("Responsável: %c \n", projetos[i].responsavel);
      printf("Data Inicial: %c \n", projetos[i].dataInicio);
      printf("Data Final: %c \n", projetos[i].dataFim);

      printf("\n======================================================================\n\n");
    }
  }
}

tpprojetos cadastrarProjeto(int codigo) {

  tpprojetos projeto;

  projeto.codigo = ++codigo;

  printf("\nInsira o título:\n");
  scanf("%c", titulo);
  projeto.titulo = titulo;

  printf("\nInsira a descrição do projeto:\n");
  scanf("%c", descricao);
  projeto.descricao = descricao;

  printf("\nInsira o tipo de empreendimento:\n")
  printf("\n1 - Comercial");
  printf("\n2 - Residencial");
  scanf("%d", tipoEmpreendimento);
  projeto.tpEmpreendimento = tipoEmpreendimento

  printf("\nInsira o ano do projeto:\n");
  scanf("%d", &ano);
  projeto.ano = ano;

  printf("\nInforme o status do projeto:\n");
  printf("\n1 - A Fazer");
  printf("\n2 - Fazendo");
  printf("\n3 - Concluído");
  scanf("%d", &statusProjeto);
  projeto.statusProjeto = statusProjeto;

  printf("\nInsira o responsável pelo projeto:\n");
  scanf("%c", repsonsavel);
  projeto.responsavel = responsavel;

  printf("\nInsira a data de início:\n");
  scanf("%c", dataInicio);
  projeto.dataInicio = dataInicio;

  printf("\nInsira a data final:\n");
  scanf("%c", dataFim);
  projeto.dataFim = dataFim;

  return projeto;
}
