" ---------------------------------------------------------------------------
" General
" ---------------------------------------------------------------------------

call pathogen#runtime_append_all_bundles()    " using pathogen for a bunch of plugins
set nocompatible
let mapleader = ","
set history=1000                              " lots of command line history
filetype plugin indent on                     " load filetype plugin
"set viminfo='10,\"100,:20,%,n~/.viminfo       " remember certain things when we exit
set autoread                                  " reload files changed outside of Vim
set autowrite                                 " some commands should cause an automatic write
set title                                     " sets the title of the terminal based on filename
filetype plugin on

" use Y to yank the rest of the line
map Y y$

" ---------------------------------------------------------------------------- 
"  UI 
" ---------------------------------------------------------------------------- 
set number                            " show line numbers
set ruler                             " show the cursor position all the time 
set backspace=start,indent,eol        " allow backspacing over anything in insert mode 
set guioptions=eg                     " disable scrollbars, etc
set wm=2                              " wrap margin on the right

" ----------------------------------------------------------------------------
"  Visual cues
" ----------------------------------------------------------------------------
set incsearch               " do incremental searching
"set nohlsearch              " don't highlight searches
set laststatus=2            " always show the status line
set visualbell              " quiet
set noerrorbells            " quiet

" ----------------------------------------------------------------------------
"  Text formatting
" ----------------------------------------------------------------------------
set autoindent             " automatically indent new lines
set expandtab              " expand tabs to spaces
set nosmarttab             " no tabs, thanks.
set nowrap                 " do not wrap lines
set softtabstop=2          " yerp
set shiftwidth=2
set tabstop=4

set foldmethod=indent
set foldlevelstart=100
nnoremap <Space> za
" ----------------------------------------------------------------------------
"  Backups
" ----------------------------------------------------------------------------
set nobackup                           " do not keep backups after close
set nowritebackup                      " do not keep a backup while working
set noswapfile                         " don't keep swp files either
"set backupdir=~/.vim/backups           " store backups under ~/.vim/backup
"set backupcopy=yes                     " keep attributes of original file
"set backupskip=/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*
"set directory=~/.vim/tmp               " where to keep swp files

" ---------------------------------------------------------------------------
" Mappings
" ---------------------------------------------------------------------------

" unhighlight searches on hitting enter
nnoremap <CR> :nohlsearch<cr>

" because what does :W do?
" map :W :w

" setting working path
map <leader>cd :cd %:p:h<CR>

" move between windows
map <C-J> <C-W>j
map <C-K> <C-W>k
map <C-H> <C-W>h
map <C-L> <C-W>l

