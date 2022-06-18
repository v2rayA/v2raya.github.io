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

{{% notice info %}} If you have already installed the core, you can skip this section. {{% /notice %}}

### Method 1: Install from Package Manager

As of Alpine Linux 3.15, V2Ray has entered the Community repo. Edit the apk's configuration to enable Community feeds:

```bash
vi /etc/apk/repositories
```

```ini
http://dl-cdn.alpinelinux.org/alpine/v3.15/main
http://dl-cdn.alpinelinux.org/alpine/v3.15/community
```

Then install V2Ray:

```bash
apk update && apk add v2ray
```

### Method 2: Official Script of V2Ray/Xray

V2Ray installation reference: [https://github.com/v2fly/alpinelinux-install-v2ray](https://github.com/v2fly/alpinelinux-install-v2ray)

Xray installation reference: [https://github.com/XTLS/alpinelinux-install-xray](https://github.com/XTLS/alpinelinux-install-xray)

## Install v2rayA

### Download the binary executable file

According to your platform, obtain the <code>v2raya_linux_xxx</code> <a>file with v2raya_linux_xxx from Release</a> and rename it to `v2raya` , then move `v2raya` to `/usr/local/bin` and give executable permissions.

Example:

```bash
version=$(curl -s https://apt.v2raya.org/dists/v2raya/main/binary-amd64/Packages|grep Version|cut -d' ' -f2)
curl -L https://github.com/v2rayA/v2rayA/releases/download/v$version/v2raya_linux_x64_$version --output v2raya
mv ./v2raya /usr/local/bin/ && chmod +x /usr/local/bin/v2raya
```

You can use the `arch` command to query your platform architecture. For example, for the x86_64 architecture, you need to download the x64 version.

### Create a service file

Create a new file named `v2raya` under the `/etc/init.d/` directory, then edit it, and add the following content:

```sh
#!/sbin/openrc-run

name="v2rayA"
description="A Linux web GUI client of Project V which supports V2Ray, Xray, SS, SSR, Trojan and Pingtunnel"

command="/usr/local/bin/v2raya"
command_args="--log-file /var/log/v2raya/access.log"
error_log="/var/log/v2raya/error.log"
pidfile="/run/${RC_SVCNAME}.pid"
command_background="yes"
start_stop_daemon_args=" -e "V2RAYA_CONFIG=\"/usr/local/etc/v2raya"\""
rc_ulimit="-n 30000"
rc_cgroup_cleanup="yes"

depend() {
    need net
    after net
}

start_pre() {
   if [ ! -d "/tmp/v2raya/" ]; then
     mkdir "/tmp/v2raya"
   fi
   if [ ! -d "/var/log/v2raya/" ]; then
   ln -s "/tmp/v2raya/" "/var/log/"
   fi
}

```

Save the file, and then give the file executable permissions.

### Install the iptables module

```bash
apk add iptables ip6tables
```

### Run v2rayA and make it start while system boots (optional)

```bash
rc-service v2raya start
rc-update add v2raya
```

### View logs

```bash
tail -f /var/log/v2raya/access.log
```

### Other operations

#### Specify WebDir

Add a parameter `--webdir`  to `command_args` of the service file, and then specify the directory where the Web file is located. for example:

```ini
command_args=" --webdir=/usr/local/etc/v2raya/web"
```

#### Specify the core

Add a parameter `--v2ray-bin` to`command_args` of the service file, and then specify the directory where the kernel is located. for example:

```ini
command_args=" --v2ray-bin=/usr/local/bin/xray"
```
