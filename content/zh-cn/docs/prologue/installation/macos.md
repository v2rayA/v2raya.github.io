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
v2rayA 与 v2ray / xray 尚未支持 macOS / FreeBSD 之上的 Packet Filter 防火墙，因此透明代理无法启用。安全起见，本 wiki 将以非 root 权限来运行 v2rayA。
{{% /notice %}}

{{% notice info %}}
建议从 brew 安装 v2ray 核心，如此 v2rayA 将自动使用你电脑上现有的 v2ray。如果不从 brew 安装核心，你将需要手动指定核心所在路径。
{{% /notice %}}

## 下载 v2rayA

从 [GitHub Releases](https://github.com/v2rayA/v2rayA/releases) 或 GitHub Action 下载适用于 macOS 的二进制文件，然后重命名为 `v2raya`，并将其保存到 `/usr/local/bin/`。

示例：
x86_64:
```bash
sudo curl -L https://github.com/v2rayA/v2rayA/releases/download/v1.5.4/v2raya_darwin_x64_1.5.4 -o /usr/local/bin/v2raya
```
arm64:
```bash
sudo curl -L https://github.com/v2rayA/v2rayA/releases/download/v1.5.4/v2raya_darwin_arm64_1.5.4 -o /usr/local/bin/v2raya
```

在相同的目录下建立一个 `.sh`格式的脚本文件，名为 v2raya.sh：

```bash
#! /bin/zsh
PATH=$PATH:/usr/local/bin
/usr/local/bin/v2raya --lite
```

## 下载 V2Ray 核心 / Xray 核心

### 方法一：从 brew 安装（推荐）

```bash
brew install v2ray  ## 或者安装 xray 
```

### 方法二：手动下载安装

> 安装 V2Ray：<https://www.v2fly.org/guide/install.html>  
> 安装 Xray：<https://xray.sh/document/install.html>

解压压缩包后将其中的二进制文件与 `.dat` 格式的文件都移动到 `/usr/local/bin/`。

## 建立服务文件

新建服务文件并保存到 `~/Library/LaunchAgents/`

示例：

```bash
mkdir ~/Library/LaunchAgents/  ###如果提示该目录存在，那么略过这条命令。
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
            <string>/usr/local/bin/v2raya.sh</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
    </dict>
</plist>
```

最后，给予 v2rayA 可执行权限：

```bash
sudo chmod 755 /usr/local/bin/v2raya && sudo chmod 755 /usr/local/bin/v2raya.sh
```

如果遇到 macOS 的安全限制，那么需要运行以下命令：

```bash
sudo xattr -d -r com.apple.quarantine  /usr/local/bin/*
```

如果sudo时遇到operation not permitted，是因为mac电脑启用了SIP（System Integrity Protection），增加了rootless机制，导致即使在root权限下依然无法修改文件，关闭该保护机制才能进行修改
关闭SIP方法：
1. 重启电脑，非M1用户请在屏幕出现苹果logo的时候，按照command+R，直到进入保护模式；M1及以后的用户请关机后长按10s开机按钮以进入保护模式
2. 保护模式：屏幕正中是一个对话框，提示恢复某个备份，或者恢复出厂系统等等。左上角有一排工具栏。
3. 左上角找到 terminal终端，打开，并输入csrutil disable
4. 再次重启电脑，即可对 usr/bin 目录下文件进行修改了

若要恢复保护机制，请重新进入保护模式后，在终端输入csrutil enable即可

如若核心是手动安装的，那么还需要给予 `v2ray`、`v2ctl` 或 `xray` 可执行权限。

## 运行

### 开启服务并运行

```bash
sudo chown 你的用户名:wheel ~/Library/LaunchAgents/org.v2raya.v2raya.plist
```

```bash
launchctl load ~/Library/LaunchAgents/org.v2raya.v2raya.plist
```
