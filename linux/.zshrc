#########################################
# 基本設定
#########################################
# 言語設定
export LANG=ja_JP.UTF-8

# 環境変数
export PATH="$HOME/bin:$PATH"

# 色を使用
autoload -Uz colors
colors

# プロンプト表示方法
PROMPT="%F{107}[%n@%C] %f"

# 補完機能を有効化
autoload -Uz compinit
compinit

# historyファイル設定
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

#########################################
# 各種Option
#########################################
# ctrl+d でのlogout抑制
setopt IGNOREEOF

# 日本語ファイルを表示可能にする
setopt print_eight_bit

# beep無効化
setopt no_beep

# ディレクトリ名だけでcdする
setopt auto_cd

# cdしたら自動でpushd
setopt auto_pushd
DIRSTACKSIZE=100

# 重複したディレクトリをpushdしない
setopt pushd_ignore_dups

# 同じコマンドをhistoryに残さない
setopt hist_save_nodups

# history保存時の余計なスペース削除
setopt hist_reduce_blanks

# 補完候補が複数の場合に一覧表示
setopt auto_menu

#########################################
# 各種Alias
#########################################
alias ll='ls -lsa'
alias v=vim
alias vi=vim
alias vz='vim ~/.zshrc'
