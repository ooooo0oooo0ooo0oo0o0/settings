#########################################
# 全体設定
#########################################

# 言語設定
export LANG=ja_JP.UTF-8

# 環境変数(tmux上でのzsh起動時はスルー)
if [ -z $TMUX ]; then
  export PATH="${HOME}/bin:${PATH}"
fi

# 念の為、重複Pathは削除
typeset -U path PATH

# editorをvimに
export EDITOR=vim

export TERM=xterm-256color

# 補完候補向けの色を設定
if [ "$LS_COLORS" -a -f /etc/DIR_COLORS ]; then
  eval $(dircolors /etc/DIR_COLORS)
fi

