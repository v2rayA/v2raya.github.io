---
title: "BT 下载直连"
description: "v2rayA BT 下载直连介绍"
lead: "本节介绍如何在开启透明代理时控制 BT 流量直连。"
date: 2020-11-16T13:59:39+01:00
lastmod: 2020-11-16T13:59:39+01:00
draft: false
images: []
menu:
  docs:
    parent: "advanced-application"
toc: true
weight: 640
---

## 方法 1：为 BT 应用设置单独的直连端口

大多数 BT 应用可以设置 HTTP/Socks 代理，此时为 v2rayA 开放一个直连端口，将所有 BT 流量通过该端口即可。

1. 将“透明代理”选为“与规则端口所选模式一致”；将“规则端口的分流模式”选为“RoutingA”。

2. 使用 RoutingA 开放一个直连端口：

   ```python
   inbound: socks_direct = socks(address: 0.0.0.0, port: 30000, udp:true)
   # 下条规则需要插入靠前位置
   inboundTag(socks_direct) -> direct
   ```

3. 将 BT 应用的代理设置为上述直连端口。

## 方法 2：将 BT 应用运行在 Docker 中

与 [指定 Docker 容器代理]({{% relref "specify-container-proxy" %}}) 中所列方法类似，我们可以使得在 Docker 容器中的 BT 应用直连。

{{% notice info %}}
此方法只能适用于 v2rayA 与要直连的 BT 应用在同一台机器的情况。
{{% /notice %}}

### 当使用 tproxy 模式时

由于透明代理实现方式为 tproxy 时，暂时无法代理桥接模式的 docker 容器，因此使用 tproxy 时所有容器都会直连，以达到目的。

### 当使用 redirect 模式时

透明代理使用 redirect 模式可代理 Docker 容器。下面使用一些技巧来使得特定 BT 容器直连。

当 BT 应用运行在 Docker 时，默认的网络模式使用桥接模式（`--network=bridge`），此时容器会单独获得一个 IP 地址，使用 RoutingA 设置源 IP 地址直连即可。

1. 将 BT 应用运行于 docker 容器。

2. 获得容器的 IP 地址，例如：

   ```bash
   docker exec <container_id or container_name> ip addr
   ```

   其中容器 ID 可通过 `docker ps` 取得。

3. 将“透明代理”选为“与规则端口所选模式一致”；将“规则端口的分流模式”选为“RoutingA”。

4. 在 RoutingA 中，在较为靠前的位置插入一条规则，配置源 IP 地址直连，例如：

   ```python
   source(172.17.0.212) -> direct
   ```

当 docker 服务重启时，容器的 IP 地址可能会发生变化，因此需要固定容器的 IP 地址，方法参见 [StackOverflow](https://stackoverflow.com/questions/27937185/assign-static-ip-to-docker-container) 上的讨论。

## 方法3：利用生命周期钩子使特定用户或组直连

下面给出利用生命周期钩子修改透明代理规则，使得以 v2raya-skip 组运行的程序直连的例子，该方法可使得特定程序的所有流量均不经过 v2ray-core。生命周期钩子的介绍见 [生命周期钩子]({{% relref "hook" %}}) 一节。

注意，由于 docker 容器中的用户和组与宿主中的用户和组是隔离的，因此该方法对 docker 容器内的程序并不能生效。

首先创建用户组：

```bash
sudo groupadd v2raya-skip
```

而后，编写如下脚本，将其存储于 `/etc/v2raya/tproxy-hook.sh` ：

```bash
#!/bin/bash

# parse the arguments
for i in "$@"; do
  case $i in
    --transparent-type=*)
      TYPE="${i#*=}"
      shift
      ;;
    --stage=*)
      STAGE="${i#*=}"
      shift
      ;;
    -*|--*)
      echo "Unknown option $i"
      shift
      ;;
    *)
      ;;
  esac
done


case "$STAGE" in
post-start)
  # at the post-start stage
  # we first check the $TYPE so we know which table should we insert into
  if [ "$TYPE" = "tproxy" ]; then
    TABLE=mangle
  elif [ "$TYPE" = "redirect" ]; then
    TABLE=nat
  else
    echo "unexpected transparent type: ${TYPE}"
    exit 1
  fi
  # print what we are excuting and exit if it fails
  set -ex
  # insert the iptables rules for ipv4 and ipv6
  iptables -t "$TABLE" -I TP_OUT -m owner --gid-owner v2raya-skip -j RETURN
  ip6tables -t "$TABLE" -I TP_OUT -m owner --gid-owner v2raya-skip -j RETURN
  ;;
pre-stop)
  # we do nothing here because the TP_OUT chain will be flushed automatically by v2rayA.
  # we can also do it manually.
  ;;
*)
  ;;
esac

exit 0
```

赋予可执行权限：

```bash
sudo chmod +x /etc/v2raya/tproxy-hook.sh
```

启动 v2raya 时添加透明代理生命周期钩子，添加参数 `--transparent-hook /etc/v2raya/tproxy-hook.sh`。

使用指定组启动需要绕过的程序，以 curl 为例：

```bash
# 使用 sg
sudo sg v2raya-skip 'curl ip.sb'
# 或使用 su
sudo su -g v2raya-skip -c 'curl ip.sb'
```

同理，可使用类似命令启动 BT 下载程序，以达到不经过 v2ray-core 的直连效果。

使得使用指定用户启动的程序直连的方法思路同上，将 `--gid-owner` 换为 `--uid-owner` 即可。
