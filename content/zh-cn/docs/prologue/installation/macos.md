---
title: "macOS"
description: "安装核心和 v2rayA"
lead: "v2rayA 的功能依赖于 V2Ray 核心，因此需要安装内核。"
date: 2021-08-31T14:48:45+08:00
lastmod: 2021-08-31T14:48:45+08:00
draft: false
images: []
menu:
  docs:
    parent: "installation"
weight: 15
toc: true
---

{{% notice info %}}
v2rayA 尚未支持 macOS / FreeBSD 之上的 Packet Filter 防火墙，因此透明代理无法启用。安全起见，本 wiki 将以非 root 权限来运行 v2rayA。
{{% /notice %}}

{{% notice info %}}
建议从 brew 安装 v2ray 核心，如此 v2rayA 将自动使用你电脑上现有的 v2ray。如果不从 brew 安装核心，你将需要手动指定核心所在路径。
{{% /notice %}}

## 下载 v2rayA

从 [GitHub Releases](https://github.com/v2rayA/v2rayA/releases) 或 GitHub Action 下载适用于 macOS 的二进制文件，然后重命名为 `v2raya`（如果你还找不到适用于 macOS 的二进制文件，那就是开发者还在咕咕咕，你再等一分钟或许下一分钟就好了😊😊😊）。

下载好 v2rayA 的二进制文件后，你需要在你当前目录下新建一个文件夹，用来存放 v2rayA 的二进制文件以及相关配置：

```bash
mkdir ~/.bin/
```

然后将二进制文件移动到 bin 文件夹：

```bash
mv ~/Downloads/v2raya ~/.bin/
```

## 下载 V2Ray 核心 / Xray 核心

### 方法一：从 brew 安装

```bash
brew install v2ray  ## 或者安装 xray 
```

### 方法二：手动下载安装

> 安装 V2Ray：<https://www.v2fly.org/guide/install.html>   
> 安装 Xray：<https://xray.sh/guide/install/>   

解压压缩包后将其中的二进制文件与 `.dat` 格式的文件都移动到 ~/.bin/ 或其它你可以访问的目录。

示例：

```bash
mv ./v2ray-macos-amd64/* ~/.bin
```

## 建立服务文件

新建服务文件并保存到 `~/Library/LaunchAgents/`

示例：

```bash
nano ~/Library/LaunchAgents/org.v2raya.v2raya.plist
```

内容如下：

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
    <dict>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>org.v2raya.v2raya</string>
        <key>ProgramArguments</key>
        <array>
            <string>/Users/UserName/.bin/v2raya</string>
            <string>--lite</string>
            <string>--v2ray-bin=/usr/local/bin/v2ray</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
    </dict>
</plist>
```

自行替换 `UserName` 为你的实际用户名。

{{% notice info %}}
+ 可以使用 `echo $HOME` 命令来快速确认你的 Home 目录。
+ `--v2ray-bin` 用于指定 V2Ray / Xray 核心，由于 launchd 的限制，v2rayA 无法自动获取在 path 内的核心，因此需要手动指定。如果你使用 brew 安装了核心，则可以通过 `which xray` 来快速确认核心所在位置。
{{% /notice %}}

最后，给予 v2rayA 可执行权限：

```bash
chmod +x ~/.bin/v2raya && xattr -d -r com.apple.quarantine ~/.bin/*
```

如若核心也在 `.bin` 之中，那么还需要给予 `v2ray`、`v2ctl` 或 `xray` 可执行权限。
