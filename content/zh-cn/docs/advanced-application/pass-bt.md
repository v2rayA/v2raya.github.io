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
   inbound: socks_direct = socks(address: 0.0.0.0, port: 30000)
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

当 BT 应用运行在 Docker 时，默认的网络模式使用桥接模式（--network=bridge），此时容器会单独获得一个 IP 地址，使用 RoutingA 设置源 IP 地址直连即可。

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
