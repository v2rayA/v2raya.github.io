---
title: "如何编译"
description: "提供手动与自动化两种编译方式。"
lead: "提供手动与自动化两种编译方式。"
draft: false
images: []
menu:
  docs:
    parent: "help"
toc: true
weight: 810
date: 2021-09-25T21:31:02+08:00
lastmod: 2021-09-25T21:31:02+08:00
images: []
---

## 准备构建环境

确保你的系统上安装了 yarn/npm、git 和 golang。

### Windows

从 [scoop](https://scoop.sh/) 安装：

```ps1
scoop install yarn go
```

你不需要再次安装 git，因为 scoop 依赖于 git。换而言之，当你使用 scoop 的时候，git 是一定安装好了的。

建议安装 PowerShell Core，，如此 scoop 将能更好地工作（尤其是在旧版本 Windows 系统中）。可以从 [GitHub](https://aka.ms/powershell-release?tag=stable) 或 [Microsoft Store](https://www.microsoft.com/en-us/p/powershell/9mz1snwt0n5d) 下载 PowerShell Core。

### Arch Linux 及其衍生版

```bash
sudo pacman -S git yarn go
```

### 其它 Linux

#### 安装 Git：

Debian / Ubuntu

```bash
sudo apt install git
```

RedHat / Alma Linux / Rocky Linux /Fedora

```bash
sudo dnf install git
```

openSUSE

```bash
sudo zypper in git
```

#### 安装 Golang：

<https://golang.org/doc/install></br>或者<br>
<https://golang.google.cn/doc/install></br>

#### 安装 Node.js 与 yarn：

参考官方教程安装 Node.js 的 16.x 的版本，然后再安装 yarn。

<https://github.com/nodesource/distributions></br>
<https://yarnpkg.com/getting-started/install>

### macOS

首先安装 [brew](https://brew.sh/)，然后在终端中运行：

```bash
brew install git yarn go
```

您可以使用 bash 脚本构建 v2rayA。如果要使用 PowerShell 脚本编译 v2rayA，则应先安装 PowerShell Core。可以[从 GitHub](https://aka.ms/powershell-release?tag=stable) 下载 PowerShell Core。

## 使用脚本构建

### Bash 脚本

Bash 脚本在类 UNIX 操作系统上运行，例如 Linux 或 macOS。

打开终端，`cd` 到 v2rayA 源代码所在路径，然后运行`bash ./build.sh`

### PowerShell 脚本

PowerShell 脚本可在所有主流操作系统上运行，包括 Windows、Linux 和 macOS。

打开 PowerShell 窗口并将 `cd` v2rayA 源代码所在路径，然后运行 ​​`./build-in-pwsh.ps1`

无论使用哪种编译脚本，只要编译成功，v2rayA 源代码所在路径里面就会多出一个 `v2raya` 或 `v2raya.exe` 的可执行文件。

## 手动构建 v2rayA

PR WELCOME
