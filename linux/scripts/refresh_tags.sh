#!/bin/bash
################################################
## ctags作成script。
## projectのrootディレクトリにコピーし実行する事で、
## 必要なtagsを生成してくれる。はず。
################################################
rm -rf *.tags

# C/C++向けtags作成
if ls -R | grep -e \\.cpp$ -e \\.hpp$ -e \\.c$ -e \\.h$ > /dev/null 2>&1
then
    ctags -R --languages=C,C++ -f tag_cxx.tags `pwd`
fi

# PHP向けtags作成
if ls -R | grep \\.php$ > /dev/null 2>&1
then
    ctags -R --languages=php -f tag_php.tags `pwd`
fi

