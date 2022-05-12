---
title: macOS
description: 安装核心和 v2rayA
lead: v2rayA 的功能依赖于 V2Ray 核心，因此需要安装内核。
date: 2021-08-31T06:48:45.000Z
lastmod: 2021-08-31T06:48:45.000Z
draft: false
images: []
menu: {docs: {parent: installation}}
weight: 15
toc: true
---

{{% notice info %}}
v2rayA 与 v2ray / xray 尚未支持 macOS / FreeBSD 之上的 Packet Filter 防火墙，因此透明代理无法启用。安全起见，本 wiki 将以非 root 权限来运行 v2rayA。
{{% /notice %}}

{{% notice info %}}
建议从 brew 安装 v2ray 核心，如此 v2rayA 将自动使用你电脑上现有的 v2ray。如果不从 brew 安装核心，你将需要手动指定核心所在路径。
{{% /notice %}}

## 使用 Homebrew 安装

请确保安装了 [Homebrew](https://brew.sh/) 并工作正常。

### 安装

添加 v2rayA 的 Tap：

```bash
brew tap v2raya/v2raya
```

安装 v2rayA:

```bash
brew install v2raya/v2raya/v2raya
```

### 运行

安装完成之后可以在终端通过 `v2raya --lite` 命令运行，也可以启动服务：

```bash
brew services start v2raya
```

## 手动安装

### 创建目录

这些目录可能已经存在，创建之前请注意检查。

二进制所在目录：

```bash
sudo mkdir /usr/local/bin/
```

数据文件所在目录：

```bash
sudo mkdir -p /usr/local/share/v2ray/
```

服务文件所在目录：

```bash
mkdir ~/Library/LaunchAgents/
```

### 下载 v2rayA

从 [GitHub Releases](https://github.com/v2rayA/v2rayA/releases) 或 GitHub Action 下载适用于 macOS 的二进制文件，然后重命名为 `v2raya`，并将其保存到 `/usr/local/bin/`。

示例：

x86_64:

```bash
sudo curl -L https://github.com/v2rayA/v2rayA/releases/download/v1.5.7/v2raya_darwin_x64_1.5.7 -o /usr/local/bin/v2raya
```

arm64:

```bash
sudo curl -L https://github.com/v2rayA/v2rayA/releases/download/v1.5.7/v2raya_darwin_arm64_1.5.7 -o /usr/local/bin/v2raya
```

### 下载 V2Ray 核心 / Xray 核心

> 安装 V2Ray：<https://www.v2fly.org/guide/install.html>  
> 安装 Xray：<https://xray.sh/document/install.html>

解压压缩包后将其中的文件移动到对应目录：

```bash
sudo mv v2ray /usr/local/bin/
sudo mv v2ctl /usr/local/bin/
sudo mv *dat /usr/local/share/v2ray/
```

### 给予权限

给予 v2rayA 与 v2ray 可执行权限：

```bash
sudo chmod 755 /usr/local/bin/v2raya
sudo chmod 755 /usr/local/bin/v2ray
sudo chmod 755 /usr/local/bin/v2ctl
```

如果遇到 macOS 的安全限制，那么需要运行以下命令：

```bash
sudo xattr -d -r com.apple.quarantine  /usr/local/bin/*
```

### 建立服务文件

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
      <key>EnvironmentVariables</key>
      <dict>
            <key>V2RAYA_LOG_FILE</key>
            <string>/tmp/v2raya.log</string>
            <key>V2RAYA_V2RAY_BIN</key>
            <string>/usr/local/bin/v2ray</string>
      </dict>
      <key>KeepAlive</key>
      <true/>
      <key>Label</key>
      <string>org.v2raya.v2raya</string>
      <key>ProgramArguments</key>
      <array>
            <string>/usr/local/bin/v2raya</string>
            <string>--lite</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
</dict>
</plist>
```

### 运行

```bash
launchctl load ~/Library/LaunchAgents/org.v2raya.v2raya.plist
```

如果要关掉 v2rayA 服务，将上述命令从 `load` 替换为 `unload` 即可。可以通过 Web 前端查看日志。
