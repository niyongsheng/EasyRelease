#!/bin/sh
# author:niyongsheng
# url:https://github.com/niyongsheng/EasyRelease
# usage:sh rehash.sh /Users/niyongsheng/EasyRelease
# if you installed `imagemagick` bug it not work, please run `which convert` replace `/usr/local/bin/convert`.
cd $* && pwd && ls -al && find . -iname "*.png" -exec echo {} \; -exec /usr/local/bin/convert {} {} \;
