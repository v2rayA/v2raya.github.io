---
title: "OpenWrt"
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

首先安装软件包 `unzip` 与 `wget`，然后下载 v2ray 内核然后将其保存到 `/usr/bin`，下载链接为<https://github.com/v2fly/v2ray-core/releases>，最后给予二进制文件可执行权限。

例如：

```bash
opkg update; opkg install unzip wget
wget https://github.com/v2fly/v2ray-core/releases/download/v4.40.1/v2ray-linux-64.zip
unzip -d v2ray-core v2ray-linux-64.zip
cp v2ray-core/v2ray v2ray-core/v2ctl /usr/bin
chmod +x /usr/bin/v2ray; chmod +x /usr/bin/v2ctl
```

格外注意你的 OpenWrt 设备的架构，不要下载到不适用于你设备的版本，否则内核将无法运行。Xray 内核可参照此方法安装。

## 安装 v2rayA

### 安装必须的软件包：

```bash
opkg update
opkg install ca-certificates tar curl
opkg install kmod-ipt-nat6 iptables-mod-tproxy iptables-mod-filter
```

### 安装二进制可执行文件

从 [Github Releases](https://github.com/v2rayA/v2rayA/releases) 下载最新版本对应处理器架构的二进制文件。
移动到`/usr/bin`并给予执行权限：

```bash
mv v2raya /usr/bin/v2raya
chmod +x /usr/bin/v2raya
```

### 创建服务文件

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

### 运行 v2rayA 并开机启动（可选）

```bash
/etc/init.d/v2raya start
/etc/init.d/v2raya enable
```
