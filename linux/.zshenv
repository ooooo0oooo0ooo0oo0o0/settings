#########################################
# 全体設定
#########################################

# 環境変数(tmux上でのzsh起動時はスルー)
if [ -z $TMUX ]; then
  export PATH="${HOME}/bin:${PATH}"
fi

# 念の為、重複Pathは削除
typeset -U path PATH

# editorをvimに
export EDITOR=vim

