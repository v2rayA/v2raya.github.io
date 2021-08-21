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

## 安装 V2Ray 内核 / Xray 内核

V2Ray 安装参考：<https://github.com/v2fly/fhs-install-v2ray>

Xray 安装参考：<https://github.com/XTLS/Xray-install>

安装后可以关掉服务，因为v2rayA不依赖于该systemd服务。

```bash
sudo systemctl disable v2ray --now ### Xray 需要替换服务为 xray
```

## 安装 v2rayA

[下载 rpm 包](https://github.com/v2rayA/v2rayA/releases)后运行：

```bash
sudo rpm -i /path/download/installer_redhat_xxx_vxxx.rpm ### 自行替换 rpm 包所在的实际路径
```
