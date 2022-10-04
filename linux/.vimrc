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
"--------------------------
" Vim標準
"--------------------------
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
" 入力中のコマンドを表示する
set showcmd
" インクリメンタルサーチ有効
set incsearch
" highlightサーチ有効
set hlsearch
" コマンド,検索パターンの履歴の最大数
set history=100
" 自動改行を抑止
set textwidth=0
" <>も対応括弧対象にする
set matchpairs& matchpairs+=<:>
" helpでハマる問題の対処
set notagbsearch
" helpの言語
set helplang=ja,en
" 各種文字コード
scriptencoding utf-8
set encoding=utf-8
set fenc=utf-8
set fileencoding=utf-8
set fileformats=unix,dos,mac

" tab文字等を可視化
set list
set listchars=tab:≫-,trail:-,extends:≫,precedes:≪,nbsp:%

" tag読み込み
au BufNewFile,BufRead *.c,*.h,*.cpp,*.hpp set tags=./tag_cxx.tags;
au BufNewFile,BufRead *.php set tags=./tag_php.tags;

" 保存時に末尾の空白を削除
autocmd BufWritePre * :%s/\s\+$//ge

"--------------------------
" vim-fugitive
"--------------------------
if (dein#check_install('vim-fugitive') == 0)
    " 現在のgitブランチを表示
    set statusline+=%{fugitive#statusline()}
endif

"--------------------------
" vim-zenspace
"--------------------------
" 全角spaceの色設定
if (dein#check_install('vim-zenspace') == 0)
    augroup vimrc-highlight
      autocmd!
      autocmd ColorScheme * highlight ZenSpace ctermbg=darkgray guibg=darkgray
    augroup END
endif

"--------------------------
" Unite
"--------------------------
if (dein#check_install('unite.vim') == 0)
    let g:unite_enable_start_insert=1
    let g:unite_source_history_yank_enable =1
    let g:unite_source_file_mru_limit = 200
    " file_mruの表示フォーマットを空にすると表示スピードが高速化される(らしい)
    let g:unite_source_file_mru_filename_format = ''
endif

"--------------------------
" denops
"--------------------------
if (dein#check_install('denops.vim') == 0)
    " Vim 8.2.3452以上じゃないとdenops.vimは使えんとの事...
    " その旨の警告PUを無効化しておく。
    let g:denops_disable_version_check=1
endif

"--------------------------
" ddc.vim
"--------------------------
if (dein#check_install('ddc.vim') == 0)

    " Use Popup Menu
    call ddc#custom#patch_global('completionMenu', 'pum.vim')

    " Use around source.
    " https://github.com/Shougo/ddc-around
    call ddc#custom#patch_global('sources', ['around'])

    " Use matcher_head and sorter_rank.
    " https://github.com/Shougo/ddc-matcher_head
    " https://github.com/Shougo/ddc-sorter_rank
    call ddc#custom#patch_global('sourceOptions', {
          \ '_': {
          \   'matchers': ['matcher_head'],
          \   'sorters': ['sorter_rank']},
          \   'converters': ['converter_remove_overlap'],
          \ })

    " Change source options
    call ddc#custom#patch_global('sourceOptions', {
          \ 'around': {'mark': 'Around'},
          \ })
    call ddc#custom#patch_global('sourceParams', {
          \ 'around': {'maxSize': 500},
          \ })

    " Customize settings on a filetype
    call ddc#custom#patch_filetype(['c', 'cpp'], 'sources', ['around', 'clangd'])
    call ddc#custom#patch_filetype(['c', 'cpp'], 'sourceOptions', {
          \ 'clangd': {'mark': 'C'},
          \ })
    call ddc#custom#patch_filetype('markdown', 'sourceParams', {
          \ 'around': {'maxSize': 100},
          \ })

    " <TAB>: completion.
    inoremap <silent><expr> <TAB>
    \ ddc#map#pum_visible() ? '<C-n>' :
    \ (col('.') <= 1 <Bar><Bar> getline('.')[col('.') - 2] =~# '\s') ?
    \ '<TAB>' : ddc#map#manual_complete()

    " <S-TAB>: completion back.
    inoremap <expr><S-TAB>  ddc#map#pum_visible() ? '<C-p>' : '<C-h>'

    " Use ddc.
    call ddc#enable()
endif

"==============================
" color scheme
"==============================
" 選択可能なcolor scheme
let scheme_list = {
    \ '1' : 'molokai',
    \ '2' : 'Alduin',
    \ '3' : 'moonshine-vim'
\}

" color schemeを変更したい場合はここを変える
let color_scheme = scheme_list['1']

if color_scheme ==# scheme_list['1']
    " molokai
    if (dein#check_install(color_scheme) == 0)
        colorscheme molokai
        let g:molokai_original = 1
        let g:rehash256 = 1
        set background=dark

        " 気になる色を変更
        autocmd ColorScheme * highlight StatusLine ctermbg=023
        syntax on
    endif
elseif color_scheme ==# scheme_list['2']
    " Alduin
    if (dein#check_install(color_scheme) == 0)
        let g:alduin_Shout_Dragon_Aspect = 1
        "let g:alduin_Shout_Become_Ethereal = 1
        "let g:alduin_Shout_Fire_Breath = 1
        colorscheme alduin

        " 気になる色を変更
        autocmd ColorScheme * highlight Visual     ctermfg=007 ctermbg=023
        autocmd ColorScheme * highlight CursorLine ctermbg=023
        syntax on
    endif
elseif color_scheme ==# scheme_list['3']
    " moonshine-vim
    if (dein#check_install(color_scheme) == 0)
        colorscheme moonshine
        "colorscheme moonshine_minimal
        "colorscheme moonshine_lowcontrast

        " 気になる色を変更
        autocmd ColorScheme * highlight Todo     ctermfg=222 ctermbg=238 guibg=Magenta
        autocmd ColorScheme * highlight Visual   ctermfg=239
        autocmd ColorScheme * highlight ErrorMsg ctermbg=178
        syntax on
    endif
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

" grep
nnoremap <expr> <Space>g ':Rg '.expand('<cword>')

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

