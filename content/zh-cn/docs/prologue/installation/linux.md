---
title: Linux 后备安装方式
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

此处列举了一些后备安装方法，使用这些方法之前，请确认这些方法是否与你的操作系统兼容。

## 方法一：Snap 商店

Snap 是 Ubuntu 开发的通用软件包格式，可以在大多数 Linux 发行版上运行。要通过 Snap 商店安装 v2rayA，请访问：

<https://snapcraft.io/v2raya>

Snap 软件包内已经包含了 v2ray core，用户无需额外安装核心。

Snap 包的打包详情可以[在 GitHub 上](https://github.com/v2rayA/v2rayA-snap)查看。

## 方法二：安装脚本

脚本仓库：<https://github.com/v2rayA/v2rayA-installer>

与 v2ray core 一起安装：

```sh
sudo sh -c "$(wget -qO- https://hubmirror.v2raya.org/v2rayA/v2rayA-installer/raw/main/installer.sh)" @ --with-v2ray
```

与 xray core 一起安装：

```sh
sudo sh -c "$(wget -qO- https://hubmirror.v2raya.org/v2rayA/v2rayA-installer/raw/main/installer.sh)" @ --with-xray
```

如果你更倾向于使用 `curl` 而不是 `wget`，那么把 `wget -qO-` 换成 `curl -Ls` 即可。

## 方法三：手动安装

### 下载 v2ray/xray core

> v2ray core: <https://github.com/v2fly/v2ray-core></br>
> xray core: <https://github.com/XTLS/Xray-core>

下载的时候需要注意你的 CPU 架构，下载好之后解开压缩包，然后把可执行文件复制到 `/usr/local/bin/` 或 `/usr/bin/`（推荐前者），把几个 dat 格式的文件复制到 `/usr/local/share/v2ray/` 或者 `/usr/share/v2ray/`（推荐前者，xray 用户记得把文件放到 xray 文件夹），最后授予 v2ray/xray 可执行权限。

以下是用 bash 命令操作的示例（假设命令在 root 用户下运行）：

```sh
pushd /tmp
wget https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip
unzip v2ray-linux-64.zip -d ./v2ray
mkdir -p /usr/local/share/v2ray && cp ./v2ray/*dat /usr/local/share/v2ray
install -Dm755 ./v2ray/v2ray /usr/local/bin/v2ray
rm -rf ./v2ray v2ray-linux-64.zip
popd
```

### 下载 v2rayA

v2rayA 只有一个单独的二进制，下载下来放到 `/usr/local/bin/` 或 `/usr/bin/`（推荐前者）即可。和下载 v2ray 一样，下载的时候需要注意你的 CPU 架构。

```sh
pushd /tmp
version="$(wget -qO- https://apt.v2raya.org/dists/v2raya/main/binary-amd64/Packages | grep Version cut -d' ' -f2)"
wget https://github.com/v2rayA/v2rayA/releases/download/v$version/v2raya_linux_x64_$version
install -Dm755 ./v2raya_linux_x64_$version /usr/local/bin/v2raya
popd
```

### 运行

一般情况下，在终端里面直接运行 `v2raya` 命令即可，配置文件夹默认会是 `/etc/v2raya/`。不过，为了方便，在 Linux 系统上一般采用服务的形式运行 v2rayA.

#### Systemd 服务

注意：</br>

1. 为符合 FHS 的要求，本服务示例把配置文件夹修改到了 `/usr/local/etc/v2raya/`。</br>
2. 可创建 `/etc/systemd/system/v2raya.service.d/` 文件夹。并在其中保留你的自定义配置。

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

文件需要保存到 `/etc/systemd/system/v2raya.service`，然后执行：

```sh
systemctl daemon-reload
systemctl enable --now v2raya
```

#### OpenRC 服务脚本

注意：</br>

1. 为符合 FHS 的要求，本服务示例把配置文件夹修改到了 `/usr/local/etc/v2raya`。</br>
2. 复制脚本的时候必须保留第一行，否则会报错。

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

文件需要保存到 `/etc/init.d/v2raya`，并授予可执行权限。

#### 其它 init 系统

1. runit: <http://smarden.org/runit/></br>
2. s6: <https://skarnet.org/software/s6-linux-init/></br>
3. dinit: <https://github.com/davmac314/dinit></br>
4. more...

这些 init 系统暂无可用的示例，建议查看官网文档自行撰写服务脚本或服务配置文件。
