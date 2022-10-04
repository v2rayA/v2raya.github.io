---
title: macOS
description: 安装核心和 v2rayA
lead: v2rayA 的功能依赖于 V2Ray 核心，因此需要安装内核。
date: '2021-08-31 06:48:45 +0000'
lastmod: '2021-08-31 06:48:45 +0000'
draft: 'false'
images: []
menu:
  docs:
    parent: installation
weight: '15'
toc: 'true'
---

{{% notice info %}} v2rayA 与 v2ray / xray 尚未支持 macOS / FreeBSD 之上的 Packet Filter 防火墙，因此透明代理无法启用。安全起见，本 wiki 将以非 root 权限来运行 v2rayA。 {{% /notice %}}

{{% notice info %}} It is recommended to install v2ray core by using Homebrew, so v2rayA will automatically use the existing v2ray core on your computer. Without installing the core from brew, you will need to manually specify the path of v2ray core. {{% /notice %}}

## Install with Homebrew

Please make sure [Homebrew](https://brew.sh/) is installed and well working.

### Installation

Add v2rayA Tap:

```bash
brew tap v2raya/v2raya
```

Install v2rayA:

```bash
brew install v2raya/v2raya/v2raya
```

### Start up

After the installation is complete, you can run `v2raya --lite` command in the terminal, or you can start the service:

```bash
brew services start v2raya
```

## Manual installation

### Create directory

These directories may already exist, please check before creating them.

Binary directory:

```bash
sudo mkdir /usr/local/bin/
```

Data files directory:

```bash
sudo mkdir -p /usr/local/share/v2ray/
```

Service file directory:

```bash
mkdir ~/Library/LaunchAgents/
```

### Download v2rayA

Download the binaries for macOS from [GitHub Releases](https://github.com/v2rayA/v2rayA/releases) or GitHub Action, then rename to `v2raya` and save it to `/usr/local/bin/` .

For example:

x86_64:

```bash
sudo curl -L https://github.com/v2rayA/v2rayA/releases/download/v1.5.7/v2raya_darwin_x64_1.5.7 -o /usr/local/bin/v2raya
```

arm64:

```bash
sudo curl -L https://github.com/v2rayA/v2rayA/releases/download/v1.5.7/v2raya_darwin_arm64_1.5.7 -o /usr/local/bin/v2raya
```

### Download V2Ray Core / Xray Core

> Install V2Ray: [https://www.v2fly.org/guide/install.html](https://www.v2fly.org/guide/install.html)<br> Install Xray: [https://xtls.github.io/document/install.html](https://xtls.github.io/document/install.html)

After decompressing the compressed package, move the files in it to the corresponding directory:

```bash
sudo mv v2ray /usr/local/bin/
sudo mv v2ctl /usr/local/bin/
sudo mv *dat /usr/local/share/v2ray/
```

### Permission settings

Give v2rayA and v2ray executable permissions:

```bash
sudo chmod 755 /usr/local/bin/v2raya
sudo chmod 755 /usr/local/bin/v2ray
sudo chmod 755 /usr/local/bin/v2ctl
```

If you encounter the security restrictions of macOS, then you need to run the following command:

```bash
sudo xattr -d -r com.apple.quarantine  /usr/local/bin/*
```

### Create service files

Create a new service file and save it to `~/Library/LaunchAgents/`

For example:

```bash
nano ~/Library/LaunchAgents/org.v2raya.v2raya.plist
```

Contents:

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

### Start up

```bash
launchctl load ~/Library/LaunchAgents/org.v2raya.v2raya.plist
```

If you want to close the v2rayA service, replace the above command from `load` to `unload` . The logs can be viewed through the web pages.
