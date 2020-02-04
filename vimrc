"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" This vimrc is based on the vimrc by Amix:
"       http://amix.dk/vim/vimrc.html
" You can find the latest version on:
"       http://github.com/easwy/share/tree/master/vim/vimrc/
" Maintainer:  Easwy Yang
" Homepage:    http://easwy.com/
" Version Change: Mon Oct 25 16:04:31 CST 2010
" Version:     0.2
"
"
" SubEditer:   Xiaofei Cui
" Homepage:    http://xiaophy.com/
" MyChange:    19.11.13
" MyVersion:   0.3
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""



"""""""""""""""""""Release readme""""""""""""""""""""""""""""""
"0.3
"完成了基本的命令并且可以自己添加和修改
"有补全的快捷命令，类似mathematica的括号补全
"还支持了Vundle包管理器，重新进行了vim编译，支持snippets
"另外还有OpenResearch的文件头可以自动写入markdown
"修改部分冲突function为func!
"添加readme的注释头
"作为OR的组成部分
"cout输出格式快捷命令,好像没啥用
"整理了解了一些功能
"有待完成的:
"分成不同的模块加载有几个子文件
"学习autoload
"vimscript进阶
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""Quick Jumptofile""""""""""""""""""""""""""""
nmap <silent> <leader>pp :call SwitchToBuf("~/paper/dissertation/master/thesis/nkthesis.bib")<cr>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Get out of VI's compatible mode..
set nocompatible
" ignore case when searching
"set ic
"set noic
" set spell check with UK english
"set spell spelllang=en_gb
map <F6> <Esc>:setlocal spell spelllang=en_gb<CR>
map <F7> <Esc>:setlocal nospell<CR>



" Platform
function! MySys()
  if has("win32")
    return "windows"
  else
    return "linux"
  endif
endfunction

"Sets how many lines of history VIM har to remember
set history=400

" Always use English messages & menu
"language zh_CN.UTF-8
"language messages en_US.ISO_8859-1
"set langmenu=en_US.ISO_8859-1

" Chinese
" multi-encoding setting
if has("multi_byte")
  "set bomb
  set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,sjis,euc-kr,ucs-2le,latin1
  " CJK environment detection and corresponding setting
  if v:lang =~ "^zh_CN"
    " Use cp936 to support GBK, euc-cn == gb2312
    set encoding=chinese
    set termencoding=chinese
    set fileencoding=chinese
  elseif v:lang =~ "^zh_TW"
    " cp950, big5 or euc-tw
    " Are they equal to each other?
    set encoding=taiwan
    set termencoding=taiwan
    set fileencoding=taiwan
  "elseif v:lang =~ "^ko"
  "  " Copied from someone's dotfile, untested
  "  set encoding=euc-kr
  "  set termencoding=euc-kr
  "  set fileencoding=euc-kr
  "elseif v:lang =~ "^ja_JP"
  "  " Copied from someone's dotfile, untested
  "  set encoding=euc-jp
  "  set termencoding=euc-jp
  "  set fileencoding=euc-jp
  endif
  " Detect UTF-8 locale, and replace CJK setting if needed
  if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
    set encoding=utf-8
    set termencoding=utf-8
    set fileencoding=utf-8
  endif
endif
"if MySys() == "windows"
   "set encoding=utf-8
   "set langmenu=zh_CN.UTF-8
   "language message zh_CN.UTF-8
   "set fileencodings=ucs-bom,utf-8,gb18030,cp936,big5,euc-jp,euc-kr,latin1
"endif

"added by yangzw, 20131215
syntax on

"Set to auto read when a file is changed from the outside
set autoread

"Have the mouse enabled all the time:
"set mouse=a

"Set mapleader
let mapleader = ","
let g:mapleader = ","

"Fast normal write quit
"Fast saving and Fast quiting
nmap <silent> <leader>ww :w<cr>
nmap <silent> <leader>qq :q<cr>

"nmap <silent> <leader>qqa :qa<cr>
"nmap <silent> <leader>wq :wq<cr>
"nmap <silent> <leader>wf :w!<cr>
"nmap <silent> <leader>qf :q!<cr>


" For Thinkpad
"imap <F1> <ESC>
"nmap <F1> <ESC>
"cmap <F1> <ESC>
"vmap <F1> <ESC>

" Switch to buffer according to file name
function! SwitchToBuf(filename)
    "let fullfn = substitute(a:filename, "^\\~/", $HOME . "/", "")
    " find in current tab
    let bufwinnr = bufwinnr(a:filename)
    if bufwinnr != -1
        exec bufwinnr . "wincmd w"
        return
    else
        " find in each tab
        tabfirst
        let tab = 1
        while tab <= tabpagenr("$")
            let bufwinnr = bufwinnr(a:filename)
            if bufwinnr != -1
                exec "normal " . tab . "gt"
                exec bufwinnr . "wincmd w"
                return
            endif
            tabnext
            let tab = tab + 1
        endwhile
        " not exist, new tab
        exec "tabnew " . a:filename
    endif
