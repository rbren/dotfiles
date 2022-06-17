"Vim-plug section
call plug#begin(stdpath('data') . '/plugged')
Plug 'vim-test/vim-test'
Plug 'itspriddle/vim-shellcheck'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'

" autocomplete
Plug 'Shougo/ddc.vim'
Plug 'vim-denops/denops.vim'

call plug#end()
"for scrolling vim-test output
tmap <C-o> <C-\><C-n>

syntax enable
set tabstop=4
set softtabstop=2
set shiftwidth=2
set expandtab
set autoindent
set termguicolors

:set hlsearch

nmap <silent> <C-Up> :wincmd k<CR>
nmap <silent> <C-Down> :wincmd j<CR>
nmap <silent> <C-Left> :wincmd h<CR>
nmap <silent> <C-Right> :wincmd l<CR>
nmap <silent> <C-h> :wincmd H<CR>

setl sw=2 sts=2 et
au FileType python setl sw=4 sts=4 et
au FileType go setl autoindent noexpandtab tabstop=4 shiftwidth=4 softtabstop=0 noexpandtab
au FileType go hi Conceal guibg=NONE ctermbg=NONE ctermfg=DarkGrey
au FileType go autocmd BufWinEnter * setl conceallevel=2 concealcursor=nv
au FileType go autocmd BufWinEnter * syn match LeadingSpace /\(^ *\)\@<= / containedin=ALL conceal cchar=>
au FileType go autocmd BufReadPre * setl conceallevel=2 concealcursor=nv
au FileType go autocmd BufReadPre * syn match LeadingSpace /\(^ *\)\@<= / containedin=ALL conceal cchar=>
let g:vim_markdown_folding_disabled = 1
let g:go_fmt_fail_silently = 1
set rtp+=$GOPATH/src/golang.org/x/lint/misc/vim

"Disable arrow keys to force use of hjkl
nnoremap <Left> :echo "No Left for you!"<CR>
nnoremap <Right> :echo "No Right for you!"<CR>
nnoremap <Up> :echo "No Up for you!"<CR>
nnoremap <Down> :echo "No Down for you!"<CR>

" From: https://aonemd.github.io/blog/minimal-vim
"more characters will be sent to the screen for redrawing
:set ttyfast
"time waited for key press(es) to complete. It makes for a faster key response
:set ttimeout
:set ttimeoutlen=50
"make backspace behave properly in insert mode
":set backspace=indent,eol,start
"display incomplete commands
:set showcmd
"a better menu in command mode
:set wildmenu
:set wildmode=longest:full,full
"disable soft wrap for lines
:set nowrap
"always display the status line
:set laststatus=2
"display line numbers on the left side
:set number
"show relative lines below and above current line
:set relativenumber
"display text width column
:set colorcolumn=101
"new splits will be at the bottom or to the right side of the screen
:set splitbelow
:set splitright
"always set autoindenting on
:set autoindent
"no incremental search
:set noincsearch
"highlight search
:set hlsearch
"searches are case insensitive unless they contain at least one capital letter
":set ignorecase
":set smartcase

:set foldmethod=indent
:set foldlevel=99

command! StartCopy :set norelativenumber | :set nonumber | :set wrap | :only
command! EndCopy :set relativenumber | :set number | :set nowrap

"show blame via https://github.com/zivyangll/git-blame.vim
:function Myblame()
    let blank = ' '
    let file = expand('%')
    let line = line('.')
    let gb = gitblame#commit_summary(file, line)
    if has_key(gb, 'error')
        " ignore error
        let echoMsg = ''
    else
        let echoMsg = '['.gb['commit_hash'][0:8].'] '.gb['summary'] .blank .gb['author_mail'] .blank .gb['author'] .blank .'('.gb['author_time'].')'
    endif
    if (g:GBlameVirtualTextEnable)
       let ns = nvim_create_namespace('gitBlame'.b:GBlameVirtualTextCounter)
       let b:GBlameVirtualTextCounter = (b:GBlameVirtualTextCounter + 1)%50
       let line = line('.')
       let buffer = bufnr('')
       call nvim_buf_set_virtual_text(buffer, ns, line-1, [[g:GBlameVirtualTextPrefix.echoMsg, 'GBlameMSG']], {})
       call timer_start(g:GBlameVirtualTextDelay, { tid -> nvim_buf_clear_namespace(buffer, ns, 0, -1)})
    endif
    echo echoMsg
