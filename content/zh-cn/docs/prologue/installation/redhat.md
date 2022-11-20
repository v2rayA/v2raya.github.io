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

## openSUSE MicroOS， SLE Micro， Fedora Silverblue / Kinoite

如果你的发行版拥有不可写的运行时文件系统结构，请不要使用RPM安装v2rayA。

跳转：[Podman教程]({{% relref "podman" %}})。

## Fedora 34 / 35 / 36 以及 CentOS Stream 8

提醒：截止至2022/11/19，Fedora 37的COPR源依然没有v2rayA。来自COPR源维护者@zhullyb的消息：

> Fedora 37 没有人打包 golang 1.18，最新的 golang 无法编译 v4 版本的 v2ray-core，v2rayA 最后一个 tag 仍然不支持 v5 版本的 v2ray-core

如果你想要在Fedora 37上立刻使用v2rayA、或者避免以后升级Fedora时出现类似的问题，请参照[Podman教程]({{% relref "podman" %}})。

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

提醒：你应该参照[Podman教程]({{% relref "podman" %}})。请避免在Silverblue / Kinoite的宿主机中直接安装软件。

如果你依然要直接安装，以下是在宿主机中安装v2rayA的方法。

### 添加COPR软件仓库到系统

```bash
sudo curl -Lo /etc/yum.repos.d/_copr:copr.fedorainfracloud.org:zhullyb:v2rayA.repo \
  https://copr.fedorainfracloud.org/coprs/zhullyb/v2rayA/repo/fedora-$(rpm -E %fedora)/zhullyb-v2rayA-fedora-$(rpm -E %fedora).repo
```

### 安装v2rayA

```bash
sudo rpm-ostree install v2ray-core v2raya
```

然后，重启系统；或者使用以下命令将修改应用到当前系统中：

```bash
sudo rpm-ostree ex apply-live --allow-replacement
```

### 设置开机自启动，并且现在开始运行

```
sudo systemctl enable --now v2raya.service
```

## 其他基于 rpm 的操作系统

{{% notice info %}}
此方法可以为 Alma Linux、Rocky Linux、openSUSE、CentOS 7 或其它基于 rpm 软件包管理器的 Linux 发行版安装 v2rayA，前提是你所用的**发行版使用了 systemd 作为系统管理工具**。
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
