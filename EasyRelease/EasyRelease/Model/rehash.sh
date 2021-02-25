#!/bin/sh
# author:niyongsheng
# url:https://github.com/niyongsheng/EasyRelease
# usage:sh rehash.sh /Users/niyongsheng/EasyRelease
cd $*
ls -a -l
find . -iname "*.png" -exec echo {} \; -exec /usr/local/bin/convert {} {} \;
