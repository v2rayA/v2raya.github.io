---
title: Linux Fallback Installation Method
description: Install the V2Ray core and v2rayA
date: '2023-9-5 13:10:00 +0100'
lastmod: '2023-9-5 13:10:00 +0100'
draft: 'false'
images: []
menu:
  docs:
    parent: installation
weight: '15'
toc: 'true'
---

Here are some fallback installation methods. Before using these methods, please confirm whether they are compatible with your operating system.

## Method 1: Snap Store

Snap is a universal software package format developed by Ubuntu that runs on most Linux distributions. To install v2rayA via Snap Store, please visit:

<https://snapcraft.io/v2raya>

The v2ray core is already included in the Snap software package, and users do not need to install additional cores.

The packaging details of the Snap package can be viewed [on GitHub](https://github.com/v2rayA/v2rayA-snap).

## Method 2: Install script

Script repository: <https://github.com/v2rayA/v2rayA-installer>

Install with v2ray core:

```sh
sudo sh -c "$(wget -qO- https://hubmirror.v2raya.org/v2rayA/v2rayA-installer/raw/main/installer.sh)" @ --with-v2ray
```

Install with xray core:

```sh
sudo sh -c "$(wget -qO- https://hubmirror.v2raya.org/v2rayA/v2rayA-installer/raw/main/installer.sh)" @ --with-xray
```

If you prefer to use `curl` instead of `wget`, then replace `wget -qO-` with `curl -Ls`.

## Method 3: Manual installation

### Download v2ray/xray core

> v2ray core: <https://github.com/v2fly/v2ray-core></br>
> xray core: <https://github.com/XTLS/Xray-core>

When downloading, you need to pay attention to your CPU architecture. After downloading, unzip the compressed package, and then copy the executable file to `/usr/local/bin/` or `/usr/bin/` (the former is recommended), put a few Copy the file in dat format to `/usr/local/share/v2ray/` or `/usr/share/v2ray/` (the former is recommended, xray users remember to put the file in the xray folder), and finally grant v2ray/xray executable permission.

The following is an example of using the bash command (assuming the command is run under the root user):

```sh
pushd /tmp
wget https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip
unzip v2ray-linux-64.zip -d ./v2ray
mkdir -p /usr/local/share/v2ray && cp ./v2ray/*dat /usr/local/share/v2ray
install -Dm755 ./v2ray/v2ray /usr/local/bin/v2ray
rm -rf ./v2ray v2ray-linux-64.zip
popd
```

### Download v2rayA

v2rayA only has a single binary, download it and put it in `/usr/local/bin/` or `/usr/bin/` (the former is recommended). Just like downloading v2ray, you need to pay attention to your CPU architecture when downloading.

```sh
pushd /tmp
version="$(wget -qO- https://apt.v2raya.org/dists/v2raya/main/binary-amd64/Packages | grep Version cut -d' ' -f2)"
wget https://github.com/v2rayA/v2rayA/releases/download/v$version/v2raya_linux_x64_$version
install -Dm755 ./v2raya_linux_x64_$version /usr/local/bin/v2raya
popd
```

### Run

Under normal circumstances, you can run the `v2raya` command directly in the terminal. The default configuration folder will be `/etc/v2raya/`. However, for convenience, v2rayA is generally run as a service on Linux systems.

#### Systemd Services

Notice:</br>

1. In order to comply with the requirements of FHS, this service example has modified the configuration folder to `/usr/local/etc/v2raya/`.</br>
2. You can create the `/etc/systemd/system/v2raya.service.d/` folder. And keep your custom configuration in it.

```ini
[Unit]
Description=A web GUI client of Project V which supports VMess, VLESS, SS, SSR, Trojan, Tuic and Juicity protocols
Documentation=https://v2raya.org
After=network.target nss-lookup.target iptables.service ip6tables.service nftables.service
Wants=network.target

[Service]
Environment="V2RAYA_CONFIG=/usr/local/etc/v2raya"
Environment="V2RAYA_LOG_FILE=/tmp/v2raya.log"
Type=simple
User=root
LimitNPROC=500
LimitNOFILE=1000000
ExecStart=/usr/local/bin/v2raya
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

The file needs to be saved to `/etc/systemd/system/v2raya.service` and then executed:

```sh
systemctl daemon-reload
systemctl enable --now v2raya
```

#### OpenRC service script

Notice:</br>

1. In order to comply with the requirements of FHS, this service example has modified the configuration folder to `/usr/local/etc/v2raya`.</br>
2. When copying the script, you must keep the first line, otherwise an error will be reported.

```sh
#!/sbin/openrc-run

name="v2rayA"
description="A web GUI client of Project V which supports VMess, VLESS, SS, SSR, Trojan, Tuic and Juicity protocols"
command="/usr/local/bin/v2raya"
error_log="/var/log/v2raya/error.log"
pidfile="/run/${RC_SVCNAME}.pid"
command_background="yes"
rc_ulimit="-n 30000"
rc_cgroup_cleanup="yes"

depend() {
     need net
     after net
}

start_pre() {
    export V2RAYA_CONFIG="/usr/local/etc/v2raya"
    export V2RAYA_LOG_FILE="/tmp/v2raya/access.log"
    if [ ! -d "/tmp/v2raya/" ]; then
      mkdir "/tmp/v2raya"
    fi
    if [ ! -d "/var/log/v2raya/" ]; then
    ln -s "/tmp/v2raya/" "/var/log/"
    fi
}
```

The file needs to be saved to `/etc/init.d/v2raya` and given executable permissions.

#### Other init systems

1. runit: <http://smarden.org/runit/></br>
2. s6: <https://skarnet.org/software/s6-linux-init/></br>
3. dinit: <https://github.com/davmac314/dinit></br>
4. more...

There are currently no examples available for these init systems. It is recommended to check the official website documentation and write your own service scripts or service configuration files.