endfunction
" Disabling this because it's annonying
"autocmd CursorHold <buffer> call Myblame()

"underscores are work breakpoints
:set iskeyword-=_

"FROM https://github.com/tpope/vim-pathogen
call pathogen#infect()
call pathogen#helptags()

" Enable filetype plugins
syntax on
filetype plugin indent on

" https://github.com/preservim/nerdtree
"autocmd vimenter * NERDTree
"autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
"command! -nargs=1 -complete=file | wincmd p
"autocmd VimEnter * wincmd l

" https://github.com/Shougo/deoplete.nvim
let g:deoplete#enable_at_startup = 1

"FROM http://leafo.net/lessphp/vim/
au BufNewFile,BufRead *.less set filetype=less

"FROM https://github.com/blerins/flattown/blob/master/colors/flattown.vim

if version > 580
    hi clear
    if exists("syntax_on")
        syntax reset
    endif
endif

" Tell vim to remember certain things when we exit
"  '10  :  marks will be remembered for up to 10 previously edited files
"  "100 :  will save up to 100 lines for each register
"  :50  :  up to 20 lines of command-line history will be remembered
"  %    :  saves and restores the buffer list
"  n... :  where to save the viminfo files
set viminfo='10,\"100,:20,%,n~/.viminfo
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

set t_Co=256
let g:colors_name = "flattown"

" Styles
hi Cursor guifg=#262626 guibg=#d7ffff guisp=#d7ffff gui=NONE ctermfg=235 ctermbg=195 cterm=NONE
hi Ignore guifg=#60666b guibg=NONE guisp=NONE gui=NONE ctermfg=242 ctermbg=NONE cterm=NONE
hi VertSplit guifg=#444444 guibg=#444444 guisp=#444444 gui=NONE ctermfg=238 ctermbg=238 cterm=NONE
hi NonText guifg=#949494 guibg=NONE guisp=NONE gui=NONE ctermfg=246 ctermbg=NONE cterm=NONE

hi LineNr guifg=#515253 guibg=#2c2f31 guisp=#2c2f31 gui=NONE ctermfg=239 ctermbg=236 cterm=NONE
hi Comment guifg=#FFB6C1 guibg=NONE guisp=NONE gui=NONE ctermfg=242 ctermbg=NONE cterm=NONE
hi Todo guifg=#FFB6C1 guibg=NONE guisp=NONE gui=bold ctermfg=66 ctermbg=NONE cterm=bold

hi Function guifg=#af87d7 guibg=NONE guisp=NONE gui=NONE ctermfg=140 ctermbg=NONE cterm=NONE
hi Identifier guifg=#96cdeb guibg=NONE guisp=NONE gui=NONE ctermfg=81 ctermbg=NONE cterm=NONE
hi Type guifg=#5f87d7 guibg=NONE guisp=NONE gui=NONE ctermfg=68 ctermbg=NONE cterm=NONE
hi Directory guifg=#4a80ba guibg=NONE guisp=NONE gui=NONE ctermfg=67 ctermbg=NONE cterm=NONE
hi Special guifg=#db402c guibg=NONE guisp=NONE gui=NONE ctermfg=160 ctermbg=NONE cterm=NONE

