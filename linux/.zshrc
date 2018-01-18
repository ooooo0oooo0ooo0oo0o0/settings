#########################################
# 基本設定
#########################################
# 色を使用
autoload -Uz colors
colors

# プロンプト表示方法
PROMPT="%(?.%F{107}.%F{202})[%n@%C] %f"

# ひとまずemacsモード
bindkey -e

#########################################
# 各種Option
#########################################
# ctrl+d でのlogout抑制
setopt ignoreeof

# ctrl+s or q によるフロー制御を抑止
setopt no_flow_control

# 日本語ファイルを表示可能にする
setopt print_eight_bit

# beep無効化
setopt no_beep

# ディレクトリ名だけでcdする
setopt auto_cd

# cdしたら自動でpushd(重複は抑制する)
setopt auto_pushd
setopt pushd_ignore_dups
DIRSTACKSIZE=100

# コマンドラインにて#以降をコメントと見做す
setopt interactive_comments

#########################################
# 補完系設定
#########################################
# 補完機能を有効化
autoload -Uz compinit
compinit

# 補完候補が複数の場合に一覧表示
setopt auto_menu

# "="以降も補完
setopt magic_equal_subst

# メニュー補完設定
zmodload zsh/complist
zstyle ':completion:*' menu select=2
zstyle ':completion:*' list-colors "${LS_COLORS}"
setopt menu_complete
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'n' accept-and-infer-next-history

# 中間生成物を補完候補から外す
zstyle ':completion:*:*files' ignored-patterns '*?.o' '*?~' '*\#'
bindkey '^r' history-incremental-search-backward

#########################################
# history系設定
#########################################
# historyファイル設定
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# 同じコマンドをhistoryに残さない
setopt hist_ignore_all_dups
setopt hist_save_nodups

# historyコマンドを履歴に残さない
setopt hist_no_store

# history保存時の余計なスペース削除
setopt hist_reduce_blanks

# スペースから始まるコマンドはhistoryに残さない
setopt hist_ignore_space

# 同時起動中のzsh間でhistoryを共有
setopt share_history

#########################################
# 各種Alias
#########################################
alias l='ls -lsa'
alias v=vim
alias vi=vim
alias vz='vim ~/.zshrc'
alias p=pwd

#########################################
# 他
#########################################
# .zshrc更新時に自動compile。
# 尚、最初に"zcompile ~/.zshrc"を一度実行しておかないと動作しない。
if [ ~/.zshrc -nt ~/.zshrc.zwc ]; then
   zcompile ~/.zshrc
fi
