#!/bin/sh
# author:niyongsheng
# url:https://github.com/niyongsheng/EasyRelease
# usage:sh podInstall.sh /Users/niyongsheng/EasyRelease
# if you installed `imagemagick` bug it not work, please run `which pod` replace `/usr/local/bin/pod`
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
cd $* && pwd && ls -al && /usr/local/bin/pod install
# cd $* && ls -al && p=`which pod` && $p install