endfunction

"Fast edit vimrc
if MySys() == 'linux'
    "Fast reloading of the .vimrc
    map <silent> <leader>ss :source ~/.vimrc<cr>
    "Fast editing of .vimrc
    map <silent> <leader>ee :call SwitchToBuf("~/.vimrc")<cr>
    "When .vimrc is edited, reload it
    "autocmd! bufwritepost .vimrc source ~/.vimrc
elseif MySys() == 'windows'
    " Set helplang
    set helplang=cn
    "Fast reloading of the _vimrc
    map <silent> <leader>ss :source ~/_vimrc<cr>
    "Fast editing of _vimrc
    map <silent> <leader>ee :call SwitchToBuf("~/_vimrc")<cr>
    "When _vimrc is edited, reload it
    autocmd! bufwritepost _vimrc source ~/_vimrc
endif

" For windows version
if MySys() == 'windows'
    source $VIMRUNTIME/mswin.vim
    behave mswin

    set diffexpr=MyDiff()
    function! MyDiff()
        let opt = '-a --binary '
        if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
        if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
        let arg1 = v:fname_in
        if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
        let arg2 = v:fname_new
        if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
        let arg3 = v:fname_out
        if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
        let eq = ''
        if $VIMRUNTIME =~ ' '
            if &sh =~ '\<cmd'
                let cmd = '""' . $VIMRUNTIME . '\diff"'
                let eq = '"'
            else
                let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
            endif
        else
            let cmd = $VIMRUNTIME . '\diff'
        endif
        silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
    endfunction
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"Set font
if MySys() == "linux"
  if has("gui_gtk2")
    set gfn=Courier\ New\ 10,Courier\ 10,Luxi\ Mono\ 10,
          \DejaVu\ Sans\ Mono\ 10,Bitstream\ Vera\ Sans\ Mono\ 10,
          \SimSun\ 10,WenQuanYi\ Micro\ Hei\ Mono\ 10
  elseif has("x11")
    set gfn=*-*-medium-r-normal--10-*-*-*-*-m-*-*
  endif
endif

" Avoid clearing hilight definition in plugins
if !exists("g:vimrc_loaded")
    "Enable syntax hl
    syntax enable

    " color scheme
    if has("gui_running")
        set guioptions-=T
        set guioptions-=m
        set guioptions-=L
        set guioptions-=r
        colorscheme darkblue_my
        "hi normal guibg=#294d4a
        set cursorline
    else
        "colorscheme desert_my
        colorscheme desert
    endif " has
endif " exists(...)

"Some nice mapping to switch syntax (useful if one mixes different languages in one file)
map <leader>1 :set syntax=c<cr>
map <leader>2 :set syntax=xhtml<cr>
map <leader>3 :set syntax=python<cr>
map <leader>4 :set ft=javascript<cr>
map <leader>$ :syntax sync fromstart<cr>

autocmd BufEnter * :syntax sync fromstart
"autocmd BufEnter * :call DoWordComplete()

" CTRL-C
"vnoremap <C-C> "+y

" Use CTRL-Q to do what CTRL-V used to do
"noremap <C-Q>		<C-V>

" CTRL-V
"map <C-V>		"+gP
"cmap <C-V>		<C-R>+
"exe 'inoremap <script> <C-V>' paste#paste_cmd['i']
"exe 'vnoremap <script> <C-V>' paste#paste_cmd['v']

"Highlight current
"if has("gui_running")
"  set cursorline
"  hi cursorline guibg=#333333
"  hi CursorColumn guibg=#333333
"endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Fileformats
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Favorite filetypes
set ffs=unix,dos

nmap <leader>fd :se ff=dos<cr>
nmap <leader>fu :se ff=unix<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VIM userinterface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Set 7 lines to the curors - when moving vertical..
"set so=7

" Maximum window when GUI running
if has("gui_running")
  "set lines=9999
  "set columns=9999
endif

"Turn on WiLd menu
set wildmenu

"Always show current position
set ruler

"The commandbar is 2 high
set cmdheight=2

"Show line number
set nonu

"Do not redraw, when running macros.. lazyredraw
set lz

"Change buffer - without saving
"set hid

"Set backspace
set backspace=eol,start,indent

"Bbackspace and cursor keys wrap to
"set whichwrap+=<,>,h,l
set whichwrap+=<,>

"Ignore case when searching
"set ignorecase

"Include search
set incsearch

"Highlight search things
set hlsearch

"Set magic on
set magic

"No sound on errors.
set noerrorbells
set novb t_vb=

"show matching bracets
set showmatch
"How many tenths of a second to blink
set mat=2



