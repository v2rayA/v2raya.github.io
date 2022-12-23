---
title: "Debian / Ubuntu"
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

## 安装 V2Ray 内核

### V2Ray 的官方脚本

V2Ray 安装参考：<https://github.com/v2fly/fhs-install-v2ray>

<!-- Xray 安装参考：<https://github.com/XTLS/Xray-install> -->

### v2rayA 提供的镜像脚本（推荐）

```bash
curl -Ls https://mirrors.v2raya.org/go.sh | sudo bash
```

安装后可以关掉服务，因为 v2rayA 不依赖于该 systemd 服务。

```bash
sudo systemctl disable v2ray --now
```

## 安装 v2rayA

### 方法一：通过软件源安装

#### 添加公钥

```bash
wget -qO - https://apt.v2raya.org/key/public-key.asc | sudo tee /etc/apt/trusted.gpg.d/v2raya.asc
```

#### 添加 V2RayA 软件源

```bash
echo "deb https://apt.v2raya.org/ v2raya main" | sudo tee /etc/apt/sources.list.d/v2raya.list
sudo apt update
```

#### 安装 V2RayA

```bash
sudo apt install v2raya
```

### 方法二：手动安装 deb 包

[下载 deb 包](https://github.com/v2rayA/v2rayA/releases)后可以使用 Gdebi、QApt 等图形化工具来安装，也可以使用命令行：

```bash
sudo apt install /path/download/installer_debian_xxx_vxxx.deb ### 自行替换 deb 包所在的实际路径
```

## 启动 v2rayA / 设置 v2rayA 自动启动

> 从 1.5 版开始将不再默认为用户启动 v2rayA 及设置开机自动。

- 启动 v2rayA

  ```bash
  sudo systemctl start v2raya.service
  ```

- 设置开机自动启动

  ```bash
  sudo systemctl enable v2raya.service
  ```

## 切换 iptables 为 iptables-nft

对于 Debian11 用户来说，iptables 已被弃用。使用 nftables 作为 iptables 的后端以进行适配：

```bash
update-alternatives --set iptables /usr/sbin/iptables-nft
update-alternatives --set ip6tables /usr/sbin/ip6tables-nft
update-alternatives --set arptables /usr/sbin/arptables-nft
update-alternatives --set ebtables /usr/sbin/ebtables-nft
```

如果你想切换回 legacy 版本：

```bash
update-alternatives --set iptables /usr/sbin/iptables-legacy
update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
update-alternatives --set arptables /usr/sbin/arptables-legacy
update-alternatives --set ebtables /usr/sbin/ebtables-legacy
```

切换后重启即可。
