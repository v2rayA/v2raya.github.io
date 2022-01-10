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
sudo dnf install v2raya
```

## Fedora Silverblue / Kinoite

### 稳定方法

切换到合适的路径:

```bash
cd ~/Downloads
mkdir v2rayA
cd v2rayA
```

进入 toolbox:

```bash
toolbox enter
```

开启 copr 仓库:

```bash
sudo dnf copr enable zhullyb/v2rayA
```

下载软件包:

```bash
dnf download --resolve v2ray-core v2raya
```

退出到宿主机:

```bash
exit
```

在宿主机上安装软件包:

```bash
rpm-ostree install ./*.rpm
```

{{% notice warning %}}
警告：注意刚下载的软件包可能在被安装之前被低权限恶意软件替换。
{{% /notice %}}

然后，用GUI或者命令行重启电脑:

```bash
systemctl reboot
```

启用并开始运行 `v2rayA`:

```bash
sudo systemctl enable --now v2raya.service
```

用户应该自己手动更新软件。

### 快速方法

COPR软件仓库不受Silverblue / Kinoite支持，此方法风险自负。目前此方法似乎可用，但未来相关功能可能被修改或删除。

```bash
# 添加copr软件仓库到系统
sudo curl -Lo /etc/yum.repos.d/_copr:copr.fedorainfracloud.org:zhullyb:v2rayA.repo \
  https://copr.fedorainfracloud.org/coprs/zhullyb/v2rayA/repo/fedora-$(rpm -E %fedora)/zhullyb-v2rayA-fedora-$(rpm -E %fedora).repo
# 不重启的情况下安装软件包
sudo rpm-ostree install -A v2ray-core v2raya
# 启用并开始运行服务
sudo systemctl enable --now v2raya.service
```

软件更新由 `rpm-ostree` 自动完成。

## 其他基于 rpm 的操作系统

{{% notice info %}}
此方法可以为 Alma Linux、Rocky Linux、openSUSE 或其它基于 rpm 软件包管理器的 Linux 发行版安装 v2rayA，前提是你所用的**发行版使用了 systemd 作为系统管理工具**。
{{% /notice %}}

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
