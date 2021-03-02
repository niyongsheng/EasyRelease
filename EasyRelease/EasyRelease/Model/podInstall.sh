#!/bin/sh
# author:niyongsheng
# url:https://github.com/niyongsheng/EasyRelease
# usage:sh podInstall.sh /Users/niyongsheng/EasyRelease
cd $* && pwd && ls -al && /usr/local/bin/pod install
