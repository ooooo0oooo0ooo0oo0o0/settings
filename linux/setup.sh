#!/bin/sh

cd $(dirname $0)

#########################################
# dotfile達のシンボリックリンクを~($HOME)配下に作成
#########################################
for dotfile in .?*; do
    case $dotfile in
        *.elc)
            continue;;
        ..)
            continue;;
        .git)
            continue;;
        .vimperator)
            ln -Fis "$PWD/$dotfile/plugin" $HOME/$dotfile/plugin
            ;;
        *)
            ln -Fis "$PWD/$dotfile" $HOME
            ;;
    esac
done

#########################################
# vim plugin用各種ファイルのlink作成
#########################################
VIM_DIR=$HOME/.vim
mkdir -p $VIM_DIR
cd ../common
for vim_file in `\find . -maxdepth 1 -type d`; do
    ln -Fis $PWD/$vim_file $VIM_DIR/
done
cd $(dirname $0)

#########################################
# git versionに応じた各処理
#########################################
GIT_VERSION=$(git --version | sed -e "s/git version //" | awk -F. '{printf "%2d%02d%02d", $1,$2,$3}')
# versionに応じて不要なzsh用linkを削除する
if [ $GIT_VERSION -ge 10801 ]; then
  # version 1.8.1以降は"git-completion.zsh"の利用が可能
  unlink ~/.git-completion.bash
else
  unlink ~/.git-completion.zsh
fi

#########################################
# zshrcのコンパイル関連
#########################################
if which zsh > /dev/null 2>&1
then
    # zsh導入済みの場合は.zshrc.zwcの基ファイルを作成しておく。
    # (以降、terminal再接続 or "source ~/.zshrc"にて更新される)
    COMPILED_ZSHRC=.zshrc.zwc
    TZ=UTC touch -t '197001010000' $HOME/$COMPILED_ZSHRC
    chmod 444 $HOME/$COMPILED_ZSHRC
fi

