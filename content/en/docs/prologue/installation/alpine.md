---
title: Alpine
description: Install the V2Ray core and v2rayA
lead: The function of v2rayA depends on the V2Ray core, so the V2Ray Core needs to be installed.
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

## Install V2Ray Core/ Xray Core

{{% notice info %}}
If you have already installed the core, you can skip this section.
{{% /notice %}}

V2Ray Installation: [https://github.com/v2fly/alpinelinux-install-v2ray](https://github.com/v2fly/alpinelinux-install-v2ray)

Xray Installation: [https://github.com/XTLS/alpinelinux-install-xray](https://github.com/XTLS/alpinelinux-install-xray)

## Install v2rayA

### Download the binary executable file

According to your platform, obtain the <code>v2raya_linux_xxx</code> <a>file with v2raya_linux_xxx from Release</a> and rename it to `v2raya` , then move `v2raya` to `/usr/local/bin` and give executable permissions.

Example:

```bash
version=$(curl -s https://apt.v2raya.mzz.pub/dists/v2raya/main/binary-amd64/Packages|grep Version|cut -d' ' -f2)
wget https://github.com/v2rayA/v2rayA/releases/download/v$version/v2raya_linux_x64_v$version -O v2raya
mv ./v2raya /usr/local/bin/ && chmod +x /usr/local/bin/v2raya
```

You can use the `arch` command to query your platform architecture. For example, for the x86_64 architecture, you need to download the x64 version.

### Create a service file

Create a new file named `v2raya` under the `/etc/init.d/` directory, then edit it, and add the following content:

```ini
#!/sbin/openrc-run

name="v2rayA"
description="A Linux web GUI client of Project V which supports V2Ray, Xray, SS, SSR, Trojan and Pingtunnel"
command="/usr/local/bin/v2raya"
command_args="--config=/usr/local/etc/v2raya"
pidfile="/run/${RC_SVCNAME}.pid"
command_background="yes"

depend() {
    need net
}
```

Save the file, and then give the file executable permissions.

### Install the iptables module and make the 2017 port accessible

```bash
apk add iptables ip6tables
/sbin/iptables -I INPUT -p tcp --dport 2017 -j ACCEPT
```

### Run v2rayA and make it start while system boots (optional)

```bash
rc-service v2raya start
rc-update add v2raya
```

### Other operations

#### Specify WebDir

Add a parameter `--webdir`  to `command_args` of the service file, and then specify the directory where the Web file is located. for example:

```ini
command_args="--config=/usr/local/etc/v2raya --webdir=/usr/local/etc/v2raya/web"
```

#### Specify the core

Add a parameter `--v2ray-bin` to`command_args` of the service file, and then specify the directory where the kernel is located. for example:

```ini
command_args="--config=/usr/local/etc/v2raya --v2ray-bin=/usr/local/bin/xray"
```