""""""""""""""""""""""""""""""
" Statusline
""""""""""""""""""""""""""""""
"Always hide the statusline
set laststatus=2
nmap <leader>s :set laststatus=0<cr>
nmap <leader>S :set laststatus=2<cr>

function! CurDir()
   let curdir = substitute(getcwd(), '/home/cuixf/', "~/", "g")
   return curdir
endfunction

"Format the statusline
set statusline=\ %F%m%r%h\ %w\ \ CWD:\ %r%{CurDir()}%h\ \ \ Line:\ %l/%L:%c


""""""""""""""""""""""""""""""
" Visual
""""""""""""""""""""""""""""""
" From an idea by Michael Naumann
function! VisualSearch(direction) range
  let l:saved_reg = @"
  execute "normal! vgvy"
  let l:pattern = escape(@", '\\/.*$^~[]')
  let l:pattern = substitute(l:pattern, "\n$", "", "")
  if a:direction == 'b'
    execute "normal ?" . l:pattern . "^M"
  else
    execute "normal /" . l:pattern . "^M"
  endif
  let @/ = l:pattern
  let @" = l:saved_reg
endfunction

"Basically you press * or # to search for the current selection !! Really useful
vnoremap <silent> * :call VisualSearch('f')<CR>
vnoremap <silent> # :call VisualSearch('b')<CR>


map <leader>cxf /cxf<cr>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Moving around and tabs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"Fast remove highlight search
nmap <silent> <leader><leader> :noh<cr>
"Fast redraw
nmap <silent> <leader><cr> :set hls<cr>

map <leader>tt :tabnew<space>
map <leader>te :tabedit
map <leader>vs :vsplit<space>
map <leader>df :diffthis
map <leader>n :set nonumber<cr>
map <leader>N :set number<cr>

imap <C-l> <right>
imap <C-h> <left>
imap <C-K> <up>
imap <C-j> <down>

imap <C-z> <Esc>z.i
imap <C-O> <Esc>o

nmap <left> :tabp<cr><cr>
nmap <right> :tabn<cr><cr>
nmap <down> :next<cr><cr>
nmap <up> :previous<cr><cr>

"Switch to current dir
map <silent> <leader>cd :cd %:p:h<cr>


"""""""""""""""设置粘贴功能"""""""""""""""""""""""""""""""""""
set nopaste
"Paste toggle - when pasting something in, don't indent.
set pastetoggle=<F3>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""latex"""""""""""""""""""""""""""""""""""
map <leader>lt :tabnew ~/.vim/snippets/latextemp.tex<cr>
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""cpppp"""""""""""""""""""""""""""""""""""
nmap <leader>co icout << "" << v <<endl;<Esc><S-f>"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Parenthesis/bracket expanding
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"vnoremap @1 <esc>`>a)<esc>`<i(<esc>
"")
"vnoremap @2 <esc>`>a]<esc>`<i[<esc>
"vnoremap @3 <esc>`>a}<esc>`<i{<esc>
"vnoremap @$ <esc>`>a"<esc>`<i"<esc>
"vnoremap @q <esc>`>a'<esc>`<i'<esc>
"vnoremap @w <esc>`>a"<esc>`<i"<esc>

"Map auto complete of (, ", ', [
"inoremap @1 ()<esc>:let leavechar=")"<cr>i
"inoremap @2 []<esc>:let leavechar="]"<cr>i
"inoremap @3 {}<esc>:let leavechar="}"<cr>i
"inoremap @4 {<esc>o}<esc>:let leavechar="}"<cr>O
"inoremap @q ''<esc>:let leavechar="'"<cr>i
"inoremap @w ""<esc>:let leavechar='"'<cr>i
"au BufNewFile,BufRead *.\(vim\)\@! inoremap " ""<esc>:let leavechar='"'<cr>i
"au BufNewFile,BufRead *.\(txt\)\@! inoremap ' ''<esc>:let leavechar="'"<cr>i

"imap <m-l> <esc>:exec "normal f" . leavechar<cr>a
"imap <d-l> <esc>:exec "normal f" . leavechar<cr>a

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General Abbrevs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"My information
"iab xdates <c-r>=strftime("%b %d, %Y")<cr>
"iab xdate <c-r>=strftime("%a %b %d %H:%M:%S %Z %Y")<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Editing mappings etc.
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

func! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  nohl
  exe "normal `z"
endfunc


" 与<C-j>有关系是一种补全
" do not automaticlly remove trailing whitespace
"autocmd BufWrite *.[ch] :call DeleteTrailingWS()
"autocmd BufWrite *.cc :call DeleteTrailingWS()
"autocmd BufWrite *.txt :call DeleteTrailingWS()
"nmap <silent> <leader>ws :call DeleteTrailingWS()<cr>:w<cr>
"nmap <silent> <leader>ws! :call DeleteTrailingWS()<cr>:w!<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Command-line config
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Bash like
cnoremap <C-A>    <Home>
cnoremap <C-E>    <End>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Buffer realted
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"Buffer缓存
"Actually, the tab does not switch buffers, but my arrows
"Bclose function can be found in "Buffer related" section
"map <leader>bd :Bclose<cr>

