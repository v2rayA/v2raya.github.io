---
title: OpenWrt
description: Install the V2Ray core and v2rayA
lead: The function of v2rayA depends on the V2Ray core, so the kernel needs to be installed.
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

## Install V2Ray core/ Xray core

First install the packages `unzip` and `wget` , then download the v2ray core and save it to `/usr/bin` , the download link is [https://github.com/v2fly/v2ray-core/releases](https://github.com/v2fly/v2ray-core/releases) , and finally give the binary file executable permissions.

E.g:

```bash
opkg update; opkg install unzip wget
wget https://github.com/v2fly/v2ray-core/releases/download/v4.40.1/v2ray-linux-64.zip
unzip -d v2ray-core v2ray-linux-64.zip
cp v2ray-core/v2ray v2ray-core/v2ctl /usr/bin
chmod +x /usr/bin/v2ray; chmod +x /usr/bin/v2ctl
```

Pay special attention to the architecture of your OpenWrt device, do not download to a version that is not suitable for your device, otherwise the kernel will not run. Xray core can be installed by referring to this method.

## Install v2rayA

### Install the necessary packages:

```bash
opkg update
opkg install ca-certificates tar curl
opkg install kmod-ipt-nat6 iptables-mod-tproxy iptables-mod-filter
```

### Install binary executable file

Download the latest version of the binary file corresponding to the processor architecture from [Github Releases.](https://github.com/v2rayA/v2rayA/releases) Move to `/usr/bin` and give execution permission:

```bash
mv v2raya /usr/bin/v2raya
chmod +x /usr/bin/v2raya
```

### Create service file

```bash
nano /etc/init.d/v2raya
```

The content is as follows:

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

Give this file executable permissions:

```bash
chmod +x /etc/init.d/v2raya
```

### Run v2rayA and make it start at boot (optional)

```bash
/etc/init.d/v2raya start
/etc/init.d/v2raya enable
```
