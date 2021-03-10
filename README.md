![(logo)](https://github.com/niyongsheng/EasyRelease/blob/main/logo.png?raw=true&width=100&height=100)
EasyRelease
===
[![](https://img.shields.io/badge/platform-Mac-orange.svg)](https://developer.apple.com/mac/)
[![](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/niyongsheng/EasyRelease/blob/master/LICENSE)
===

## Introduction
> SaaS场景下自动化混淆工具。<br/>
> Automated obfuscation tools in SaaS scenarios.

## Features
- [x] Auto Configuration
- [x] Rename Project
- [x] Delete Annotation
- [x] Rehash Images
- [x] Replace Class/Method
- [ ] Code Mix

## Screenshot
![image](https://github.com/niyongsheng/niyongsheng.github.io/blob/master/Document/easy_release_demo.gif?raw=true)

## Imagemagick
```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install imagemagick
```

## CocoaPods
```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install cocoapods
```
## Usage

### NTOCC project usage：
>1. [Download](https://github.com/niyongsheng/EasyRelease/releases) configuration file `NtoccShipper.json` or `NtoccDriver.json` put that `.xcodeproj` in the same directory;
>2. Import the configuration file under `EasyRelease` and enter the new project name;
>3. Click `Action` button;

```json
{
    "isSasS": false,
    "isAuto": false,
    "isAutoPodInstall": false,
    "isRehashImages": false,
    "isDelAnnotation": true,
    "replaceArray": [
        {
            "Type": "class",
            "OldPrefix": "NYS",
            "NewPrefix": "NYSC",
            "Enable": "1"
        },
        {
            "Type": "method",
            "OldPrefix": "NYS",
            "NewPrefix": "NYSM",
            "Enable": "0"
        }
    ],
    "projectFileDirUrl": "file:\/\/\/Users\/niyongsheng\/Desktop\/EasyRelease\/EasyRelease.xcodeproj",
    "projectDirUrl": "file:\/\/\/Users\/niyongsheng\/Desktop\/EasyRelease\/EasyRelease\/",
    "ignoreArray": [
        {
            "name": "Pods",
            "enable": "1"
        }
    ],
    "projectOldName": "EasyRelease",
    "projectNewName": "EasyReleaseNew",
    "version": "1.0",
    "desc": "https://github.com/niyongsheng/EasyRelease"
}
```
### Field about .json
  ` "isSasS": false` Manual mode - read from configuration file;

  `"isSasS": true` automatic mode - name `.json` with the `.xcodeproj` filename;<br>
  `"isSasS": true && "isAuto": false` Semi-automatic mode - need to specify a new project name, prefix is automatically extracted;<br>
  `"isSasS": true && "isAuto": true` Full auto mode - new item names are randomly generated, prefix is automatically extracted;

## Remind
`macOS 10.15+ `

## Contribution
Reward[:lollipop:](https://github.com/niyongsheng/niyongsheng.github.io/blob/master/Beg/README.md)  Encourage[:heart:](https://github.com/niyongsheng/EasyRelease/stargazers)

## Contact Me [:octocat:](https://niyongsheng.github.io)
* E-mail: niyongsheng@Outlook.com
* Weibo: [@Ni永胜](https://weibo.com/u/7317805089)