" method navigation
map <leader>j ]m
map <leader>J ]M
map <leader>k [m
map <leader>K [M

" edit vimrc
map <leader>v :sp ~/.vimrc<CR><C-W>_
map <leader>V :source ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>

" command-t plugin
silent! nmap <unique> <silent> <Leader>f :CommandT<CR>
map <leader>F :CommandTFlush<CR>
set wildignore+=orders/**,groupon-web/**,vendor/gems/**,vendor/plugins/**,vendor/linked_gems/**,vendor/rails/**,coverage/**

" ack shortcuts
"map <leader>S :Ack<cword><CR>
"map <leader>s :Ack<Space>

" switch between a symbol and a string
nmap <leader>" bbr"ea"<Esc>
nmap <leader>: bhs:<Esc>wwx

" ctags shortcuts
nmap <C-\> <C-]>
nmap g<C-\> g<C-]>

" insert hash rocket
imap <C-l> <Space>=><Space>

" paste the last thing really yanked rather than deleted.  Useful for 
" repeatedly replacing some text with something previously yanked.
vmap <leader>P "0p

" ---------------------------------------------------------------------------
"  rspec shortcuts
" ---------------------------------------------------------------------------
function! RunCucTests()
  " Write the file and run tests for the given filename
  :w
  :silent !echo;echo;echo;echo;echo
  exec ":! rake cucumber"
endfunction

function! RunTests(filename)
  " Write the file and run tests for the given filename
  :w
  :silent !echo;echo;echo;echo;echo
  echo ":! rspec " . a:filename
  exec ":! rspec " . a:filename
endfunction
      
function! SetTestFile()
  " Set the spec file that tests will be run for.
  let t:grb_test_file=@%
endfunction
      
function! RunTestFile(...)
  if a:0
    let command_suffix = a:1
  else
    let command_suffix = ""
  endif

  "Run the tests for the previously-marked file.
  let in_spec_file = match(expand("%"), '_spec.rb$') != -1
  if in_spec_file
    call SetTestFile()
  elseif !exists("t:grb_test_file")
    return
  end
  call RunTests(t:grb_test_file .  command_suffix)
endfunction

function! RunNearestTest()
  let spec_line_number =  line('.')
  call  RunTestFile(":" .  spec_line_number)
endfunction

" Run this file
map <leader>t :call RunTestFile()<cr>
" Run only the example under the cursor
map <leader>T :call RunNearestTest()<cr>
" Run all test files
map <leader>a :call RunTests('spec')<cr>
" Run all cucumber test files
map <leader>c :call RunCucTests()<cr>



" ---------------------------------------------------------------------------
"  rails.vim plugin mappings
" ---------------------------------------------------------------------------
nmap <leader>r :Rake<CR>
nmap <leader>R :.Rake<CR>

nmap <leader><leader>c :Rcontroller 
nmap <leader><leader>m :Rmodel 
nmap <leader><leader>v :Rview 
nmap <leader><leader>h :Rhelper 
nmap <leader><leader>i :Rinitializer 
nmap <leader><leader>e :Renvironment 
nmap <leader><leader>l :Rlib 
nmap <leader><leader>f :Rfeature 
nmap <leader><leader>u :Runittest 
nmap <leader><leader>j :Rjavascript 
nmap <leader><leader>t :Rtask 
nmap <leader><leader>r :Rspec 


" ---------------------------------------------------------------------------
"  rails.vim autocommands
" ---------------------------------------------------------------------------
autocmd User Rails silent! Rnavcommand feature features                  -glob=* -suffix=.feature
autocmd User Rails silent! Rnavcommand steps   features/step_definitions -glob=* -suffix=_steps.rb


" ---------------------------------------------------------------------------
"  Status line customization
" ---------------------------------------------------------------------------
set statusline=
set statusline+=%-3.3n\                      " buffer number
set statusline+=%f\                          " filename
set statusline+=%h%m%r%w                     " status flags
set statusline+=\[%{strlen(&ft)?&ft:'none'}] " file type
"set statusline+=\ %{fugitive#statusline()}   " fugitive
set statusline+=%=                           " right align remainder
set statusline+=%-14(%l,%c%V%)               " line, character
set statusline+=%<%P                         " file position


" ---------------------------------------------------------------------------
"  Command-t customization
" ---------------------------------------------------------------------------
let g:CommandTMaxFiles=20000
let g:CommandTMaxHeight=15


" ---------------------------------------------------------------------------
"  Colors/Theme
" ---------------------------------------------------------------------------
:set t_Co=256
colorscheme eddie
syntax on


" ---------------------------------------------------------------------------
"  Surround plugin - allow # to be used for string interpolation.
" ---------------------------------------------------------------------------
autocmd FileType ruby let g:surround_113 = "#{\r}"   " v
autocmd FileType ruby let g:surround_35  = "#{\r}"   " #


" ---------------------------------------------------------------------------
"  Misc stuff
" ---------------------------------------------------------------------------
set clipboard+=unnamed
set grepprg=ack
set grepformat=%f:%l:%m

set completeopt=longest,menu,preview        " insert mode comletion options
set complete=.
set lines=79 columns=272

" Write all named, changed buffers when Vim loses focus
au FocusLost * :wall

augroup myfiletypes
  "clear old autocmds in group
  autocmd!    
  
  "for ruby, autoindent with two spaces, always expand tabs
  autocmd FileType ruby,haml,eruby,yaml set ai sw=2 sts=2 et     
augroup END

augroup markdown
  autocmd BufRead *.markdown  set ai formatoptions=tcroqn2 comments=n:>
  set wrap
  set linebreak
  set nolist
  set formatoptions+=1
augroup END

augroup god
  autocmd BufRead *.god set filetype=ruby
augroup END

let g:liquid_highlight_types=["html","erb=eruby","html+erb=eruby.html"]


" ---------------------------------------------------------------------------
"  Jump to last saved position of buffer when re-opening
" ---------------------------------------------------------------------------
augroup JumpCursorOnEdit
 au!
 autocmd BufReadPost *
 \ if expand("<afile>:p:h") !=? $TEMP |
 \ if line("'\"") > 1 && line("'\"") <= line("$") |
 \ let JumpCursorOnEdit_foo = line("'\"") |
 \ let b:doopenfold = 1 |
 \ if (foldlevel(JumpCursorOnEdit_foo) > foldlevel(JumpCursorOnEdit_foo - 1)) |
 \ let JumpCursorOnEdit_foo = JumpCursorOnEdit_foo - 1 |
 \ let b:doopenfold = 2 |
 \ endif |
 \ exe JumpCursorOnEdit_foo |
 \ endif |
 \ endif
 " Need to postpone using "zv" until after reading the modelines.
 autocmd BufWinEnter *
 \ if exists("b:doopenfold") |
 \ exe "normal zv" |
 \ if(b:doopenfold > 1) |
 \ exe "+".1 |
 \ endif |
 \ unlet b:doopenfold |
 \ endif
augroup END

if $TERM == 'screen'
  set term=xterm
endif

" ---------------------------------------------------------------------------
"  Operate on indent levels.  Awesomeness.
" ---------------------------------------------------------------------------
onoremap <silent>ai :<C-u>cal IndTxtObj(0)<CR>
onoremap <silent>ii :<C-u>cal IndTxtObj(1)<CR>
vnoremap <silent>ai :<C-u>cal IndTxtObj(0)<CR><Esc>gv
vnoremap <silent>ii :<C-u>cal IndTxtObj(1)<CR><Esc>gv

function! IndTxtObj(inner)
  if &filetype == 'haml' || &filetype == 'sass' || &filetype == 'python'
    let meaningful_indentation = 1
  else
    let meaningful_indentation = 0
  endif
  let curline = line(".")
  let lastline = line("$")
  let i = indent(line(".")) - &shiftwidth * (v:count1 - 1)
  let i = i < 0 ? 0 : i
  if getline(".") =~ "^\\s*$"
    return
  endif
  let p = line(".") - 1
  let nextblank = getline(p) =~ "^\\s*$"
  while p > 0 && (nextblank || indent(p) >= i )
    -
    let p = line(".") - 1
    let nextblank = getline(p) =~ "^\\s*$"
  endwhile
  if (!a:inner)
    -
  endif
  normal! 0V
  call cursor(curline, 0)
  let p = line(".") + 1
  let nextblank = getline(p) =~ "^\\s*$"
  while p <= lastline && (nextblank || indent(p) >= i )
    +
    let p = line(".") + 1
    let nextblank = getline(p) =~ "^\\s*$"
  endwhile
  if (!a:inner && !meaningful_indentation)
    +
  endif
  normal! $
endfunction

"-------------------------
"   Some extra settings
"-------------------------

"autocmd User Rails Rnavcommand fabricator spec/fabricators -suffix=_fabricator.rb -default=model()
"
" Remap the tab key to do autocompletion or indentation depending on the
" context (from http://www.vim.org/tips/tip.php?tip_id=102)
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k'
        return "\<tab>"
    else
        return "\<c-p>"
    endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>

function! PromoteToLet()
  :normal! dd
  :normal! P
  :.s/\(\w\+\) = \(.*\)$/let(:\1) { \2 }/
  :normal ==
endfunction
:command! PromoteToLet :call PromoteToLet()
:map <leader>p :PromoteToLet<cr>


vmap <C-c> y:call system("pbcopy", getreg("\""))<CR>
nmap <C-v> :call setreg("\"",system("pbpaste"))<CR>p

set tags+=gems.tags
:au FocusLost * :wa
