---
title: "环境变量和命令行参数"
description: "v2rayA 环境变量和命令行参数的介绍"
lead: ""
date: 2020-11-16T13:59:39+01:00
lastmod: 2020-11-27T13:59:39+01:00
draft: false
images: []
menu:
  docs:
    parent: "manual"
toc: true
weight: 600
---

## 介绍

### 环境变量

{{% notice info %}}
本节所列变量有可能已过时，可通过 v2raya --help 查看支持的参数，环境变量与之对应。
{{% /notice %}}

`V2RAYA_ADDRESS`: 监听地址 (默认 "0.0.0.0:2017")

`V2RAYA_CONFIG`: v2rayA 配置文件目录 (默认 "/etc/v2raya")

`V2RAYA_V2RAY_BIN`: v2ray 可执行文件路径。留空将自动检测。可修改为 v2ray 分支如 xray 等文件路径。

`V2RAYA_V2RAY_CONFDIR`: 附加的 v2ray 配置文件目录，该目录中的 v2ray 配置文件会与 v2rayA 生成的配置文件进行组合。

`V2RAYA_WEBDIR`: v2rayA 前端 GUI 文件目录，如不指定，将使用二进制内嵌 GUI 文件。

`V2RAYA_PLUGINLISTENPORT`: v2rayA 内部插件端口 (默认 32346)

`V2RAYA_FORCE_IPV6_ON`: 跳过检查，强制启用 IPv6 的支持。

`V2RAYA_PASSCHECKROOT`: 跳过 root 权限检测，确认你有 root 权限而 v2rayA 判断出错时使用，或者使用非 root 用户时使用。

`V2RAYA_VERBOSE`: 详细日志模式，混合打印 v2ray-core 和 v2rayA 的运行日志。将在之后的版本被遗弃。

`V2RAYA_RESET_PASSWORD`: 重设密码。

### 命令行参数

与环境变量对应，详情使用下列命令查看：

```bash
v2raya --help
```

## 如何设置

下面将以指定`V2RAYA_V2RAY_BIN`为xray为例，介绍各个环境下的设置方法。

### systemd 管理的 v2rayA

使用 apt 等包管理器，或直接使用安装包进行安装的，一般都为这种方式。

1. 新建文件夹 `/etc/systemd/system/v2raya.service.d`，然后新建一个 `xray.conf` 的文件，添加以下内容：

   ```conf
   [Service]
   Environment="V2RAYA_V2RAY_BIN=/usr/local/bin/xray"
   ```

   注意检查 Xray 的路径是否正确。

2. 重载服务：

   ```bash
   sudo systemctl daemon-reload && sudo systemctl restart v2raya
   ```

### OpenWrt

修改 `command` ，例如：

```conf
#!/bin/sh /etc/rc.common
command="/usr/bin/v2raya --v2ray-bin=/usr/bin/xray"
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

再重启服务即可。

### Alpine

修改 `/etc/init.d/v2raya`中的`command_args`，例如：

```conf
#!/sbin/openrc-run

name="v2rayA"
description="A Linux web GUI client of Project V which supports V2Ray, Xray, SS, SSR, Trojan and Pingtunnel"
command="/usr/local/bin/v2raya"
command_args="--config=/usr/local/etc/v2raya --v2ray-bin=/usr/local/bin/xray"
pidfile="/run/${RC_SVCNAME}.pid"
command_background="yes"

depend() {
    need net
}
```

再重启服务即可。

### Docker

使用`-e`指定环境变量，下例修改监听端口为2021：

```bash
# run v2raya
docker run -d \
  --restart=always \
  --privileged \
  --network=host \
  --name v2raya \
  -e V2RAYA_ADDRESS=0.0.0.0:2021 \
  -v /lib/modules:/lib/modules \
  -v /etc/resolv.conf:/etc/resolv.conf \
  -v /etc/v2raya:/etc/v2raya \
  mzz2017/v2raya
```
