---
title: "高级 DNS 设置"
description: "v2rayA 高级 DNS 设置介绍"
lead: "本节介绍高级 DNS 设置的用法和如何使用其他 DNS 客户端。"
date: 2020-11-16T13:59:39+01:00
lastmod: 2020-11-16T13:59:39+01:00
draft: false
images: []
menu:
  docs:
    parent: "advanced-application"
toc: true
weight: 670
---

## 常规用法

默认的防止 DNS 污染规则通常使用预设的 DNS 公共服务器，高级用户可使用高级 DNS 设置进行自定义。

规则如下：

```python
tcp://223.5.5.5 -> direct
119.29.29.29 -> direct
https://dns.google -> proxy
```

通常使用第一条规则进行 DNS 查询，当查询失败时将使用第二条，其后亦然。

使用 TCP 方式查询时应注意 DNS 是否支持 TCP 查询。

箭头右方的“出站名”表示使用左侧的 DNS 进行查询时使用的出站出口。

## 使用其他 DNS 客户端

有时我们希望使用其他 DNS 客户端，例如 AdGuard 的 dnsproxy 接管本机的 DNS 请求。本节介绍如何做到这点。本节默认你已开启透明代理。

### 当使用 redirect 模式时

当“透明代理实现方式”使用 redirect 时，将“防止DNS污染”设为关闭即可。

将“防止DNS污染”设为关闭后，v2ray-core 将不会设置 DNS 入站，从而避免 DNS 冲突。

redirect 模式下 UDP 流量不会经过 v2ray-core，而 TCP 流量会正常进行路由分流。因此其他 DNS 客户端的非常规 DNS 查询（非 `DNS over TCP` 和 `DNS over UDP`）会被当做常规流量进行路由分流。

### 当使用 tproxy 模式时

当“透明代理实现方式”使用 tproxy 时，将“防止DNS污染”设为关闭即可。否则，v2ray-core 会接管发往 53 端口的 DNS 请求，从而会对收到的 DNS 请求再次进行请求。当“防止 DNS 污染”开启时，使用设置中指定的 DNS 进行请求，从而使其他 DNS 客户端的设置失效。

当其他 DNS 客户端的上游 DNS 不为普通的 DNS 查询时不受上述影响（普通 DNS 查询意为 `DNS over TCP` 和 `DNS over UDP`），此时虽然 DNS 会经过 v2ray-core，但 v2ray-core 将认为这些请求并非 DNS 请求，从而当做正常流量进行路由分流。

因此，最保险的做法是将所有“其他 DNS 客户端”中所指定的 DNS 域名和 IP 都在 RoutingA 中设置直连。 RoutingA 的用法见 [RoutingA →]({{% relref "routingA" %}})
