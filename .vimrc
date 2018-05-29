set nocompatible              " required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'git://git.wincent.com/command-t.git'
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Add all your plugins here (note older versions of Vundle used Bundle instead of Plugin)



" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

set fileencodings=utf-8,ucs-bom,gb18030,gbk,gb2312,cp936
set termencoding=utf-8
set encoding=utf-8

function Compile()
		if &filetype == 'cpp'
				exec "!g++ % -o %< -g -Wall -Wextra -Wconversion -O2"
		elseif &filetype == 'c'
				exec "!gcc % -o %< -g -Wall -Wextra -Wconversion -O2"
		elseif &filetype == 'pas'
				exec "!fpc % -g"
		elseif &filetype == 'tex'
				exec "!xelatex '%'"
		elseif &filetype == 'java'
				exec "!javac %"
		elseif &filetype == 'scss'
				exec "!sass % > %<.css"
		endif
endfunction

function Debug()
		if &filetype == 'cpp'
				exec "!gdb ./%<"
		elseif &filetype == 'tex'
				exec "!okular './%<.pdf'"
		elseif &filetype == 'java'
				exec "!jdb %<"
		endif
endfunction

function Run()
		if &filetype == 'cpp'
				exec "!time ./%<"
		elseif &filetype == 'tex'
				exec "!okular './%<.pdf'"
		elseif &filetype == 'java'
				exec "!java %<"
		elseif &filetype == 'ruby'
				exec "!ruby %"
		elseif &filetype == 'html'
				exec "!firefox %"
		elseif &filetype == 'php'
				exec "!php %"
		elseif &filetype == 'sh'
				exec "!bash %"
		endif
endfunction

set hlsearch
set mouse=a
set smartindent
set shiftwidth=4 
set fdm=marker
set number
set tabstop=4
set softtabstop=4
"Enable folding
set foldmethod=indent
set foldlevel=99

autocmd InsertLeave * se nocul
autocmd InsertEnter * se cul

syntax on
filetype plugin indent on

imap jj <esc>
nnoremap <space> za
map <F2> :NERDTreeToggle<CR>
nmap <F4> :TagbarToggle<CR>
map <F5> : call Debug() <CR>
map <F6> : call Run() <CR>
map <F7> : ! python3 % <CR>
map <F8> : call Compile() <CR>
noremap <F9> :Autoformat<CR>
map <F12> : ! subl ./% <CR>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

"--------------------------------------------------------------------------
"vim-airline
"--------------------------------------------------------------------------
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
let g:airline_theme="molokai"

"这个是安装字体后 必须设置此项"
let g:airline_powerline_fonts = 1
set laststatus=2
"打开tabline功能,方便查看Buffer和切换,省去了minibufexpl插件
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1

"设置切换Buffer快捷键"
nnoremap <C-tab> :bn<CR>
nnoremap <C-s-tab> :bp<CR>
" 关闭状态显示空白符号计数
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#whitespace#symbol = '!'

set guifont=Liberation\ Mono\ for\ Powerline\ 10

if !exists('g:airline_symbols')
		let g:airline_symbols = {}
endif

let g:airline_symbols.branch = '⎇'

"---------------------------------------------------------------------------
"vim-NERDTree
"---------------------------------------------------------------------------
Plugin 'scrooloose/nerdtree'
let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree
let NERDTreeWinPos='left'
let NERDTreeWinSize=35

"---------------------------------------------------------------------------
"vim-YouCompleteMe
"---------------------------------------------------------------------------
Bundle 'Valloric/YouCompleteMe'
Bundle 'Valloric/ListToggle'
Bundle 'scrooloose/syntastic'
nnoremap <leader>jd :YcmCompleter GoToDefinitionElseDeclaration<CR>
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
"Do not ask when starting vim
let g:ycm_confirm_extra_conf = 0
let g:syntastic_always_populate_loc_list = 1
set completeopt=longest,menu    "让Vim的补全菜单行为与一般IDE一致(参考VimTip1228)
autocmd InsertLeave * if pumvisible() == 0|pclose|endif "离开插入模式后自动关闭预览窗口
inoremap <expr> <CR>       pumvisible() ? "\<C-y>" : "\<CR>"    "回车即选中当前项
"上下左右键的行为 会显示其他信息
inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
inoremap <expr> <PageUp>   pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"

"youcompleteme  默认tab  s-tab 和自动补全冲突
"let g:ycm_key_list_select_completion=['<c-n>']
let g:ycm_key_list_select_completion = ['<Down>']
"let g:ycm_key_list_previous_completion=['<c-p>']
let g:ycm_key_list_previous_completion = ['<Up>']

let g:ycm_collect_identifiers_from_tags_files=1 " 开启 YCM 基于标签引擎
let g:ycm_min_num_of_chars_for_completion=2 " 从第2个键入字符就开始罗列匹配项
let g:ycm_cache_omnifunc=0  " 禁止缓存匹配项,每次都重新生成匹配项
let g:ycm_seed_identifiers_with_syntax=1    " 语法关键字补全

"nnoremap <leader>lo :lopen<CR> "open locationlist
"nnoremap <leader>lc :lclose<CR>    "close locationlist
inoremap <leader><leader> <C-x><C-o>
"在注释输入中也能补全
let g:ycm_complete_in_comments = 1
"在字符串输入中也能补全
let g:ycm_complete_in_strings = 1
"注释和字符串中的文字也会被收入补全
let g:ycm_collect_identifiers_from_comments_and_strings = 0

"---------------------------------------------------------------------------
"vim-Tagbar
"---------------------------------------------------------------------------
Bundle 'majutsushi/tagbar'
let g:tagbar_width=35
let g:tagbar_autofocus=1

"---------------------------------------------------------------------------
"vim-autoformat
"---------------------------------------------------------------------------
Plugin 'Chiel92/vim-autoformat'
let g:autmformat_verbosemode=1
let g:formatdef_google = '"astyle --style=google --indent=spaces=4 --pad-oper --suffix=none"'
let g:formatters_cpp = ['google']
let g:formatters_c = ['google']

let g:autoformat_autoindent = 0
let g:autoformat_retab = 0
let g:autoformat_remove_trailing_spaces = 0

"---------------------------------------------------------------------------
"vim-NerdCommenter
"---------------------------------------------------------------------------
Bundle 'scrooloose/nerdcommenter'
" 注释的时候自动加个空格, 强迫症必配
let g:NERDSpaceDelims=1

"---------------------------------------------------------------------------
"vim-ctrlp
"---------------------------------------------------------------------------
Plugin 'kien/ctrlp.vim'
let g:ctrlp_map = '<leader>p'
let g:ctrlp_cmd = 'CtrlP'
map <leader>f :CtrlPMRU<CR>
let g:ctrlp_custom_ignore = {
						\ 'dir':  '\v[\/]\.(git|hg|svn|rvm)$',
						\ 'file': '\v\.(exe|so|dll|zip|tar|tar.gz|pyc)$',
						\ }
let g:ctrlp_working_path_mode=0
let g:ctrlp_match_window_bottom=1
let g:ctrlp_max_height=15
let g:ctrlp_match_window_reversed=0
let g:ctrlp_mruf_max=500
let g:ctrlp_follow_symlinks=1
