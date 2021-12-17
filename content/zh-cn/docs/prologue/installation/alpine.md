---
title: "Alpine"
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

{{% notice info %}}
如果你已经安装了内核，可以跳过此节。
{{% /notice %}}

### 方法 1：从软件包管理器安装

从 Alpine Linux 3.15 开始，V2Ray 已经进入了 Community 源。编辑 apk 的配置以启用 Community 源：

```bash
vi /etc/apk/repositories
```

```ini
http://dl-cdn.alpinelinux.org/alpine/v3.15/main
http://dl-cdn.alpinelinux.org/alpine/v3.15/community
```

然后安装 V2Ray：

```bash
apk update && apk add v2ray
```

### 方法 2：V2Ray / Xray 的官方脚本

V2Ray 安装参考：<https://github.com/v2fly/alpinelinux-install-v2ray>

Xray 安装参考：<https://github.com/XTLS/alpinelinux-install-xray>

## 安装 v2rayA

### 下载二进制可执行文件

根据你的平台，从 [Release](https://github.com/v2rayA/v2rayA/releases) 获取具有 `v2raya_linux_xxx` 字样的无后缀名文件，并将其重命名为 `v2raya`，再把 `v2raya` 移动到 `/usr/local/bin` 并给予可执行权限。

示例：
  
```bash
version=$(curl -s https://apt.v2raya.mzz.pub/dists/v2raya/main/binary-amd64/Packages|grep Version|cut -d' ' -f2)
curl -L https://github.com/v2rayA/v2rayA/releases/download/v$version/v2raya_linux_x64_$version --output v2raya
mv ./v2raya /usr/local/bin/ && chmod +x /usr/local/bin/v2raya
```

可以使用 `arch` 命令来查询你的平台架构，比如 x86_64 的架构就需要下载 x64 的版本。

### 创建服务文件

在 `/etc/init.d/` 目录下面新建一个名为 `v2raya` 的文本文件，然后编辑，添加内容如下：

```ini
#!/sbin/openrc-run

name="v2rayA"
description="A Linux web GUI client of Project V which supports V2Ray, Xray, SS, SSR, Trojan and Pingtunnel"

command="/usr/local/bin/v2raya"
command_args="--log-disable-timestamp"
pidfile="/run/${RC_SVCNAME}.pid"
output_logger="/usr/bin/logger"
error_logger="/usr/bin/logger"
command_background="yes"
start_stop_daemon_args=" -e "V2RAYA_CONFIG=\"/usr/local/etc/v2raya"\""

depend() {
    need net
}
```

保存文件，然后给予此文件可执行权限。

### 安装 iptables 模块

```bash
apk add iptables ip6tables
```

### 运行 v2rayA 并开机启动（可选）

```bash
rc-service v2raya start
rc-update add v2raya
```

### 查看日志

```bash
tail -f /var/log/messages
```

### 其它操作

#### 指定 WebDir

在服务文件的 `command_args` 中加上一个参数 `--webdir`，然后指定到 Web 文件所在目录即可。比如：

```ini
command_args="--log-disable-timestamp --webdir=/usr/local/etc/v2raya/web"
```

#### 指定内核

在服务文件的 `command_args` 中加上一个参数 `--v2ray-bin`，然后指定到内核所在目录即可。比如：

```ini
command_args="--log-disable-timestamp --v2ray-bin=/usr/local/bin/xray"
```
