---
title: "特殊模式"
description: "v2rayA 特殊模式的介绍"
lead: "目前 v2rayA 支持两种特殊模式，分别为 supervisor 和 fakedns，下面将介绍两种特殊模式的用途以及优缺点。"
date: 2020-11-16T13:59:39+01:00
lastmod: 2022-09-03T13:59:39+01:00
draft: false
images: []
menu:
  docs:
    parent: "manual"
toc: true
weight: 380
---

## supervisor

这是一种 DNS 污染解决方案。在透明代理的情况下，由于域名被污染为局域网或环回地址，而 v2ray 的透明代理默认跳过这些地址，不将其导入 v2ray-core，因此即使 v2ray-core 有域名嗅探（sniffing）的功能，也不能处理这些受污染的域名，只能处理污染为其他公网地址的域名。

v2rayA 通过 iptables 拦截被污染为环回地址的 DNS 请求，并通过 pcap 监测这些污染域名，将被污染的域名抢答为一个保留地址，这样该请求就会被导入 v2ray-core，通过 v2ray-core 的域名嗅探解决 DNS 污染。

由于 v2rayA 会持续监测网卡流量，导致 CPU 有额外占用，在性能较低的嵌入式设备或大流量场景慎用。

## fakedns

v2rayA 的透明代理依赖于域名嗅探（sniffing）功能，而 tor、telegram 等应用和域名嗅探有一定冲突，因此需要一种不开启域名嗅探的透明代理方案。当“防止DNS污染”开启时选项可见。

fakedns 的具体原理参见 [v2fly docs](https://www.v2fly.org/config/fakedns.html#%E8%BF%90%E8%A1%8C%E6%9C%BA%E5%88%B6%E5%8F%8A%E9%85%8D%E7%BD%AE%E6%96%B9%E5%BC%8F)。

fakedns 会污染 DNS 缓存，当代理断开之后的一段时间内设备可能无法访问网络。