hi Float guifg=#b8d977 guibg=NONE guisp=NONE gui=NONE ctermfg=150 ctermbg=NONE cterm=NONE
hi Character guifg=#b8d977 guibg=NONE guisp=NONE gui=NONE ctermfg=150 ctermbg=NONE cterm=NONE
hi Number guifg=#b8d977 guibg=NONE guisp=NONE gui=NONE ctermfg=150 ctermbg=NONE cterm=NONE
hi Boolean guifg=#b8d977 guibg=NONE guisp=NONE gui=NONE ctermfg=150 ctermbg=NONE cterm=NONE
hi Constant guifg=#b8d977 guibg=NONE guisp=NONE gui=NONE ctermfg=150 ctermbg=NONE cterm=NONE

hi String guifg=#76b976 guibg=NONE guisp=NONE gui=NONE ctermfg=71 ctermbg=NONE cterm=NONE

hi Statement guifg=#ffd75f guibg=NONE guisp=NONE gui=NONE ctermfg=221 ctermbg=NONE cterm=NONE
hi PreProc guifg=#fa9a4b guibg=NONE guisp=NONE gui=NONE ctermfg=215 ctermbg=NONE cterm=NONE
hi Define guifg=#db402c guibg=NONE guisp=NONE gui=NONE ctermfg=167 ctermbg=NONE cterm=NONE
hi Include guifg=#db402c guibg=NONE guisp=NONE gui=NONE ctermfg=167 ctermbg=NONE cterm=NONE
hi Macro guifg=#db402c guibg=NONE guisp=NONE gui=NONE ctermfg=167 ctermbg=NONE cterm=NONE
hi Exception guifg=#db402c guibg=NONE guisp=NONE gui=NONE ctermfg=167 ctermbg=NONE cterm=NONE

hi Conditional guifg=#ffaf5f guibg=NONE guisp=NONE gui=NONE ctermfg=215 ctermbg=NONE cterm=NONE
hi Repeat guifg=#ffaf5f guibg=NONE guisp=NONE gui=NONE ctermfg=215 ctermbg=NONE cterm=NONE

hi rubySymbol guifg=#b8d977 guibg=NONE guisp=NONE gui=NONE ctermfg=156 ctermbg=NONE cterm=NONE
hi rubyStringDelimiter guifg=#448544 guibg=NONE guisp=NONE gui=NONE ctermfg=28 ctermbg=NONE cterm=NONE
hi rubyInterpolationDelimiter guifg=#448544 guibg=NONE guisp=NONE gui=NONE ctermfg=28 ctermbg=NONE cterm=NONE
hi rubyRegexp guifg=#ffb454 guibg=NONE guisp=NONE gui=NONE ctermfg=215 ctermbg=NONE cterm=NONE
hi rubyRegexpDelimiter guifg=#ffb454 guibg=NONE guisp=NONE gui=NONE ctermfg=215 ctermbg=NONE cterm=NONE
hi rubyExceptional guifg=#ffd75f guibg=NONE guisp=NONE gui=NONE ctermfg=221 ctermbg=NONE cterm=NONE

hi htmltagname guifg=#b7d877 guibg=NONE guisp=NONE gui=NONE ctermfg=150 ctermbg=NONE cterm=NONE
hi htmltag guifg=#b7d877 guibg=NONE guisp=NONE gui=NONE ctermfg=150 ctermbg=NONE cterm=NONE
hi htmlendtag guifg=#b7d877 guibg=NONE guisp=NONE gui=NONE ctermfg=150 ctermbg=NONE cterm=NONE

hi csspseudoclassid guifg=#72aaca guibg=NONE guisp=NONE gui=NONE ctermfg=110 ctermbg=NONE cterm=NONE
hi cssclassname guifg=#72aaca guibg=NONE guisp=NONE gui=NONE ctermfg=110 ctermbg=NONE cterm=NONE

hi pythonBuiltin guifg=#5f87d7 guibg=NONE guisp=NONE gui=NONE ctermfg=68 ctermbg=NONE cterm=NONE

