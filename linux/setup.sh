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

