#!/bin/sh

cd $(dirname $0)

# dotfile達のシンボリックリンクを~($HOME)配下に作成
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

# tomlファイルのlinkも作成
TOML_DIR=$HOME/.vim/dein_toml
mkdir -p $TOML_DIR
cd ../common/dein_toml
for toml_file in `\find . -maxdepth 1 -type f`; do
    ln -Fis "$PWD/$toml_file" $TOML_DIR/$toml_file
done

# はじめにzshrcを一発compileしとく
zcompile $HOME/.zshrc