"Open a dummy buffer for paste
map <leader>bf :tabnew<cr>:setl buftype=nofile<cr>
if MySys() == "linux"
map <leader>bj :tabnew ~/tmp/scratch.txt<cr>
else
map <leader>bj :tabnew $TEMP/scratch.txt<cr>
endif

"Restore cursor to file position in previous editing session
set viminfo='10,\"100,:20,n~/.viminfo
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()

function! <SID>BufcloseCloseIt()
   let l:currentBufNum = bufnr("%")
   let l:alternateBufNum = bufnr("#")

   if buflisted(l:alternateBufNum)
     buffer #
   else
     bnext
   endif

   if bufnr("%") == l:currentBufNum
     new
   endif

   if buflisted(l:currentBufNum)
     execute("bdelete ".l:currentBufNum)
   endif
endfunction

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Session options
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set sessionoptions-=curdir
set sessionoptions+=sesdir

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Files and backups
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Turn backup off
"set nobackup
"set nowb
"set noswapfile


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Folding
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Enable folding, I find it very useful
"set fen
"set fdl=0
nmap <silent> <leader>zz zO

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Text options
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set expandtab
set shiftwidth=2

map <leader>t2 :set shiftwidth=2<cr>
map <leader>t4 :set shiftwidth=4<cr>

au FileType html,vim,javascript,xml setl shiftwidth=2
"au FileType html,python,vim,javascript setl tabstop=2
autocmd FileType python set et sw=4 ts=4 sts=4
au FileType java,c,cpp,cxx setl shiftwidth=2
"au FileType java setl tabstop=4
au FileType txt setl lbr
au FileType txt setl tw=200

set smarttab
set lbr
"行字数与换行有关
set tw=200

""""""""""""""""""""""""""""""
" Indent
""""""""""""""""""""""""""""""
"Auto indent
set ai

"Smart indet
set si

"C-style indeting
set cindent

"Wrap lines
set wrap


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Spell checking
" Not use
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Complete
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" options
set completeopt=menu
set complete-=u
set complete-=i

" imapping
" 下面好几种补全，只使用了一种
inoremap <C-F>             <C-X><C-F>
inoremap <C-A>    <Home>
inoremap <C-E>    <End>

"inoremap <expr> <CR>       pumvisible()?"\<C-Y>":"\<CR>"
"inoremap <expr> <C-J>      pumvisible()?"\<PageDown>\<C-N>\<C-P>":"\<C-X><C-O>"
"inoremap <expr> <C-K>      pumvisible()?"\<PageUp>\<C-P>\<C-N>":"\<C-K>"
"inoremap <expr> <C-U>      pumvisible()?"\<C-E>":"\<C-U>"
"inoremap <C-]>             <C-X><C-]>
"inoremap <C-D>             <C-X><C-D>
"inoremap <C-U>             <C-X><C-L>


" Enable syntax
if has("autocmd") && exists("+omnifunc")
  autocmd Filetype *
        \if &omnifunc == "" |
        \  setlocal omnifunc=syntaxcomplete#Complete |
        \endif
endif


