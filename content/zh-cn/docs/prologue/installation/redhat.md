---
title: "RedHat / openSUSE"
description: "安装内核和 v2rayA"
lead: "v2rayA 的功能依赖于 V2Ray 内核，因此需要安装内核。"
date: 2020-11-16T13:59:39+01:00
lastmod: 2020-11-16T13:59:39+01:00
draft: false
images: []
menu:
  docs:
    parent: "installation"
weight: 15
toc: true
---

## Fedora 34 / 35 以及 CentOS Stream 8

### 添加 copr 源

```bash
sudo dnf copr enable zhullyb/v2rayA
```

### 安装 V2Ray 内核

```bash
sudo dnf install v2ray-core
```

> 如需Xray内核请参考: <https://github.com/XTLS/Xray-install>

### 安装 v2rayA

```bash
sudo dnf install v2rayA
```

## 其他基于 rpm 的操作系统

> 此方法可以为 Alma Linux、Rocky Linux、openSUSE 或其它基于 rpm 软件包管理器的 Linux 发行版安装 v2rayA，前提是你所用的**发行版使用了 systemd 作为系统管理工具**。

### 安装 V2Ray 内核 / Xray 内核

#### V2Ray / Xray 的官方脚本

V2Ray 安装参考：<https://github.com/v2fly/fhs-install-v2ray>

Xray 安装参考：<https://github.com/XTLS/Xray-install>

#### v2rayA 提供的镜像脚本（推荐）

```bash
curl -Ls https://mirrors.v2raya.org/go.sh | sudo bash
```

安装后可以关掉服务，因为v2rayA不依赖于该systemd服务。

```bash
sudo systemctl disable v2ray --now ### Xray 需要替换服务为 xray
```

### 安装 v2rayA

[下载 rpm 包](https://github.com/v2rayA/v2rayA/releases)后运行：

```bash
sudo rpm -i /path/download/installer_redhat_xxx_vxxx.rpm ### 自行替换 rpm 包所在的实际路径
```

## 注意事项

### 启动 v2rayA / 设置 v2rayA 自动启动

> 从 1.5 版开始将不再默认为用户启动 v2rayA，也不会默认设置开机自动。

- 启动 v2rayA

  ```bash
  sudo systemctl start v2raya.service
  ```

- 设置开机自动启动

  ```bash
  sudo systemctl enable v2raya.service
  ```
