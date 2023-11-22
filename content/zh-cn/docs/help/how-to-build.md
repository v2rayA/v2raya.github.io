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

确保你的系统上安装了 `yarn`、`nodejs`、`git` 和 `golang`。

### Windows

从 [scoop](https://scoop.sh/) 安装：

```ps1
scoop install yarn nodejs-lts go
```

如果你是在刚刚安装 scoop 之后运行该命令，那么你还需要安装 `git` 或 `mingit`。

建议安装 PowerShell Core，，如此 scoop 将能更好地工作（尤其是在旧版本 Windows 系统中）。可以从 [GitHub](https://aka.ms/powershell-release?tag=stable) 或 [Microsoft Store](https://www.microsoft.com/en-us/p/powershell/9mz1snwt0n5d) 下载 PowerShell Core。

### Arch Linux 及其衍生版

```bash
sudo pacman -S git yarn go
```

### 其它 Linux

{{% notice info %}}
部分发行版可能提供了 NodeJS 与 Go 语言的安装包，下面的安装方法主要以手动安装为主。
{{% /notice %}}

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
brew install git yarn go node
```

您可以使用 bash 脚本构建 v2rayA。如果要使用 PowerShell 脚本编译 v2rayA，则应先安装 PowerShell Core。可以[从 GitHub](https://aka.ms/powershell-release?tag=stable) 下载 PowerShell Core。

## 使用脚本构建

### Bash 脚本

Bash 脚本在类 UNIX 操作系统上运行，例如 Linux 或 macOS。

{{% notice info %}}
注意：bash 脚本不适用于 Windows 上的 `git-bash`，编译的时候会发生错误。有需要的可以使用 PowerShell 脚本编译。
{{% /notice %}}

打开终端，`cd` 到 v2rayA 源代码所在路径，然后运行`bash ./build.sh`

### PowerShell 脚本

PowerShell 脚本可在所有主流操作系统上运行，包括 Windows、Linux 和 macOS。

打开 PowerShell 窗口并将 `cd` v2rayA 源代码所在路径，然后运行 ​​`pwsh -c build-in-pwsh.ps1` 或者 ​​`powershell.exe -c build-in-pwsh.ps1`。

无论使用哪种编译脚本，只要编译成功，v2rayA 源代码所在路径里面就会多出一个 `v2raya` 或 `v2raya.exe` 的可执行文件。

## 手动构建 v2rayA

打开终端，`cd` 到 v2rayA 源代码所在路径。

v2rayA 的整个服务端实际上是由前端页面和后端服务组成的，但前端页面的编译是独立于后端服务的，所以我们需要先编译前端页面后才可以开始服务端的编译。

### 前端页面编译

v2rayA 源代码所在路径的 `gui` 文件夹里存放着前端页面，如果您只是需要对前端进行修改，且您的后端目前正常运行的话，请运行如下命令进行前端的预览：

```bash
# 切换到 gui 文件夹
cd gui
# 安装依赖
yarn
# 启动预览
yarn serve
```

预览页面的默认地址是 <http://localhost:8081/>，正常第一次预览打开后会出现如下提示：

- _未在 http://localhost:8081 检测到 v2rayA 服务端，请确定 v2rayA 正常运行_
- _您是否需要调整服务端地址？_

这时候我们需要点击 _您是否需要调整服务端地址？_ 右边的 _是_ 按钮来进行服务端地址配置，填写您的服务端地址即可，默认的服务端地址为 <http://localhost:2017/>，实际情况请根据您正在使用的服务端的配置来进行编写，但请确保您的服务端已经启动且正常运行。

确保前端页面可以正常预览后，您可以在终端输入 `yarn build` 来进行前端的构建。

默认构建文件会生成在 v2rayA 源代码所在路径下的 `web` 文件夹中，如果您需要切换编译文件存放的地址，请在编译之前设定环境变量 `OUTPUT_DIR` 的值，具体命令如下：

- Linux: `OUTPUT_DIR=<您指定的绝对路径> yarn build`
- Windows: `$env:OUTPUT_DIR = <您指定的绝对路径> && yarn build`

编译完成后你就会在 `OUTPUT_DIR` 目录下看到编译后的文件。

### 服务端编译

v2rayA 源代码所在路径的 `server` 文件夹里存放着服务端代码。

为了编译服务端，我们需要在前端页面编译时将环境变量 `OUTPUT_DIR` 指定为 v2rayA 源代码所在路径下 `service/server/router/web` 文件夹的绝对路径，后这您可以在编译完成后手动将 `web` 文件夹移动过去。

随后在终端运行如下命令进行服务端的编译：

```sh
# 切换到 server 文件夹
cd server
# 编译服务端
go build -o v2raya
```

编译完成后会在 `server` 文件夹下生成对应的可执行文件 `v2rayA`，同样的，您可以使用 `-o` 参数来指定编译后的文件名及路径。

值得注意的是，在实际的生产环境中，构建的时候设定了诸如 `CGO_ENABLED=0` 等参数用来优化编译，完整的编译参数可以查看 [build.sh](https://github.com/v2rayA/v2rayA/blob/main/build.sh#L16) 及 [build-in-pwsh.ps1](https://github.com/v2rayA/v2rayA/blob/main/build-in-pwsh.ps1#L51C1-L53) 中的内容。
