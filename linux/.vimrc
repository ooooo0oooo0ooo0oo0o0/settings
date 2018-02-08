filetype off

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

if dein#load_state(s:dein_path)
    call dein#begin(expand('~/.vim/dein/'))

    let s:toml_path = '~/.vim/dein_toml'
    let s:toml      = s:toml_path . '/dein.toml'
    let s:lazy_toml = s:toml_path . '/dein_lazy.toml'

    call dein#load_toml(s:toml,      {'lazy': 0})
    call dein#load_toml(s:lazy_toml, {'lazy': 1})

    call dein#end()
    call dein#save_state()
endif

if dein#check_install()
    call dein#install()
endif

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
set statusline=%<%f\         " ファイルパス
set statusline+=%m           " 変更有無表示 ([+]<-こんなやつ)
set statusline+=%r           " 読み込み専用かどうかを表示
set statusline+=%h           " ヘルプページの場合はその旨表示
set statusline+=%w           " プレビューウィンドウの場合はその旨表示
set statusline+=%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'} " エンコード
set statusline+=%=           " 以降がステータス行の右側の表示設定
set statusline+=[%l/%LL:%v]  " 行/列番号
if (dein#check_install('vim-fugitive') == 0)
    " 現在のgitブランチを表示
    set statusline+=%{fugitive#statusline()}
endif
" 入力中のコマンドを表示する
set showcmd
" インクリメンタルサーチ有効
set incsearch
" tab文字等を可視化
set list
set listchars=tab:≫-,trail:-,extends:≫,precedes:≪,nbsp:%
" コマンド,検索パターンの履歴の最大数
set history=100
" 自動改行を抑止
set textwidth=0
" helpでハマる問題の対処
set notagbsearch
" helpの言語
set helplang=ja,en

" tag読み込み
au BufNewFile,BufRead *.c,*.h,*.cpp,*.hpp set tags=./tag_cxx.tags;
au BufNewFile,BufRead *.php set tags=./tag_php.tags;

" 保存時に末尾の空白を削除
autocmd BufWritePre * :%s/\s\+$//ge

" grep関連
set grepprg=grep\ -rnIH\ --exclude-dir=.svn\ --exclude-dir=.git
autocmd QuickfixCmdPost vimgrep copen
autocmd QuickfixCmdPost grep copen

" Unite関連
if (dein#check_install('unite.vim') == 0)
    let g:unite_enable_start_insert=1
    let g:unite_source_history_yank_enable =1
    let g:unite_source_file_mru_limit = 200
    " file_mruの表示フォーマットを空にすると表示スピードが高速化される(らしい)
    let g:unite_source_file_mru_filename_format = ''
endif

"==============================
" color scheme
"==============================
if (dein#check_install('molokai') == 0)
    set t_Co=256
    colorscheme molokai
    let g:molokai_original = 1
    let g:rehash256 = 1
    set background=dark
    syntax on
endif

"==============================
" 各種キーバインド
"==============================
"--------------------------
" Normal Mode
"--------------------------
" .vimrcのreload
nnoremap <Space>s :source ~/.vimrc<CR>

" PPでyankレジスタ先頭の内容を貼り付け
nnoremap PP "0p

" yankレジスタの単語に置き換え
nnoremap <Space>p diwh"0p

" tag jump関連のキーバインドあれこれ
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
nnoremap <silent> <Space>l gt
nnoremap <silent> <Space>h gT

" 文字列置換用
nnoremap <expr> <Space>r ':%s/' . expand('<cword>') . '/**/gc'

" Diff
nnoremap <expr> <Space>D ':vertical diffsplit '

" [ESC]2度押しで検索ハイライト解除
nnoremap <Esc><Esc> :noh<CR>

" 改行を含まない編集
" 1行削除
nnoremap <Space>d 0v$hx
" 1行yank
nnoremap <Space>y 0v$hy

" grep関連
nnoremap <expr> <Space>g ':vimgrep /\<'.expand('<cword>').'\>/j **/*.'.expand('%:e')
nnoremap <expr> <Space>G ':sil grep! '.expand('<cword>').' *'

" Unite関連
if (dein#check_install('unite.vim') == 0)
    " outline解析表示
    nnoremap <silent> <Space>o :<C-u>Unite -vertical -winwidth=50 outline<CR><ESC>
    " 他、諸々のUnite関連キーバインド
    nnoremap <silent> ,uy :<C-u>Unite history/yank<CR><ESC>
    nnoremap <silent> ,ub :<C-u>Unite buffer<CR><ESC>
    nnoremap <silent> ,uf :<C-u>UniteWithBufferDir -buffer-name=files file file/new<CR><ESC>
    nnoremap <silent> ,ur :<C-u>Unite -buffer-name=register register<CR><ESC>
    nnoremap <silent> ,um :<C-u>Unite file_mru buffer<CR><ESC>
    nnoremap <silent> ,up :<C-u>Unite file_rec/async:!<CR><ESC>
endif

"--------------------------
" Insert Mode
"--------------------------
" jjでインサートモード -> ノーマルモード
inoremap <silent> jj <ESC>

" 閉じ括弧の自動補完
inoremap {<Enter> {}<Left><CR><ESC><S-o>
inoremap (<Enter> ()<Left><CR><ESC><S-o>

"--------------------------
" Command Mode
"--------------------------
" Emacs風操作をパクる
cnoremap <C-a> <Home>
cnoremap <C-e> <End>

