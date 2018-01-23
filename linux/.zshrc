#########################################
# 基本設定
#########################################
# 色を使用
autoload -Uz colors && colors

# プロンプト表示方法
PROMPT="%(?.%F{107}.%F{202})[%n@%C] %f"
RPROMPT='%F{208}%d'

# キーバインド("vi" or "emacs")
KEY_BIND="vi"

if [ "${KEY_BIND}" = "vi" ]; then
  ##############
  # viキーバインド
  ##############
  bindkey -v

  # viのモードをプロンプトに表示する
  function zle-line-init zle-keymap-select {
      VIM_NORMAL="%F{081}[NORMAL] %F{208}%d"
      VIM_INSERT="%F{184}[INSERT] %F{208}%d"
      RPS1="${${KEYMAP/vicmd/$VIM_NORMAL}/(main|viins)/$VIM_INSERT}"
      RPS2=$RPS1
      zle reset-prompt
  }
  zle -N zle-line-init
  zle -N zle-keymap-select

  # jjでインサートモード -> ノーマルモード
  bindkey -M viins 'jj' vi-cmd-mode

  # 一部のemacsキーバインドを模倣
  bindkey -M viins '^S'  history-incremental-pattern-search-forward
  bindkey -M viins '^R'  history-incremental-pattern-search-backward
  bindkey -M viins '^A'  beginning-of-line
  bindkey -M viins '^E'  end-of-line
  bindkey -M viins '^U'  backward-kill-line
  bindkey -M viins '^W'  backward-kill-word
else
  ##############
  # emacsキーバインド
  ##############
  bindkey -e
fi
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
autoload -Uz compinit && compinit

# 補完候補が複数の場合に一覧表示
setopt auto_menu

# "="以降も補完
setopt magic_equal_subst

# メニュー補完設定
zmodload zsh/complist
zstyle ':completion:*' menu select=2
zstyle ':completion:*' list-colors "${LS_COLORS}"
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'n' accept-and-infer-next-history
# tab押下で即時にlist選択したい場合は以下を有効化する(不便なので無効化)
#setopt menu_complete

# 中間生成物を補完候補から外す
zstyle ':completion:*:*files' ignored-patterns '*?.o' '*?~' '*\#'

# gitの補完を高速化
GIT_VERSION=$(git --version | sed -e "s/git version //" | awk -F. '{printf "%2d%02d%02d", $1,$2,$3}')
if [ $GIT_VERSION -ge 10801 ]; then
  # version 1.8.1以降は"git-completion.zsh"の利用が可能
  zstyle ':completion:*:*:git:*' script ~/.git-completion.zsh
else
  # やっつけで、ver1.7.1から抜いた"git-completion.bash"を利用
  autoload -Uz bashcompinit && bashcompinit
  source ~/.git-completion.bash
fi

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
# 基本alias
alias l='ls -lsa'
alias v=vim
alias vi=vim
alias vz='vim ~/.zshrc'
alias ...='cd ../..'

# git関連
alias ga='git add -u'
alias gb='git branch'
alias gc='git checkout'
alias gcm='git commit'
alias gcma='git commit --amend'
alias gd='git diff'
alias gg='git status'
alias gl='git log --stat'
alias gm='git merge --no-ff'
alias gp='git pull'
alias gs='git show'

#########################################
# 他
#########################################
# .zshrc更新時に自動compile。
# 尚、最初に"zcompile ~/.zshrc"を一度実行しておかないと動作しない。
if [ ~/.zshrc -nt ~/.zshrc.zwc ]; then
   zcompile ~/.zshrc
fi
