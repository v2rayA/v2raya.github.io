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

首先安装软件包 `unzip` 与 `wget`，然后从 [Github Releases](https://github.com/v2fly/v2ray-core/releases) 下载 v2ray 内核然后将其保存到 `/usr/bin`，最后给予二进制文件可执行权限。

例如：

```bash
opkg update; opkg install unzip wget
wget https://github.com/v2fly/v2ray-core/releases/download/v4.40.1/v2ray-linux-64.zip
unzip -d v2ray-core v2ray-linux-64.zip
cp v2ray-core/v2ray v2ray-core/v2ctl /usr/bin
chmod +x /usr/bin/v2ray; chmod +x /usr/bin/v2ctl
```

{{% notice note %}} **擦亮眼睛**  
格外注意你的 OpenWrt 设备的架构，不要下载到不适用于你设备的版本，否则内核将无法运行。
{{% /notice %}}

Xray 内核亦可参照此方法安装。

## 安装 v2rayA

### 通过软件源安装

{{% notice info %}}
目前只有 openWrt 最新的 snapshot 版本软件源中含有 v2rayA。使用此版本的用户可以直接从软件源安装。
{{% /notice %}}

```bash
opkg update
opkg install v2raya
```

{{% notice note %}}
由于目前 openWrt 的软件源中没有 `v2ray-core`, `xray-core` 会作为依赖被安装。
如果你使用 v2ray，则可以手动卸载并忽略依赖警告。
{{% /notice %}}

### 手动安装

{{% notice info %}}
对于软件源中没有 v2rayA 的用户，可以从 [此处](https://downloads.openwrt.org/snapshots/packages) 中寻找适合你架构的 ipk 文件进行安装，也可以直接按如下方式手动安装。
{{% /notice %}}

#### 安装必须的软件包

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

#### 安装二进制可执行文件

从 [Github Releases](https://github.com/v2rayA/v2rayA/releases) 下载最新版本对应处理器架构的二进制文件。
移动到 `/usr/bin` 并给予执行权限：

```bash
mv v2raya /usr/bin/v2raya
chmod +x /usr/bin/v2raya
```

#### 创建配置文件和服务文件

`/etc/config/v2raya` 参考[此处](https://raw.githubusercontent.com/openwrt/packages/master/net/v2raya/files/v2raya.config)。

`/etc/init.d/v2raya` 参考[此处](https://raw.githubusercontent.com/openwrt/packages/master/net/v2raya/files/v2raya.init)。

给予此文件可执行权限：

```bash
chmod +x /etc/init.d/v2raya
```

## 设置 v2rayA 开机启动

```bash
uci set v2raya.config.enabled='1'
uci commit v2raya
/etc/init.d/v2raya start
```