" auto chmod
" This method can be used to change chmod type auto through diffrent files.
au BufWritePost * if getline(1) =~ "^#!" | if getline(1) =~ "/bin/" | silent !chmod a+x <afile> | endif | endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" 进阶使用方式tag还未学会
"" cscope setting
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"if has("cscope")
"  if MySys() == "linux"
"    set csprg=/usr/bin/cscope
"  else
"    set csprg=cscope
"  endif
"  set csto=1
"  set cst
"  set nocsverb
"  " add any database in current directory
"  if filereadable("cscope.out")
"      cs add cscope.out
"  endif
"  set csverb
"endif
"
"nmap <C-@>s :cs find s <C-R>=expand("<cword>")<CR><CR>
"nmap <C-@>g :cs find g <C-R>=expand("<cword>")<CR><CR>
"nmap <C-@>c :cs find c <C-R>=expand("<cword>")<CR><CR>
"nmap <C-@>t :cs find t <C-R>=expand("<cword>")<CR><CR>
"nmap <C-@>e :cs find e <C-R>=expand("<cword>")<CR><CR>
"nmap <C-@>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
"nmap <C-@>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
"nmap <C-@>d :cs find d <C-R>=expand("<cword>")<CR><CR>
"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin configuration
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
   """"""""""""""""""""""""""""""
   " super tab
   """"""""""""""""""""""""""""""
   let g:SuperTabPluginLoaded=1 " Avoid load SuperTab Plugin
   let g:SuperTabDefaultCompletionType='context'
   let g:SuperTabContextDefaultCompletionType='<c-p>'
   ""let g:SuperTabCompletionContexts = ['s:ContextText', 's:ContextDiscover']
   ""let g:SuperTabContextTextOmniPrecedence = ['&omnifunc', '&completefunc']
   ""let g:SuperTabContextDiscoverDiscovery =
   ""      \ ["&completefunc:<c-x><c-u>", "&omnifunc:<c-x><c-o>"]

   
   """"""""""""""""""""""""""""""
   " yank ring setting
   """"""""""""""""""""""""""""""
   let g:yankring_enabled=1
   let g:yankring_history_file='.yankring_history_file'
   map <leader>yr :YRShow<cr>

   """"""""""""""""""""""""""""""
   " file explorer setting
   """"""""""""""""""""""""""""""
   "Split vertically
   let g:explVertical=1

   "Window size
   let g:explWinSize=35

   let g:explSplitLeft=1
   let g:explSplitBelow=1

   "Hide some files
   let g:explHideFiles='^\.,.*\.class$,.*\.swp$,.*\.pyc$,.*\.swo$,\.DS_Store$'

   "Hide the help thing..
   let g:explDetailedHelp=0

   """"""""""""""""""""""""""""""
   " bufexplorer setting
   """"""""""""""""""""""""""""""
   let g:bufExplorerDefaultHelp=1       " Do not show default help.
   let g:bufExplorerShowRelativePath=1  " Show relative paths.
   let g:bufExplorerSortBy='mru'        " Sort by most recently used.
   let g:bufExplorerSplitRight=0        " Split left.
   let g:bufExplorerSplitVertical=1     " Split vertically.
   let g:bufExplorerSplitVertSize = 35  " Split width
   let g:bufExplorerUseCurrentWindow=1  " Open in new window.
   let g:bufExplorerMaxHeight=25        " Max height

   """"""""""""""""""""""""""""""
   " taglist setting
   """"""""""""""""""""""""""""""
   if MySys() == "windows"
     let Tlist_Ctags_Cmd = 'ctags'
   elseif MySys() == "linux"
     let Tlist_Ctags_Cmd = '/usr/bin/ctags'
   endif
"  yangzw, ctags
   let Tlist_Ctags_Cmd = '/usr/local/bin/ctags'
"  yangzw, NeoComplCache
   let g:NeoComplCache_EnableAtStartup = 1
