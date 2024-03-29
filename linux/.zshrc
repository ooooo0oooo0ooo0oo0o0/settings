#########################################
# 基本設定
#########################################
# 色を使用
autoload -Uz colors && colors

# プロンプト表示方法
COMMON_PROMPT=$'%(?.%{\e[38;5;076m%}.%{\e[38;5;009m%})[%n@%C] %{\e[0m%}'
RPROMPT=$'%{\e[38;5;222m%}%d%{\e[0m%}'

# キーバインド("vi" or "emacs")
ZSH_KEY_BIND="vi"

if [ "${ZSH_KEY_BIND}" = "vi" ]; then
    ##############
    # viキーバインド
    ##############
    bindkey -v

    #### 以下、viのモードをプロンプトに表示する為のあれこれ
    autoload -Uz add-zsh-hook
    autoload -Uz terminfo

    terminfo_down_sc=$terminfo[cud1]$terminfo[cuu1]$terminfo[sc]$terminfo[cud1]
    left_down_prompt_preexec() {
        print -rn -- $terminfo[el]
    }
    add-zsh-hook preexec left_down_prompt_preexec

    INSERT_TXT=$'%{\e[38;05;080m%}-- INSERT --%{\e[0m%}'
    NORMAL_TXT=$'%{\e[38;05;220m%}-- NORMAL --%{\e[0m%}'

    # 初回表示用プロンプト(insertモード)
    PROMPT="%{$terminfo_down_sc$INSERT_TXT$terminfo[rc]%}$COMMON_PROMPT"

    # モード切り替え毎にプロンプト表示を切り替える
    function zle-keymap-select zle-line-init zle-line-finish
    {
        case $KEYMAP in
            main|viins)
                PROMPT_2=$INSERT_TXT
                ;;
            vicmd)
                PROMPT_2=$NORMAL_TXT
                ;;
        esac

        PROMPT="%{$terminfo_down_sc$PROMPT_2$terminfo[rc]%}$COMMON_PROMPT"
        zle reset-prompt
    }
    zle -N zle-line-init
    zle -N zle-line-finish
    zle -N zle-keymap-select
    zle -N edit-command-line

    # 一部のemacsキーバインドを模倣 (incremental searchはfzfに委ねる)
    #bindkey -M viins '^S'  history-incremental-pattern-search-forward
    #bindkey -M viins '^R'  history-incremental-pattern-search-backward
    bindkey -M viins '^A'  beginning-of-line
    bindkey -M viins '^E'  end-of-line
    bindkey -M viins '^U'  backward-kill-line
    bindkey -M viins '^W'  backward-kill-word
else
    ##############
    # emacsキーバインド
    ##############
    bindkey -e
    PROMPT=$COMMON_PROMPT
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
    # ver1.7.1から抜いた"git-completion.bash"を利用
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
alias l='ls -lsa --color=auto'
alias tree='pwd;find . | sort | sed '\''1d;s/^\.//;s/\/\([^/]*\)$/|--\1/;s/\/[^/|]*/|  /g'\'''
alias v=vim
alias vi=vim
alias vz='vim ~/.zshrc'
alias vv='vim ~/.vimrc'
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
alias gr='git reset --hard HEAD'
alias gs='git show'

#########################################
# 環境変数
#########################################
# DENO(JS runtime)関連
export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

#########################################
# 他
#########################################
# .zshrc更新時に自動compile。
# 尚、最初に"zcompile ~/.zshrc"を一度実行しておかないと動作しない。
if [ ~/.zshrc -nt ~/.zshrc.zwc ]; then
    zcompile ~/.zshrc
fi

# fzf初期化
if [ -e ~/.fzf/bin/fzf ]; then
    [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
else
    # 未install時は、installした後にもう一度zshrcを読み込む
    git clone https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
fi

# fzf版history search
function select-history() {
  BUFFER=$(history -n -r 1 | fzf --no-sort +m --query "$LBUFFER" --prompt="History > ")
  CURSOR=$#BUFFER
}
zle -N select-history
bindkey '^r' select-history
