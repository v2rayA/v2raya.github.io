---
title: "Arch Linux / Manjaro"
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

从官方源安装 `v2ray`，或者从 AUR 安装 `xray` 或 `xray-bin`:

```bash
sudo pacman -Sy v2ray
```

## 安装 v2rayA

从 AUR 安装 `v2raya` 或 `v2raya-bin`、`v2raya-git` 。你可以通过 `makepkg` 命令来完成安装（手动处理编译依赖），也可以通过 [yay](https://github.com/Jguer/yay)、[paru](https://github.com/Morganamilo/paru) 等 AUR 帮助工具来安装。

示例：

```sh
yay -S v2raya
```