"   let g:NeoComplCache_DisableAutoComplete = 1

   let Tlist_Show_One_File = 1
   let Tlist_Exit_OnlyWindow = 1
   let Tlist_Use_Right_Window = 1
   nmap <silent> <leader>tl :Tlist<cr>

   """"""""""""""""""""""""""""""
   " winmanager setting
   """"""""""""""""""""""""""""""
   let g:winManagerWindowLayout = "BufExplorer,FileExplorer|TagList"
   let g:winManagerWidth = 35
   let g:defaultExplorer = 0
   nmap <C-W><C-F> :FirstExplorerWindow<cr>
   nmap <C-W><C-B> :BottomExplorerWindow<cr>
   nmap <silent> <leader>wm :WMToggle<cr>
   autocmd BufWinEnter \[Buf\ List\] setl nonumber

   """"""""""""""""""""""""""""""
   " NERDTree setting
   """"""""""""""""""""""""""""""
   " nmap <silent> <leader>tt :NERDTreeToggle<cr>

   """"""""""""""""""""""""""""""
   " lookupfile setting
   """"""""""""""""""""""""""""""
   let g:LookupFile_MinPatLength = 2
   let g:LookupFile_PreserveLastPattern = 0
   let g:LookupFile_PreservePatternHistory = 0
   let g:LookupFile_AlwaysAcceptFirst = 1
   let g:LookupFile_AllowNewFiles = 0
   let g:LookupFile_UsingSpecializedTags = 1
   let g:LookupFile_Bufs_LikeBufCmd = 0
   let g:LookupFile_ignorecase = 1
   let g:LookupFile_smartcase = 1
   if filereadable("./filenametags")
       let g:LookupFile_TagExpr = '"./filenametags"'
   endif
   nmap <silent> <leader>lk :LUTags<cr>
   nmap <silent> <leader>ll :LUBufs<cr>
   nmap <silent> <leader>lw :LUWalk<cr>


   try
     set switchbuf=useopen
     set stal=1
   catch
   endtry

   " lookup file with ignore case
   function! LookupFile_IgnoreCaseFunc(pattern)
       let _tags = &tags
       try
           let &tags = eval(g:LookupFile_TagExpr)
           let newpattern = '\c' . a:pattern
           let tags = taglist(newpattern)
       catch
           echohl ErrorMsg | echo "Exception: " . v:exception | echohl NONE
           return ""
       finally
           let &tags = _tags
       endtry

       " Show the matches for what is typed so far.
       let files = map(tags, 'v:val["filename"]')
       return files
   endfunction
   let g:LookupFile_LookupFunc = 'LookupFile_IgnoreCaseFunc'

   """"""""""""""""""""""""""""""
   " markbrowser setting
   " not use
   """"""""""""""""""""""""""""""
   nmap <silent> <leader>mk :MarksBrowser<cr>

   """"""""""""""""""""""""""""""
   " showmarks setting
   """"""""""""""""""""""""""""""
   " Enable ShowMarks
   let showmarks_enable = 1
   " Show which marks
   let showmarks_include = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
   " Ignore help, quickfix, non-modifiable buffers
   let showmarks_ignore_type = "hqm"
   " Hilight lower & upper marks
   let showmarks_hlline_lower = 1
   let showmarks_hlline_upper = 1

   """"""""""""""""""""""""""""""
   " mark setting
   """"""""""""""""""""""""""""""
   nmap <silent> <leader>hl <Plug>MarkSet
   vmap <silent> <leader>hl <Plug>MarkSet
   nmap <silent> <leader>hh <Plug>MarkClear
   vmap <silent> <leader>hh <Plug>MarkClear
   nmap <silent> <leader>hr <Plug>MarkRegex
   vmap <silent> <leader>hr <Plug>MarkRegex

   """"""""""""""""""""""""""""""
   " FeralToggleCommentify setting
   """"""""""""""""""""""""""""""
   let loaded_feraltogglecommentify = 1
   "map <silent> <leader>tc :call ToggleCommentify()<CR>j
   "imap <M-c> <ESC>:call ToggleCommentify()<CR>j

   """"""""""""""""""""""""""""""
   " vimgdb setting
   """"""""""""""""""""""""""""""
   let g:vimgdb_debug_file = ""
   run macros/gdb_mappings.vim

   """"""""""""""""""""""""""""""
   " eclim setting
   """"""""""""""""""""""""""""""
   let g:EclimTaglistEnabled=0

   """"""""""""""""""""""""""""""
   " FSwitch setting
   """"""""""""""""""""""""""""""
   au! BufEnter *.cc,*.cpp let b:fswitchdst = 'h' | let b:fswitchlocs = '.'
   au! BufEnter *.h let b:fswitchdst = 'cc,cpp' | let b:fswitchlocs = '.'
   let g:fsnonewfiles = "on"
   nmap <silent> <Leader>of :FSHere<cr>

   """"""""""""""""""""""""""""""
   " Tagbar setting
   """"""""""""""""""""""""""""""
   let g:tagbar_width = 40
   let g:tagbar_expand = 1
   nmap <silent> <Leader>bb :TagbarToggle<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Filetype generic
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  " Todo
  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  "au BufNewFile,BufRead *.todo so ~/vim_local/syntax/amido.vim

  """"""""""""""""""""""""""""""
  " HTML related
  """"""""""""""""""""""""""""""
  " HTML entities - used by xml edit plugin
  let xml_use_xhtml = 1
  "let xml_no_auto_nesting = 1

  "To HTML
  let html_use_css = 1
  let html_number_lines = 0
  let use_xhtml = 1

  """""""""""""""""""""""""""""""
  " Vim section
  """""""""""""""""""""""""""""""
  autocmd FileType vim set nofen
  autocmd FileType vim map <buffer> <leader><space> :w!<cr>:source %<cr>

  """"""""""""""""""""""""""""""
  " HTML
  """""""""""""""""""""""""""""""
  au FileType html set ft=xml
  au FileType html set syntax=html


  """"""""""""""""""""""""""""""
  " C/C++
  """""""""""""""""""""""""""""""
  autocmd FileType c,cpp,xml,cxx  map <buffer> <leader><space> :make<cr>
  "autocmd FileType c,cpp  setl foldmethod=syntax | setl fen


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MISC
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Quickfix
nmap <leader>cn :cn<cr>
nmap <leader>cp :cp<cr>
nmap <leader>cw :cw 10<cr>
"nmap <leader>cc :botright lw 10<cr>
"map <c-u> <c-l><c-j>:q<cr>:botright cw 10<cr>

function! s:GetVisualSelection()
let save_a = @a
silent normal! gv"ay
let v = @a
let @a = save_a
let var = escape(v, '\\/.$*')
return var
endfunction

" Fast grep
nmap <silent> <leader>lv :lv /<c-r>=expand("<cword>")<cr>/ %<cr>:lw<cr>
vmap <silent> <leader>lv :lv /<c-r>=<sid>GetVisualSelection()<cr>/ %<cr>:lw<cr>

" Fast diff
"cmap @vd vertical diffsplit
set diffopt+=vertical

