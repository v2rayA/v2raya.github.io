---
title: RoutingA 自定义路由分流
description: Introduction of RoutingA
lead: v2rayA can use RoutingA to write routes, which is a v2ray routing markup language, which can be compiled into the json format supported by v2ray-core.
date: '2020-11-16 13:59:39 +0100'
lastmod: '2020-11-16 13:59:39 +0100'
draft: 'false'
images: []
menu:
  docs:
    parent: manual
toc: 'true'
weight: '340'
---

You can select "RoutingA" in "Settings - Distribution Mode of Rule Ports" to enable custom routing distribution of regular ports. If you want to set a custom route for the transparent proxy, you need to set the "Settings - Transparent Proxy" to "Consistent with the selected mode of the rule port" to enable it under the premise of the above settings.

## Example

```bash
# Customize inbound inbound, support http, socks
inbound:httpauthin=http(address: 0.0.0.0, port: 1081, user: user1, pass: user1pass, user:user2, pass:user2pass)
inbound:socksauthin=socks(address: 0.0.0.0, port: 1082, user: 123, pass: 123)
inbound:sockslocalin=socks(address: 127.0.0.1, port: 1080)
inbound:sniffing_socks=socks(address: 127.0.0.1, port: 1080, sniffing: http, sniffing: tls)
inbound:sniffing_http=http(address: 127.0.0.1, port: 1081, sniffing: 'http, tls';)

# Customize outbound outbound, support http, socks, freedom
outbound:httpout=http(address: 127.0.0.1, port: 8080, user: 'my-username', pass: 'my-password')
outbound:socksout=socks(address: 127.0.0.1, port: 10800, user: "my-username", pass: "my-password")
outbound:special=freedom(domainStrategy: AsIs, redirect: "127.0.0.1:3366", userLevel: 0)

# Set the default outbound, if not set, the default is proxy (this option only applies to the default inbound)
default: httpout

# Default three outbounds: proxy, block, direct

# Domain name rules
domain(domain: v2raya.org) -> socksout
domain(full: dns.google) -> proxy
domain(contains: facebook) -> proxy
domain(regexp: \.goo.*\.com$) -> proxy
domain(geosite:category-ads) -> block
domain(geosite:cn)->direct

# Destination IP rules
ip(8.8.8.8) -> direct
ip(101.97.0.0/16) -> direct
ip(geoip:private) -> direct

# source IP rule
source(192.168.0.0/24) -> proxy
source(192.168.50.0/24) -> direct

# Destination port rules
port(80) -> direct
port(10080-30000) -> direct

# source port rules
sourcePort(38563) -> direct
sourcePort(10080-30000) -> direct

# Multi-domain rules
domain(contains: google, domain: www.twitter.com, domain: v2raya.org) -> proxy
# Multiple IP rules
ip(geoip:cn, geoip:private) -> direct
ip(9.9.9.9, 223.5.5.5) -> direct
source(192.168.0.6, 192.168.0.10, 192.168.0.15) -> direct

# inbound inbound rules
inboundTag(httpauthin, socksauthin) -> direct
inboundTag(sockslocalin) -> special

# Also satisfy the rules
ip(geoip:cn) && port(80) && user(mzz2017@tuta.io) -> direct
ip(8.8.8.8) && network(tcp, udp) && port(1-1023, 8443) -> proxy
ip(1.1.1.1) && protocol(http) && source(10.0.0.1, 172.20.0.0/16) -> direct

```

For more concepts, please check [V2Ray-Routing](https://www.v2ray.com/chapter_02/03_routing.html)

- Quotation marks can be omitted, but cannot be omitted when they contain special symbols, such as `,` `'` `"` and `)`
- Escape character `\` is not supported yet
- Routing rules written earlier will be matched first

Also refer to [V2Ray Beginner's Guide](https://guide.v2fly.org/en_US/routing/routing.html)

## Common usage

```bash
# Mainland China whitelist mode
default: proxy
# Even if there is a Chinese IP, the foreign domain name should be given priority to proxy
# Note that the LoyalsoldierSite.dat file needs to be downloaded via v2rayA in advance
# Or manually go to its repository to download, then save as LoyalsoldierSite.dat
# Warehouse address: https://github.com/Loyalsoldier/v2ray-rules-dat
# domain(geosite:google-scholar)->proxy
domain(geosite:category-scholar-!cn, geosite:category-scholar-cn)->direct
domain(geosite:cn)->direct
ip(geoip:hk,geoip:mo)->proxy
ip(geoip:private, geoip:cn)->direct
```

```bash
# GFWList mode
default: direct
# Academic website
domain(geosite:google-scholar)->proxy
domain(geosite:category-scholar-!cn, geosite:category-scholar-cn)->direct
# domain(ext:"LoyalsoldierSite.dat:gfw", ext:"LoyalsoldierSite.dat:greatfire")->proxy
domain(geosite:geolocation-!cn)->proxy
# Telegram
# The commented out rule below requires the IP file from Loyalsoldiser
# Warehouse address https://github.com/Loyalsoldier/geoip/
# After downloading it can be saved as LoyalsoldierIP.dat
# ip(ext:"LoyalsoldierIP.dat:telegram")->proxy
ip("91.105.192.0/23","91.108.4.0/22","91.108.8.0/21","91.108.16.0/21","91.108.56.0/22","95.161.64.0/20","149.154.160.0/20","185.76.151.0/24","2001:67c:4e8::/48","2001:b28:f23c::/47","2001:b28:f23f::/48","2a0a:f280:203::/48")->proxy
```

```bash
# Use a custom DAT file (needs to put it in the correct directory)
# https://github.com/onplus/v2ray-SiteDAT
domain(ext:"yourdatfile.dat:yourtag")->direct
```

```bash
# Ports with Authentication and Routing
inbound: socksauthin=socks(address: 0.0.0.0, port: 1080, user: 123, pass: 123)
inbound: httpauthin=http(address: 0.0.0.0, port: 1081, user: 123, pass: 123)

inboundTag(socksauthin, httpauthin)->direct
```

```bash
# Different inbound traffic goes to different outbound
inbound: crawlerin = http(address:127.0.0.1,port:30001)
inbound: crawlerin2 = http(address:127.0.0.1,port:30002)
inbound: crawlerin3 = http(address:127.0.0.1,port:30003)
inbound: crawlerin4 = http(address:127.0.0.1,port:30004)

inboundTag(crawlerin)->crawler
inboundTag(crawlerin2)->crawler2
inboundTag(crawlerin3)->crawler3
inboundTag(crawlerin4)->crawler4

```
