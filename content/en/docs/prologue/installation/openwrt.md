---
title: OpenWrt
description: Install V2Ray core and v2rayA
lead: The function of v2rayA depends on V2Ray core, so it needs to be installed firstly.
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

## Install v2rayA via our self-hosted opkg feed (recommended)

Please move to [v2raya/v2raya-openwrt](https://github.com/v2raya/v2raya-openwrt).

## Install v2rayA via official OpenWrt feed

{{% notice info %}}
The user-friendly LuCI application `luci-app-v2raya` has been available since OpenWrt 23.05 stable release.
{{% /notice %}}

```bash
opkg update
opkg install luci-app-v2raya v2ray-geoip v2ray-geosite
```

{{% notice info %}}
Package `v2raya` has been available since OpenWrt 21.02 stable release.
{{% /notice %}}

```bash
opkg update
opkg install v2raya
```

{{% notice note %}}
Due to poor dependencies management provided by opkg, v2rayA depends to Xray by default.

If you like V2Ray, you may install v2rayA with addtional argument `--nodeps` (Do not follow dependencies) and install all other necessary dependencies by yourself.

If you have both V2Ray and Xray installed, v2rayA will use the latter by default.
{{% /notice %}}

## Install v2rayA manually

### Install V2Ray / Xray core

{{% notice info %}}
Package `xray-core` has been available since OpenWrt 21.02 stable release.

Package `v2ray-core` has been available since OpenWrt 22.03 stable release.
{{% /notice %}}

First install packages `unzip` and `wget-ssl`, then download v2ray-core and move it to `/usr/bin/` \(precompiled builds can be found in [v2ray-core/releases](https://github.com/v2fly/v2ray-core/releases)\), and finally give the binary file executable permission.

E.g:

```bash
opkg update; opkg install unzip wget-ssl
wget https://github.com/v2fly/v2ray-core/releases/download/v4.40.1/v2ray-linux-64.zip -P /tmp
unzip -d /tmp/v2ray-core /tmp/v2ray-linux-64.zip
cp /tmp/v2ray-core/v2ray /usr/bin/
chmod +x /usr/bin/v2ray
rm -rf /tmp/v2ray-linux-64.zip /tmp/v2ray-core
```

Xray-core can be installed in a similar way.

{{% notice note %}} **Be careful**

Pay special attention to the architecture of your device: do not download a binary which is incompatible with it, otherwise the binary will not work.
{{% /notice %}}

### Install v2rayA

#### Install required dependencies:

For OpenWrt 22.03 and higher version:

```bash
opkg update
opkg install \
    ca-bundle \
    ip-full \
    kmod-nft-tproxy
```

For OpenWrt 21.02 and lower version:

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

#### Download v2rayA binary

Download the precompiled binary file corresponding to the processor architecture from [Github Releases](https://github.com/v2rayA/v2rayA/releases), and give it executable permission.

E.g.:

```bash
wget https://github.com/v2rayA/v2rayA/releases/download/v2.0.5/v2raya_linux_x64_2.0.5 -O /usr/bin/v2raya
chmod +x /usr/bin/v2raya
```

#### Download v2rayA service files

```bash
wget https://raw.githubusercontent.com/openwrt/packages/master/net/v2raya/files/v2raya.config -O /etc/config/v2raya
wget https://raw.githubusercontent.com/openwrt/packages/master/net/v2raya/files/v2raya.init -O /etc/init.d/v2raya
chmod +x /etc/init.d/v2raya
```

## Enable and start the service

```bash
uci set v2raya.config.enabled='1'
uci commit v2raya
/etc/init.d/v2raya enable
/etc/init.d/v2raya start
```