"Remove the Windows ^M
noremap <Leader>dm mzHmx:%s/<C-V><cr>//ge<cr>'xzt'z:delm x z<cr>


"Remove indenting on empty lines
"map <F2> :%s/\s*$//g<cr>:noh<cr>''

"Super paste
"inoremap <C-v> <esc>:set paste<cr>mui<C-R>+<esc>mv'uV'v=:set nopaste<cr>

"Fast Ex command
"nnoremap ; :

"For mark move
"nnoremap <leader>' '

"Fast copy
"nnoremap ' "

"A function that inserts links & anchors on a TOhtml export.
" Notice:
" Syntax used is:
" Link
" Anchor
function! SmartTOHtml()
  TOhtml
  try
    %s/&quot;\s\+\*&gt; \(.\+\)</" <a href="#\1" style="color: cyan">\1<\/a></g
    %s/&quot;\(-\|\s\)\+\*&gt; \(.\+\)</" \&nbsp;\&nbsp; <a href="#\2" style="color: cyan;">\2<\/a></g
    %s/&quot;\s\+=&gt; \(.\+\)</" <a name="\1" style="color: #fff">\1<\/a></g
  catch
  endtry
  exe ":write!"
  exe ":bd"
endfunction


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mark as loaded 括号相关功能
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:vimrc_loaded = 1

