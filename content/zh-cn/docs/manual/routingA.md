---
title: "RoutingA 自定义路由分流"
description: "RoutingA 的介绍"
lead: "v2rayA可使用RoutingA书写路由，这是一种v2ray路由标记语言，它可被编译为v2ray-core所支持的json格式。"
date: 2020-11-16T13:59:39+01:00
lastmod: 2020-11-16T13:59:39+01:00
draft: false
images: []
menu:
  docs:
    parent: "manual"
toc: true
weight: 340
---

你可在“设置-规则端口的分流模式”中选择“RoutingA”来开启规则端口的自定义路由分流。如果你想为透明代理设置自定义路由分流，需要在上述设置的前提下，再将“设置-透明代理”选为“与规则端口所选模式一致”来启用。

## 示例

```bash
# 自定义入站 inbound，支持http, socks
inbound:httpauthin=http(address: 0.0.0.0, port: 1081, user: user1, pass: user1pass, user:user2, pass:user2pass)
inbound:socksauthin=socks(address: 0.0.0.0, port: 1082, user: 123, pass: 123)
inbound:sockslocalin=socks(address: 127.0.0.1, port: 1080)
inbound:sniffing_socks=socks(address: 127.0.0.1, port: 1080, sniffing: http, sniffing: tls)
inbound:sniffing_http=socks(address: 127.0.0.1, port: 1081, sniffing: 'http, tls')

# 自定义出站 outbound，支持http, socks, freedom
outbound:httpout=http(address: 127.0.0.1, port: 8080, user: 'my-username', pass: 'my-password')
outbound:socksout=socks(address: 127.0.0.1, port: 10800, user: "my-username", pass: "my-password")
outbound:special=freedom(domainStrategy: AsIs, redirect: "127.0.0.1:3366", userLevel: 0)

# 设置默认outbound，不设置则默认为proxy （该选项只作用于默认入站）
default: httpout

# 预设三个outbounds: proxy, block, direct

# 域名规则
domain(domain: v2raya.mzz.pub) -> socksout
domain(full: dns.google) -> proxy
domain(contains: facebook) -> proxy
domain(regexp: \.goo.*\.com$) -> proxy
domain(geosite:category-ads) -> block
domain(geosite:cn)->direct

# 目的IP规则
ip(8.8.8.8) -> direct
ip(101.97.0.0/16) -> direct
ip(geoip:private) -> direct

# 源IP规则
source(192.168.0.0/24) -> proxy
source(192.168.50.0/24) -> direct

# 目的端口规则
port(80) -> direct
port(10080-30000) -> direct

# 源端口规则
sourcePort(38563) -> direct
sourcePort(10080-30000) -> direct

# 多域名规则
domain(contains: google, domain: www.twitter.com, domain: mzz.pub) -> proxy
# 多IP规则
ip(geoip:cn, geoip:private) -> direct
ip(9.9.9.9, 223.5.5.5) -> direct
source(192.168.0.6, 192.168.0.10, 192.168.0.15) -> direct

# inbound 入站规则
inboundTag(httpauthin, socksauthin) -> direct
inboundTag(sockslocalin) -> special

# 同时满足规则
ip(geoip:cn) && port(80) && user(mzz2017@tuta.io) -> direct
ip(8.8.8.8) && network(tcp, udp) && port(1-1023, 8443) -> proxy
ip(1.1.1.1) && protocol(http) && source(10.0.0.1, 172.20.0.0/16) -> direct

```

更多概念请查看 [V2Ray-Routing](https://www.v2ray.com/chapter_02/03_routing.html)

+ 引号可省略，但包含特殊符号时不可省，如 `,`  `'` `"` 和  `)`
+ 暂不支持转义字符 `\`
+ 越早书写的路由规则将被优先匹配

## 常见用法

```bash
# 大陆白名单模式
default: proxy
# 国外域名即使有中国IP也要优先代理
# 注意，LoyalsoldierSite.dat 文件需要预先通过 v2rayA 下载
# 或者手动去它的仓库下载，然后保存为 LoyalsoldierSite.dat
# 仓库地址：https://github.com/Loyalsoldier/v2ray-rules-dat
# domain(ext:"LoyalsoldierSite.dat:geolocation-!cn")->proxy
domain(geosite:geolocation-!cn)->proxy
# scholar sites
domain(geosite:google-scholar)->proxy
domain(geosite:category-scholar-!cn, geosite:category-scholar-cn)->direct
domain(geosite:cn)->direct
ip(geoip:hk,geoip:mo)->proxy
ip(geoip:private, geoip:cn)->direct
```

```bash
# GFWList模式
default: direct
# 学术网站
domain(geosite:google-scholar)->proxy
domain(geosite:category-scholar-!cn, geosite:category-scholar-cn)->direct
# domain(ext:"LoyalsoldierSite.dat:gfw", ext:"LoyalsoldierSite.dat:greatfire")->proxy
domain(geosite:geolocation-!cn)->proxy
# Telegram
# 下面这条注释掉的规则需要来自 Loyalsoldiser 的 IP 文件
# 仓库地址 https://github.com/Loyalsoldier/geoip/
# 下载后可将其保存为 LoyalsoldierIP.dat
# ip(ext:"LoyalsoldierIP.dat:telegram")->proxy
ip(91.108.4.0/22,91.108.8.0/22,91.108.56.0/22,95.161.64.0/20,149.154.160.0/22,149.154.164.0/22,"2001:67c:4e8::/48")->proxy
```

```bash
# 使用自定义DAT文件（需要将其放入正确目录）
# https://github.com/onplus/v2ray-SiteDAT
domain(ext:"yourdatfile.dat:yourtag")->direct
```

```bash
# 带认证和路由的端口
inbound: socksauthin=socks(address: 0.0.0.0, port: 1080, user: 123, pass: 123)
inbound: httpauthin=http(address: 0.0.0.0, port: 1081, user: 123, pass: 123)

inboundTag(socksauthin, httpauthin)->direct
```

```bash
# 不同inbound流量走不同的outbound
inbound: crawlerin = http(address:127.0.0.1,port:30001)
inbound: crawlerin2 = http(address:127.0.0.1,port:30002)
inbound: crawlerin3 = http(address:127.0.0.1,port:30003)
inbound: crawlerin4 = http(address:127.0.0.1,port:30004)

inboundTag(crawlerin)->crawler
inboundTag(crawlerin2)->crawler2
inboundTag(crawlerin3)->crawler3
inboundTag(crawlerin4)->crawler4

```
