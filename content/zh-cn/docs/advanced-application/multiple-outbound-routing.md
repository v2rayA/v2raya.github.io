---
title: "多节点分流"
description: "v2rayA 多节点分流的介绍"
lead: "本节介绍如何利用多出站进行流媒体分流、爬虫分流等多节点分流的应用。"
date: 2020-11-16T13:59:39+01:00
lastmod: 2020-11-16T13:59:39+01:00
draft: false
images: []
menu:
  docs:
    parent: "advanced-application"
toc: true
weight: 620
---

## 介绍

v2rayA 支持设置多个出站组（outbound），通过 RoutingA 可以设置根据不同的入站、源地址、目的地址等选择不同的出站，以实现各种复杂功能。

## 流媒体分流

流媒体分流即访问不同的流媒体时，使用不同的服务器节点。例如观看奈非时使用可观看奈非的服务器节点，而正常冲浪时使用更快速的 IPLC 节点，BT 下载时使用流量更多的荷兰服务器节点。下面是分流方法：

1. 在 v2rayA 的左上方新增两个出站，名为 Netflix 和 Disney。此时我们有三个出站：proxy、Netflix、Disney。

2. 依次选择出站，在每个出站的界面中连接特定的服务器节点。

3. 将“透明代理”选为“与规则端口所选模式一致”；将“规则端口的分流模式”选为“RoutingA”。

   {{% notice note %}}
   如果你不使用透明代理则无需设置透明代理，只需将“规则端口的分流模式”选为“RoutingA”即可。而后使用规则端口进行代理上网。
   {{% /notice %}}

4. 在 RoutingA 设置中，在靠前位置插入如下规则：

   ```python
   domain(geosite: netflix) -> Netflix
   domain(geosite: disney) -> Disney
   ```

5. 保存并应用即可。

## 爬虫分流

爬虫往往需要使用多个代理 IP 加速爬取速度。例如我们需要设置 5 个 IP 组，名为 Crawler1、Crawler2、Crawler3、Crawler4、Crawler5，通过 5 个不同的入站端口分别使用这 5 个 IP 组出口。

1. 在 v2rayA 的左上方新增 5 个出站，名为 Crawler1、Crawler2、Crawler3、Crawler4、Crawler5。

2. 依次选择出站，在每个出站的界面中连接特定的服务器节点。

3. 将“规则端口的分流模式”选为“RoutingA”。

4. 在 RoutingA 设置中，在靠前位置插入如下规则：

   ```python
   inbound: crawlerin1 = http(address:127.0.0.1, port:30001)
   inbound: crawlerin2 = http(address:127.0.0.1, port:30002)
   inbound: crawlerin3 = http(address:127.0.0.1, port:30003)
   inbound: crawlerin4 = http(address:127.0.0.1, port:30004)
   inbound: crawlerin5 = http(address:127.0.0.1, port:30005)
   
   inboundTag(crawlerin1)->Crawler1
   inboundTag(crawlerin2)->Crawler2
   inboundTag(crawlerin3)->Crawler3
   inboundTag(crawlerin4)->Crawler4
   inboundTag(crawlerin5)->Crawler5
   ```

5. 保存并应用。

6. 在爬虫应用中使用 30001-30005 端口以选择不同的 IP 出口。

{{% notice note %}}
截至 2021-10-12，尽管 v2ray-core 支持 random 的负载均衡方式，但由于该方式并不结合观测结果以保证节点的可用性，导致随机到的节点有服务不可用的风险，因此 v2rayA 暂不支持 random 的负载均衡。
{{% /notice %}}