"" 插入匹配括号，括号自动补齐
inoremap ( ()<Esc>i
inoremap [ []<Esc>i
inoremap { {}<Esc>i
inoremap > <><Esc>i
inoremap } {<Esc>a<cr>}<Esc>ko<tab>

"" 按退格键时判断当前光标前一个字符，如果是左括号，则删除对应的右括号以及括号中间的内容
"  退格键相关
"function! RemovePairs()
"    let l:line = getline(".")
"    let l:previous_char = l:line[col(".")-1] " 取得当前光标前一个字符
"
"    if index(["(", "[", "{"], l:previous_char) != -1
"        let l:original_pos = getpos(".")
"        execute "normal %"
"        let l:new_pos = getpos(".")
"
"        " 如果没有匹配的右括号
"        if l:original_pos == l:new_pos
"            execute "normal! a\"
"            return
"        end
"
"        let l:line2 = getline(".")
"        if len(l:line2) == col(".")
"            " 如果右括号是当前行最后一个字符
"            execute "normal! v%xa"
"        else
"            " 如果右括号不是当前行最后一个字符
"            execute "normal! v%xi"
"        end
"
"    else
"        execute "normal! a\"
"    end
"endfunction
"" 用退格键删除一个左括号时同时删除对应的右括号

"inoremap :call RemovePairs()a
"
"" 输入一个字符时，如果下一个字符也是括号，则删除它，避免出现重复字符
"function! RemoveNextDoubleChar(char)
"    let l:line = getline(".")
"    let l:next_char = l:line[col(".")] " 取得当前光标后一个字符
"
"    if a:char == l:next_char
"        execute "normal! l"
"    else
"        execute "normal! i" . a:char . ""
"    end
"endfunction
"inoremap ) :call RemoveNextDoubleChar(')')a
"inoremap ] :call RemoveNextDoubleChar(']')a
"inoremap } :call RemoveNextDoubleChar('}')a



"=================================================================================================================================
" (自定义功能)写网页自动布置文件头
"=================================================================================================================================

"Enable filetype plugin
filetype plugin on
filetype indent on

" 当新建 .h .c .hpp .cpp .mk .sh等文件时自动调用SetTitle 函数
au BufRead,BufNewFile *-*-*-*.md  set filetype=wbmarkdown
autocmd BufNewFile *-*-*-*.md exec ":call SetTitle()"

au BufRead,BufNewFile readme set filetype=readmehead
autocmd BufNewFile readme exec ":call SetTitle()"


func! Setcomment_wbmarkdown()
    call setline(1,"---")
    call append(line("."),   "layout: post_layout")
    call append(line(".")+1, "title: ")
    call append(line(".")+2, "time: ".strftime("%Y年%m月%d日 星期%a"))
    call append(line(".")+3, "location: 北京")
    call append(line(".")+4, "pulished: true")
    call append(line(".")+5, "excerpt_separator: \"```\" ")
    call append(line(".")+6, "---")
    call append(line(".")+7, "")
    call append(line(".")+8, "")
    call append(line(".")+9, "")
    call append(line(".")+10, "")
    call append(line(".")+11, "<div><table align=\"right\"><td align=\"right\" bgcolor=\"#FFFFFF\" width=\"200\"><font color=\"#F0F0F0\">~~继续思考~~</font></td></table><br/>")
    call append(line(".")+12, "<table align=\"right\"><td align=\"right\" bgcolor=\"#F5F5F5\" width=\"300\"><font color=\"#000000\">-------开放研究之所以可能</font></td></table></div>")

endfunc

func! Setcomment_readmehead()
    call setline(1,"---------------------------------------------------")
    call append(line(".")+0, "title: readme")
    call append(line(".")+1, "time: ".strftime("%Y年%m月%d日 星期%a"))
    call append(line(".")+2, "update: ".strftime("%Y年%m月%d日 星期%a"))
    call append(line(".")+3, "package: ")
    call setline(6,"---------------------------------------------------")
    call append(line(".")+5, "")
endfunc

" 定义函数SetTitle，自动插入文件头
func! SetTitle()
  if &filetype == 'wbmarkdown'
    call setline(1,"")
    call Setcomment_wbmarkdown()
  elseif &filetype == 'readmehead'
    call setline(1,"")
    call Setcomment_readmehead()
  endif

endfunc



"" by yangzw, 20140104, markdown highlight
"" 杨振伟老师编辑
"au BufRead,BufNewFile *.{md,mdown,mkd,mkdn,markdown,mdwn}   set filetype=markdown
"let mapleader = ","
"nnoremap <leader>md :%!/usr/local/bin/Markdown.pl --html4tags <CR>


" 加入注释
"func SetComment()
"    call setline(1,"/*================================================================")
"    call append(line("."),   "*   Copyright (C) ".strftime("%Y")." Sangfor Ltd. All rights reserved.")
"    call append(line(".")+1, "*   ")
"    call append(line(".")+2, "*   文件名称：".expand("%:t"))
"    call append(line(".")+3, "*   创 建 者：LuZhenrong")
"    call append(line(".")+4, "*   创建日期：".strftime("%Y年%m月%d日"))
"    call append(line(".")+5, "*   描    述：")
"    call append(line(".")+6, "*")
"    call append(line(".")+7, "================================================================*/")
"    call append(line(".")+8, "")
"    call append(line(".")+9, "")
"endfunc





"    call append(line(".")+2, "*   文件名称：".expand("%:t"))
"    call append(line(".")+3, "*   创 建 者：Xiaofei Cui")
"    call append(line(".")+4, "*   创建日期：".strftime("%Y年%m月%d日"))
"    call append(line(".")+5, "*   描    述：")
"    call append(line(".")+6, "*")
"    call append(line(".")+7, "================================================================*/")
"    call append(line(".")+8, "")
"    call append(line(".")+9, "")


" 加入shell,Makefile注释
"func SetComment_sh()
"    call setline(3, "#================================================================")
"    call setline(4, "#   Copyright (C) ".strftime("%Y")." Sangfor Ltd. All rights reserved.")
"    call setline(5, "#   ")
"    call setline(6, "#   文件名称：".expand("%:t"))
"    call setline(7, "#   创 建 者：LuZhenrong")
"    call setline(8, "#   创建日期：".strftime("%Y年%m月%d日"))
"    call setline(9, "#   描    述：")
"    call setline(10, "#")
"    call setline(11, "#================================================================")
"    call setline(12, "")
"    call setline(13, "")
"endfunc





"    if &filetype == 'make'
"        call setline(1,"")
"        call setline(2,"")
"        call SetComment_sh()
"
"    elseif &filetype == 'sh'
"        call setline(1,"#!/system/bin/sh")
"        call setline(2,"")
"        call SetComment_sh()
"
"    else
"         call SetComment()
"         if expand("%:e") == 'hpp'
"          call append(line(".")+10, "#ifndef _".toupper(expand("%:t:r"))."_H")
"          call append(line(".")+11, "#define _".toupper(expand("%:t:r"))."_H")
"          call append(line(".")+12, "#ifdef __cplusplus")
"          call append(line(".")+13, "extern \"C\"")
"          call append(line(".")+14, "{")
"          call append(line(".")+15, "#endif")
"          call append(line(".")+16, "")
"          call append(line(".")+17, "#ifdef __cplusplus")
"          call append(line(".")+18, "}")
"          call append(line(".")+19, "#endif")
"          call append(line(".")+20, "#endif //".toupper(expand("%:t:r"))."_H")
"
"         elseif expand("%:e") == 'h'
"        call append(line(".")+10, "#pragma once")
"
"         elseif &filetype == 'c'
"        call append(line(".")+10,"#include \"".expand("%:t:r").".h\"")
"
"         elseif &filetype == 'cpp'
"        call append(line(".")+10, "#include \"".expand("%:t:r").".h\"")
"


"=================================================================================================================================
" (自定义功能)ctags 代码阅读辅助包还未使用
"=================================================================================================================================
" added by yangzw, for c/c++ completeness
"map <C-F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>



"=================================================================================================================================
" (自定义功能)配置Vundle包管理器
"=================================================================================================================================
if filereadable(expand("~/.vimrc_bundles"))
  source ~/.vimrc_bundles
endif