hi WildMenu guifg=#1c1c1c guibg=#ffff99 guisp=#ffff99 gui=NONE ctermfg=234 ctermbg=228 cterm=NONE
"hi SignColumn -- no settings --
hi SpecialComment guifg=#FFB6C1 guibg=NONE guisp=NONE gui=NONE ctermfg=15 ctermbg=NONE cterm=NONE
hi Typedef guifg=#72aaca guibg=NONE guisp=NONE gui=NONE ctermfg=110 ctermbg=NONE cterm=NONE
hi Title guifg=#f8f8f8 guibg=NONE guisp=NONE gui=bold ctermfg=15 ctermbg=NONE cterm=bold
hi Folded guifg=#798188 guibg=#26292c guisp=#26292c gui=NONE ctermfg=66 ctermbg=236 cterm=NONE
hi PreCondit guifg=#ffb454 guibg=NONE guisp=NONE gui=NONE ctermfg=215 ctermbg=NONE cterm=NONE
hi StatusLineNC guifg=#b8b8b8 guibg=#292c2f guisp=#292c2f gui=NONE ctermfg=250 ctermbg=236 cterm=NONE
"hi CTagsMember -- no settings --
"hi CTagsGlobalConstant -- no settings --
hi DiffText guifg=NONE guibg=#2E4052 guisp=#2E4052 gui=bold ctermfg=NONE ctermbg=239 cterm=bold
hi ErrorMsg guifg=#f8f8f8 guibg=#ad3725 guisp=#ad3725 gui=NONE ctermfg=15 ctermbg=124 cterm=NONE
hi Debug guifg=#f8f8f8 guibg=NONE guisp=NONE gui=NONE ctermfg=15 ctermbg=NONE cterm=NONE
hi PMenuSbar guifg=#cdcecf guibg=#35393e guisp=#35393e gui=NONE ctermfg=252 ctermbg=237 cterm=NONE
hi SpecialChar guifg=#f8f8f8 guibg=NONE guisp=NONE gui=NONE ctermfg=15 ctermbg=NONE cterm=NONE
hi StorageClass guifg=#f6f080 guibg=NONE guisp=NONE gui=NONE ctermfg=228 ctermbg=NONE cterm=NONE
hi StatusLine guifg=#f8f8f8 guibg=#292c2f guisp=#292c2f gui=bold ctermfg=15 ctermbg=236 cterm=bold
hi Label guifg=#f6f6f6 guibg=NONE guisp=NONE gui=NONE ctermfg=255 ctermbg=NONE cterm=NONE
"hi CTagsImport -- no settings --
hi PMenuSel guifg=#ffffff guibg=#3498DB guisp=#3498DB gui=bold ctermfg=15 ctermbg=74 cterm=bold
" hi Search guifg=#16191c guibg=#fffebe guisp=#fffebe gui=NONE ctermfg=234 ctermbg=229 cterm=NONE
hi Search guifg=NONE guibg=#000000 cterm=NONE ctermfg=grey ctermbg=blue
hi IncSearch guifg=NONE guibg=#ffffff guisp=#cccccc gui=NONE ctermfg=15 ctermbg=74 cterm=NONE
"hi CTagsGlobalVariable -- no settings --
hi Delimiter guifg=#f8f8f8 guibg=NONE guisp=NONE gui=NONE ctermfg=15 ctermbg=NONE cterm=NONE
"hi SpellRare -- no settings --
"hi EnumerationValue -- no settings --
hi TabLineSel guifg=#c9cacb guibg=#1c1c1c guisp=#1c1c1c gui=bold ctermfg=252 ctermbg=234 cterm=bold
hi Operator guifg=#e0c82f guibg=NONE guisp=NONE gui=NONE ctermfg=215 ctermbg=NONE cterm=NONE
hi CursorLine guifg=NONE guibg=#2d3033 guisp=#2d3033 gui=NONE ctermfg=NONE ctermbg=236 cterm=NONE
hi ColorColumn guifg=NONE guibg=#3b3e40 guisp=#3b3e40 gui=NONE ctermfg=NONE ctermbg=238 cterm=NONE
"hi Union -- no settings --
hi TabLineFill guifg=#e2e4e5 guibg=#212325 guisp=#212325 gui=NONE ctermfg=254 ctermbg=235 cterm=NONE
hi Question guifg=#a0a0a0 guibg=#26292c guisp=#26292c gui=NONE ctermfg=247 ctermbg=236 cterm=NONE
hi WarningMsg guifg=#f8f8f8 guibg=#aa2915 guisp=#aa2915 gui=NONE ctermfg=15 ctermbg=124 cterm=NONE
hi VisualNOS guifg=NONE guibg=#414549 guisp=#414549 gui=NONE ctermfg=NONE ctermbg=239 cterm=NONE
hi DiffDelete guifg=#8F433D guibg=#8F433D guisp=#8F433D gui=NONE ctermfg=95 ctermbg=95 cterm=NONE
hi ModeMsg guifg=#a0a0a0 guibg=#26292c guisp=#26292c gui=NONE ctermfg=247 ctermbg=236 cterm=NONE
hi CursorColumn guifg=NONE guibg=#3b3e40 guisp=#3b3e40 gui=NONE ctermfg=NONE ctermbg=238 cterm=NONE
hi FoldColumn guifg=#798188 guibg=#26292c guisp=#26292c gui=NONE ctermfg=66 ctermbg=236 cterm=NONE
hi PreProc guifg=#fa9a4b guibg=NONE guisp=NONE gui=NONE ctermfg=215 ctermbg=NONE cterm=NONE
"hi EnumerationName -- no settings --
hi Visual guifg=NONE guibg=#414549 guisp=#414549 gui=NONE ctermfg=NONE ctermbg=239 cterm=NONE
"hi MoreMsg -- no settings --
"hi SpellCap -- no settings --
hi Keyword guifg=#fa9a4b guibg=NONE guisp=NONE gui=NONE ctermfg=215 ctermbg=NONE cterm=NONE
hi DiffChange guifg=NONE guibg=#273645 guisp=#273645 gui=NONE ctermfg=NONE ctermbg=238 cterm=NONE
"hi SpellLocal -- no settings --
"hi Error -- no settings --
hi PMenu guifg=#949ba1 guibg=#303336 guisp=#303336 gui=NONE ctermfg=247 ctermbg=237 cterm=NONE
hi SpecialKey guifg=#7a8288 guibg=#3b3e40 guisp=#3b3e40 gui=NONE ctermfg=66 ctermbg=238 cterm=NONE
"hi DefinedName -- no settings --
hi Tag guifg=#72aaca guibg=NONE guisp=NONE gui=NONE ctermfg=110 ctermbg=NONE cterm=NONE
hi PMenuThumb guifg=#82898f guibg=#4c4f54 guisp=#4c4f54 gui=NONE ctermfg=245 ctermbg=240 cterm=NONE
hi MatchParen guifg=#ffffff guibg=#fa9a4b guisp=#fa9a4b gui=underline ctermfg=236 ctermbg=215 cterm=underline
"hi LocalVariable -- no settings --
"hi SpellBad -- no settings --
"hi CTagsClass -- no settings --
"hi Clear -- no settings --
hi Structure guifg=#72aaca guibg=NONE guisp=NONE gui=NONE ctermfg=110 ctermbg=NONE cterm=NONE
hi Underlined guifg=NONE guibg=NONE guisp=NONE gui=underline ctermfg=NONE ctermbg=NONE cterm=underline
hi DiffAdd guifg=#f8f8f8 guibg=#487a1a guisp=#487a1a gui=bold ctermfg=15 ctermbg=2 cterm=bold
hi TabLine guifg=#797a7b guibg=#212325 guisp=#212325 gui=NONE ctermfg=8 ctermbg=235 cterm=NONE


"FROM http://stackoverflow.com/questions/4617059/showing-trailing-spaces-in-vim
hi ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
