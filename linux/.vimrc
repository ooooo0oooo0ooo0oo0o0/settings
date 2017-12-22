filetype off

"==============================
" 各種オプションの設定
"==============================
" タブ文字の表示幅
set tabstop=4
" タブ入力を複数の空白入力に置き換える
set expandtab
" Vimが挿入するインデントの幅
set shiftwidth=4
" 自動インデント
set autoindent
" スワップファイルは使わない
set noswapfile
" 行番号表示
set number
" 文字列が右端に達しても折り返さない
set nowrap
" 上端/下端から指定行数分の視界を確保
set scrolloff=5
" ウインドウのタイトルバーにファイルのパス情報等を表示
set title
" コマンドラインに使われる画面上の行数
set cmdheight=2
" エディタウィンドウの末尾から2行目にステータスラインを常時表示させる
set laststatus=2
" ステータス行に表示させる情報
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P
" 入力中のコマンドを表示する
set showcmd
" tab文字等を可視化
set list
set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:%

" tag読み込み
set tags=./tags;

" helpでハマる問題の対処
set notagbsearch

" helpの言語
set helplang=ja,en

" 保存時に末尾の空白を削除
autocmd BufWritePre * :%s/\s\+$//ge

"==============================
" plugin管理
"==============================
let s:dein_path = expand('~/.vim/dein')
let s:dein_repo_path = s:dein_path . '/repos/github.com/Shougo/dein.vim'

if !isdirectory(s:dein_repo_path)
    " deinがインストールされていない場合はclone
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_path
endif

execute 'set runtimepath^=' . s:dein_repo_path

call dein#begin(expand('~/.vim/dein/'))

" dein本体
call dein#add('Shougo/dein.vim')

" build等の非同期処理実行pulugin
call dein#add('Shougo/vimproc.vim', {'build': 'make'})

" Unite関連plugin
call dein#add('Shougo/unite.vim')
call dein#add('Shougo/neoyank.vim')
call dein#add('Shougo/neomru.vim')
call dein#add('Shougo/unite-outline')

" 文字列補完系plugin
call dein#add('Shougo/neocomplcache')
call dein#add('Shougo/neosnippet')
call dein#add('Shougo/neosnippet-snippets')

" Git操作関連plugin
call dein#add('airblade/vim-gitgutter')
call dein#add('tpope/vim-fugitive')

" visualモードでの'*'を利用可能にするplugin
call dein#add('nelstrom/vim-visual-star-search')

" 括弧等の操作
call dein#add('tpope/vim-surround')

" 全角スペースを表示
call dein#add('thinca/vim-zenspace')

" 日本語Help
call dein#add('vim-jp/vimdoc-ja')

" color scheme
call dein#add('tomasr/molokai')

call dein#end()

if dein#check_install()
  call dein#install()
endif

" ステータス行に現在のgitブランチを表示(fugitiveが存在する場合のみ)
if isdirectory(expand('~/.vim/dein/repos/github.com/tpope/vim-fugitive/'))
  set statusline+=%{fugitive#statusline()}
endif

"==============================
" color scheme
"==============================
set t_Co=256
colorscheme molokai
let g:molokai_original = 1
let g:rehash256 = 1
set background=dark
syntax on

"==============================
" 各種キーバインド
"==============================
" jjでインサートモード -> ノーマルモード
inoremap <silent> jj <ESC>
inoremap <silent> っｊ <ESC>

" PPでyankレジスタ先頭の内容を貼り付け
noremap PP "0p

" yankレジスタの単語に置き換え
noremap <Space>p diwh"0p

" tag関連
" [tag jump] カーソルの単語の定義先にジャンプ（複数候補はリスト表示）
nnoremap tj :exe("tjump ".expand('<cword>'))<CR>
" [tag back] tag stack を戻る
nnoremap tb :pop<CR>
" [tag next] tag stack を進む
nnoremap tn :tag<CR>
" [tag vertical] 縦にウィンドウを分割してジャンプ
nnoremap tv :vsp<CR> :exe("tjump ".expand('<cword>'))<CR>
" [tag horizon] 横にウィンドウを分割してジャンプ
nnoremap th :split<CR> :exe("tjump ".expand('<cword>'))<CR>
" [tag tab] 新しいタブでジャンプ
nnoremap tt :tab sp<CR> :exe("tjump ".expand('<cword>'))<CR>
" [tags list] tag list を表示
nnoremap tl :ts<CR>

" tab移動(左右)
nnoremap <silent> <space>l gt
nnoremap <silent> <space>h gT
"nnoremap <silent> <C-l> gt
"nnoremap <silent> <C-h> gT

" outline解析表示
nnoremap <silent> <space>o :<C-u>Unite -vertical -winwidth=50 outline<CR><ESC>

" Unite関連
let g:unite_enable_start_insert=1
let g:unite_source_history_yank_enable =1
let g:unite_source_file_mru_limit = 200
" file_mruの表示フォーマットを指定。空にすると表示スピードが高速化される(らしい)
let g:unite_source_file_mru_filename_format = ''

nnoremap <silent> ,uy :<C-u>Unite history/yank<CR><ESC>
nnoremap <silent> ,ub :<C-u>Unite buffer<CR><ESC>
nnoremap <silent> ,uf :<C-u>UniteWithBufferDir -buffer-name=files file<CR><ESC>
nnoremap <silent> ,ur :<C-u>Unite -buffer-name=register register<CR><ESC>
nnoremap <silent> ,um :<C-u>Unite file_mru buffer<CR><ESC>
nnoremap <silent> ,up :<C-u>Unite file_rec/async:!<CR><ESC>

" 閉じ括弧の自動補完
inoremap {<Enter> {}<Left><CR><ESC><S-o>
inoremap (<Enter> ()<Left><CR><ESC><S-o>

" grep関連
set grepprg=grep\ -rnIH\ --exclude-dir=.svn\ --exclude-dir=.git
autocmd QuickfixCmdPost vimgrep copen
autocmd QuickfixCmdPost grep copen
nnoremap <expr> <Space>g ':vimgrep /\<' . expand('<cword>') . '\>/j **/*.' . expand('%:e')
nnoremap <expr> <Space>G ':sil grep! ' . expand('<cword>') . ' *'

" 文字列置換用
nnoremap <expr> <Space>r ':%s/' . expand('<cword>') . '/**/gc'

" Diff
nnoremap <expr> <Space>D ':vertical diffsplit '

" 改行を含まない編集
" 1行削除
noremap <Space>d 0v$hx
" 1行yank
noremap <Space>y 0v$hy

