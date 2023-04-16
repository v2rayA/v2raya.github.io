---
title: "HTTP/Socks 带密码的入站"
description: "v2rayA 作为服务端进行内网传输介绍"
lead: "本节介绍如何在安全的内网环境下，使用 v2rayA 开启 HTTP/Socks5 入站连接并设置密码。"
date: 2020-11-16T13:59:39+01:00
lastmod: 2020-11-16T13:59:39+01:00
draft: false
images: []
menu:
  docs:
    parent: "advanced-application"
toc: true
weight: 690
---

## 设置带密码的 HTTP/Socks5 入站

v2rayA 利用 RoutingA 可以自由开启 HTTP/Socks5 入站，并设置密码。但即使设置了密码，HTTP/Socks5 仍不适合作为公网传输，也不适合在不信任的内网环境中使用，请仅在安全的内网环境下使用它们。

1. 将“规则端口的分流模式”选为“RoutingA”。

2. 在 RoutingA 设置中，在靠前位置插入如下规则：

   ```python
   inbound: httpauthin = http(address: 0.0.0.0, port: 1081, user: user1, pass: user1pass, user:user2, pass:user2pass)
   inbound: socksauthin = socks(address: 0.0.0.0, port: 1082, udp:true, user: 123, pass: 123)
   inbound: sockslocalin = socks(address: 127.0.0.1, udp:true, port: 1080)
   ```

   注意，不要将此处的端口和预设端口冲突。预设端口（如 20170）的关闭可在 `设置-地址与端口` 中进行。

   如不额外设置规则，此处的入站将遵守 RoutingA 设置。如需单独指定规则，可使用 `inboundTag`。更多 RoutingA 用法见 [RoutingA →]({{% relref "routingA" %}})

3. 保存并应用即可。
