---
title: "Quick Start"
description: "快速上手 v2rayA"
lead: "TODO: 创建账号密码、导入节点、连接、设置透明代理、浏览器代理、系统代理等基本用法，再次提醒如何切换内核，引到手册一章。本节尽量不外引，最简单地介绍个流程即可。"
date: 2020-11-16T13:59:39+01:00
lastmod: 2020-11-16T13:59:39+01:00
draft: false
images: []
menu:
  docs:
    parent: "prologue"
weight: 20
toc: true
---

- [安装 V2Ray 内核 / Xray 内核](#安装-v2ray-内核--xray-内核)
    - [Arch Linux 以及它的衍生版](#arch-linux-及其衍生版)
    - [使用 systemd 的 Linux 发行版](#使用-systemd-的-linux-发行版)
    - [Alpine Linux](#alpine-linux)
    - [OpenWrt](#openwrt)
- [安装 v2rayA](#安装-v2raya)
    - [Debian 系列安装](#debian-系列安装)
    - [RedHat(CentOS) / openSUSE 系列安装](#redhatcentos--opensuse-系列安装)
    - [Alpine Linux](#alpine-linux)
    - [Arch Linux 以及它的衍生版](#arch-linux-以及它的衍生版-1)
    - [OpenWrt](#OpenWrt)
    - [Docker 方式](#docker-方式)
- [安装完毕后如何使用](#安装完毕后如何使用)
- [使用其他类 V2Ray 核心](#使用其他类-v2ray-核心)
    - [systemd 方案](#systemd-方案)
    - [Alpine Linux](#alpine-linux)
    - [OpenWrt](#openwrt)
- [环境变量](#环境变量)

## 安装 V2Ray 内核 / Xray 内核

### Arch Linux 及其衍生版

从官方源安装 `v2ray`，或者从 AUR 安装 `xray` 或 `xray-bin`。

### 使用 systemd 的 Linux 发行版

V2Ray 安装参考：<https://github.com/v2fly/fhs-install-v2ray>

Xray 安装参考：<https://github.com/XTLS/Xray-install>

安装后可以关掉服务，因为v2rayA不依赖于该systemd服务。

```bash
sudo systemctl disable v2ray --now ### Xray 需要替换服务为 xray
```

### Alpine Linux

V2Ray 安装参考：<https://github.com/v2fly/alpinelinux-install-v2ray>

Xray 安装参考：<https://github.com/XTLS/alpinelinux-install-xray>

### OpenWrt

首先安装软件包 `unzip` 与 `wget`，然后下载 v2ray 内核然后将其保存到 `/usr/bin`，下载链接为<https://github.com/v2fly/v2ray-core/releases>，最后给予二进制文件可执行权限。

例如：

```bash
opkg update; opkg install unzip wget
wget https://github.com/v2fly/v2ray-core/releases/download/v4.40.1/v2ray-linux-64.zip
unzip -d v2ray-core v2ray-linux-64.zip
cp v2ray-core/v2* /usr/bin; cp v2ray-core/*dat /usr/bin
chmod +x /usr/bin/v2ray; chmod +x /usr/bin/v2ctl
```

格外注意你的 OpenWrt 设备的架构，不要下载到不适用于你设备的版本，否则内核将无法运行。Xray 内核可参照此方法安装。

## 安装 v2rayA

### Debian 系列安装

#### 方法一：通过软件源安装

##### 添加公钥

```bash
wget -qO - https://apt.v2raya.mzz.pub/key/public-key.asc | sudo apt-key add -
```

##### 添加 V2RayA 软件源

```bash
echo "deb https://apt.v2raya.mzz.pub/ v2raya main" | sudo tee /etc/apt/sources.list.d/v2raya.list
sudo apt update
```

##### 安装 V2RayA

```bash
sudo apt install v2raya
```

#### 方法二：手动安装 deb 包

[下载 deb 包](https://github.com/v2rayA/v2rayA/releases)后可以使用 Gdebi、QApt 等图形化工具来安装，也可以使用命令行：

```bash
sudo apt install /path/download/installer_debian_xxx_vxxx.deb ### 自行替换 deb 包所在的实际路径
```

### RedHat(CentOS) / openSUSE 系列安装

[下载 rpm 包](https://github.com/v2rayA/v2rayA/releases)后运行：

```bash
sudo rpm -i /path/download/installer_redhat_xxx_vxxx.rpm ### 自行替换 rpm 包所在的实际路径
```

### Alpine Linux

#### 1. 下载二进制可执行文件

根据你的平台，从 [Release](https://github.com/v2rayA/v2rayA/releases) 获取具有 `v2raya_linux_xxx` 字样的无后缀名文件，并将其重命名为 `v2raya`，再把 `v2raya` 移动到 `/usr/local/bin` 并给予可执行权限。

  示例：
   ```
   wget https://github.com/v2rayA/v2rayA/releases/download/v1.4.1/v2raya_linux_amd64_v1.4.1 -O v2raya
   smv ./v2raya /usr/local/bin/ && chmod +x /usr/local/bin/v2raya
   ```

#### 2. 安装网页前端

下载 v2rayA 的 Web 页面，然后保存到`/usr/local/etc/v2raya/web`。

示例：
  ```bash
  wget https://github.com/v2rayA/v2raya-web/archive/refs/heads/master.zip
  unzip master.zip
  mkdir -p /usr/local/etc/v2raya/web
  mv -r ./v2raya-web-master/* /usr/local/etc/v2raya/web
  ```

#### 3. 创建服务文件

在 `/etc/init.d/` 目录下面新建一个名为 `v2raya` 的文本文件，然后编辑，添加内容如下：

   ```ini
   #!/sbin/openrc-run
   
   name="v2rayA"
   description="A Linux web GUI client of Project V which supports V2Ray, Xray, SS, SSR, Trojan and Pingtunnel"
   command="/usr/local/bin/v2raya"
   command_args="--webdir=/usr/local/etc/v2raya/web --config=/usr/local/etc/v2raya"
   pidfile="/run/${RC_SVCNAME}.pid"
   command_background="yes"
   
   depend() {
   	need net
   }
   ```

保存文件，然后给予此文件可执行权限。

#### 4. 安装 iptables 模块

  ```bash
  apk add iptables ip6tables
  ```

#### 5. 运行 v2rayA 并开机启动

  ```bash
  rc-service v2raya start
  rc-update add v2raya
  ```

### Arch Linux 以及它的衍生版

从 AUR 安装 `v2raya` 或 `v2raya-bin`、`v2raya-git` 即可。

### OpenWrt

#### 1. 安装必须的软件包：

  ```bash
  opkg update
  opkg install ca-certificates tar curl
  opkg install kmod-ipt-nat6 iptables-mod-tproxy iptables-mod-filter
  ```

#### 2. 安装网页前端

  ```bash
  cd /tmp
  latest_version=$(curl -s https://apt.v2raya.mzz.pub/dists/v2raya/main/binary-amd64/Packages|grep Version|cut -d' ' -f2)
  wget https://apt.v2raya.mzz.pub/pool/main/v/v2raya/web_v${latest_version}.tar.gz
  mkdir /etc/v2raya
  tar xzvf web_v${latest_version}.tar.gz --directory /etc/v2raya
  ```

#### 3. 安装二进制可执行文件

  ```bash
  wget -O /usr/bin/v2raya https://apt.v2raya.mzz.pub/pool/main/v/v2raya/v2raya_linux_amd64_v${latest_version}
  chmod +x /usr/bin/v2raya
  ```

#### 4. 创建服务文件

  ```bash
  nano /etc/init.d/v2raya
  ```

内容如下：

  ```ini
  #!/bin/sh /etc/rc.common
  command=/usr/bin/v2raya
  PIDFILE=/var/run/v2raya.pid
  depend() {
   	need net
   	after firewall
   	use dns logger
  }
  start() {
   	start-stop-daemon -b -S -m -p "${PIDFILE}" -x $command
  }
  stop() {
   	start-stop-daemon -K -p "${PIDFILE}"
  }
  ```
   
给予此文件可执行权限：

  ```bash
  chmod +x /etc/init.d/v2raya
  ```

#### 5. 运行 v2rayA 并开机启动

  ```bash
  /etc/init.d/v2raya start
  /etc/init.d/v2raya enable
  ```

### Docker 方式

使用 docker 命令部署。

  ```bash
  # run v2raya
  docker run -d \
	--restart=always \
	--privileged \
	--network=host \
	--name v2raya \
	-e V2RAYA_ADDRESS=0.0.0.0:2017 \
        -v /lib/modules:/lib/modules \
	-v /etc/resolv.conf:/etc/resolv.conf \
	-v /etc/v2raya:/etc/v2raya \
	mzz2017/v2raya
  ```

---

如果你使用 MacOSX 或其他不支持 host 模式的环境，在该情况下**无法使用全局透明代理**，或者你不希望使用全局透明代理，docker 命令会略有不同：

  ```bash
  # run v2raya
  docker run -d \
	-p 2017:2017 \
	-p 20170-20172:20170-20172 \
	--restart=always \
	--name v2raya \
	-v /etc/v2raya:/etc/v2raya \
	mzz2017/v2raya
  ```


## v2rayA 运行相关

如果 v2rayA 正常运行（启动或许需要一定时间）则开放 2017 作为管理端口，通过浏览器访问即可进行管理。如访问 http://localhost:2017/

+ 导入并连接正常工作的节点后，设置全局透明代理即可使用。

+ 如果不使用全局透明代理，可使用浏览器插件如 SwitchyOmega 通过下述端口进行代理，或使用桌面环境提供的系统代理进行达到类似全局代理的效果。：

   默认情况下开放三个代理端口：20170(socks5)、20171(http)、20172(带分流规则的 http)

+ 注意，如果通过 archlinuxcn 源安装，需要运行`systemctl enable --now v2raya`。

## 使用其他类 V2Ray 核心

一般而言 v2rayA 会优先选择 v2ray，其次是 xray。如需切换到 xray，卸载 v2ray 即可。

如果使用其他暂不主动支持的类 v2ray 核心，参考以下方法（以指定使用 Xray 为例）：

### systemd 方案

1. 新建文件夹 `/etc/systemd/system/v2raya.service.d`，然后新建一个 `xray.conf` 的文件，添加以下内容：

   ```conf
   [Service]
   Environment="V2RAYA_V2RAY_BIN=/usr/local/bin/xray"
   ```

   注意检查 Xray 的路径是否正确。

2. 重载服务：

   ```
   sudo systemctl daemon-reload && sudo systemctl restart v2raya
   ```

### Alpine Linux

修改 `/etc/init.d/v2raya`，然后在 `command_args=""` 的内容里面加上 ` --v2ray-bin=/usr/local/bin/xray`（注意--v2ray-bin之前可能需要空格），再重启服务即可。  

### OpenWrt

（未经过测试）直接将 `command` 修改为 `/usr/bin/v2raya --v2ray-bin=/usr/bin/xray` 即可。

## 环境变量

`V2RAYA_ADDRESS`: 监听地址 (默认 "0.0.0.0:2017")

`V2RAYA_CONFIG`: v2rayA 配置文件目录 (默认 "/etc/v2raya")

`V2RAYA_V2RAY_BIN`: v2ray 可执行文件路径. 留空将自动检测. 可修改为 v2ray 分支如 xray 等文件路径

`V2RAYA_V2RAY_CONFDIR`: 附加的 v2ray 配置文件目录, 该目录中的 v2ray 配置文件会与 v2rayA 生成的配置文件进行组合

`V2RAYA_WEBDIR`: v2rayA 前端 GUI 文件目录 (默认 "/etc/v2raya/web")

`V2RAYA_PLUGINLISTENPORT`: v2rayA 内部插件端口 (默认 32346)

`V2RAYA_FORCE_IPV6_ON`: 强制启用 IPv6，即使 v2rayA 认为该机器不支持 IPv6。

`V2RAYA_PASSCHECKROOT`: 跳过 root 权限检测, 确认你有 root 权限而 v2rayA 判断出错时使用

`V2RAYA_VERBOSE`: 详细日志模式，混合打印 v2ray-core 和 v2rayA 的运行日志

`V2RAYA_RESET_PASSWORD`: 重设密码