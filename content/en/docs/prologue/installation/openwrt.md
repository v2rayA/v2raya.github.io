---
title: OpenWrt
description: Install V2Ray core and v2rayA
lead: The function of v2rayA depends on V2Ray core, so it needs to be installed.
date: '2020-11-16 13:59:39 +0100'
lastmod: '2020-11-16 13:59:39 +0100'
draft: 'false'
images: []
menu:
  docs:
    parent: installation
weight: '15'
toc: 'true'
---

## Install from v2rayA self-built software source

refer to:

1. [v2rayA for OpenWrt repository Homepage](https://github.com/v2raya/v2raya-openwrt)

2. [OSDN Homepage](https://osdn.net/projects/v2raya/)

You can use open source mirror sites that reverse proxy OSDN to speed up downloads.

## Install from OpenWrt official repositories

{{% notice info %}} Currently only the latest snapshot version of openWrt contains v2rayA in the software source. Users of this version can install it directly from the software source. {{% /notice %}}

```bash
opkg update
opkg install v2raya
```

{{% notice note %}} Since there is no `v2ray-core` in the `xray-core` will be installed as a dependency. If you plan to use v2ray then you need to install it manually. In the presence of both v2ray and xray, v2rayA will take precedence over the former. {{% /notice %}}

## Manual installation

### Install V2Ray Kernel / Xray Kernel

First install the packages `unzip` and `wget` , then download the v2ray kernel from [Github Releases](https://github.com/v2fly/v2ray-core/releases) and save it to `/usr/bin` , and finally give the binary executable permission.

E.g:

```bash
opkg update; opkg install unzip wget-ssl
wget https://github.com/v2fly/v2ray-core/releases/download/v4.40.1/v2ray-linux-64.zip
unzip -d v2ray-core v2ray-linux-64.zip
cp v2ray-core/v2ray v2ray-core/v2ctl /usr/bin
chmod +x /usr/bin/v2ray; chmod +x /usr/bin/v2ctl
```

{{% notice note %}} **keep** your eyes open Pay extra attention to the architecture of your OpenWrt device, don't download a version that doesn't work for your device, or the kernel won't work. {{% /notice %}}

### Install v2rayA

{{% notice info %}} For users who do not have v2rayA in the software source, you can find the ipk file suitable for your architecture from [here](https://downloads.openwrt.org/snapshots/packages) to install, or you can install it manually as follows. {{% /notice %}}

Download the latest version of the binaries for the processor architecture from [Github Releases](https://github.com/v2rayA/v2rayA/releases) , then move to `/usr/bin` and give execute permissions:

```bash
wget https://github.com/v2rayA/v2rayA/releases/download/v$version/v2raya_linux_$arch_$version --output-document v2raya
mv v2raya /usr/bin/v2raya && chmod +x /usr/bin/v2raya
```

### Install dependencies and kernel modules

```bash
opkg update
opkg install \
    ca-bundle \
    ip-full \
    iptables-mod-conntrack-extra \
    iptables-mod-extra \
    iptables-mod-filter \
    iptables-mod-tproxy \
    kmod-ipt-nat6
```

### Create configuration and service files

`/etc/config/v2raya` reference [here](https://raw.githubusercontent.com/openwrt/packages/master/net/v2raya/files/v2raya.config) .

`/etc/init.d/v2raya` reference [here](https://raw.githubusercontent.com/openwrt/packages/master/net/v2raya/files/v2raya.init) .

给予此文件可执行权限：

```bash
chmod +x /etc/init.d/v2raya
```

## run v2rayA

### Enable v2rayA service

```bash
uci set v2raya.config.enabled='1'
uci commit v2raya
```

### start v2rayA

```bash
/etc/init.d/v2raya start
```

## Some tips

### PPPoE dial-up problem

If you are dial-up via PPPoE, then you may experience the failure of v2rayA's transparent proxy to have no network connection after a period of time. As a workaround, when using v2rayA, do not delete or replace the "Network &gt; Interface" default WAN connection (which uses the DHCP protocol), but instead create a new interface for dialing. **The newly created PPPoE dial-up interface needs to be added to the firewall zone named wan.**

### Some devices do not work

The [database module](https://github.com/boltdb/bolt) used by ~~v2rayA currently does not support MIPS-based chips. These devices (such as some cheap WiFi routers, domestic Loongson computers, etc.) may not be able to properly initialize the database, resulting in unusable use. ~~ This issue has been resolved in v1.5.9.1698.1 version.

Also, v2rayA cannot be enabled if the device flash space is too small. if you are in need, you can use `upx` to compress v2rayA and the core and try again.

Operating systems with incomplete kernel modules cannot enable transparent proxy. It is recommended to use the official OpenWrt distribution, or a third-party flavor called ImmortalWrt.
