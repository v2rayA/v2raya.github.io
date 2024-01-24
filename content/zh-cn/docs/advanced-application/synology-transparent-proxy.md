---
title: "群晖实现透明代理"
description: "群晖实现透明代理的配置方法"
lead: "本节介绍群晖实现透明代理的配置方法"
date: 2022-02-06T13:59:39+01:00
lastmod: 2022-02-06T13:59:39+01:00
draft: false
images: []
menu:
  docs:
    parent: "advanced-application"
toc: true
weight: 660
---

{{% notice info %}}
安装也是采用Docker的方式，所以首先确认你的群晖系统是否支持Docker
{{% /notice %}}

## 补齐缺失的iptables模块

按照 [Docker安装]({{% relref "docker" %}}) 之后，启用redirect或tproxy透明代理模式，类似旁路由模式，就会遇到iptables缺失相关的报错。群晖系统是一个定制版Linux系统，透明代理需要的iptables相关模块并没有包含，所以解决方案就是补齐缺失的iptables模块，具体参考 [syno-iptables](https://github.com/sjtuross/syno-iptables) 下载安装预编译模块或者自编译。

## 加载缺失的模块并启动容器

在v2rayA启动时，为了确保所需的内核模块已经加载，可以覆盖默认的entrypoint为一个脚本，负责加载模块然后启动v2rayA，以下为docker run示例。

```bash
docker run -d \
  --restart=always \
  --privileged \
  --network=host \
  --name v2raya \
  -e V2RAYA_ADDRESS=0.0.0.0:2017 \
  -v /lib/modules:/lib/modules \
  -v /usr/lib/iptables:/usr/lib/iptables:ro \
  -v /sbin/iptables:/usr/local/bin/iptables:ro \
  -v /sbin/iptables-legacy:/usr/local/bin/iptables-legacy:ro \
  -v /sbin/iptables-legacy-restore:/usr/local/bin/iptables-legacy-restore:ro \
  -v /sbin/iptables-legacy-save:/usr/local/bin/iptables-legacy-save:ro \
  -v /sbin/iptables-restore:/usr/local/bin/iptables-restore:ro \
  -v /sbin/iptables-save:/usr/local/bin/iptables-save:ro \
  -v /sbin/iptables-xml:/usr/local/bin/iptables-xml:ro \
  -v /etc/resolv.conf:/etc/resolv.conf \
  -v /volume1/docker/v2raya-config:/etc/v2raya \
  --entrypoint /etc/v2raya/bootstrap.sh \
  mzz2017/v2raya
```

{{% notice info %}}
替换 /volume1/docker/v2raya-config 为你自己挂载的配置目录
{{% /notice %}}

以DS3617xs 6.2.3-25426为例，bootstrap.sh文件内容如下，同样存放于配置目录中。

```bash
#!/bin/sh
insmod /lib/modules/nfnetlink.ko &> /dev/null
insmod /lib/modules/ip_set.ko &> /dev/null
insmod /lib/modules/ip_set_hash_ip.ko &> /dev/null
insmod /lib/modules/xt_set.ko &> /dev/null
insmod /lib/modules/ip_set_hash_net.ko &> /dev/null
insmod /lib/modules/xt_mark.ko &> /dev/null
insmod /lib/modules/xt_connmark.ko &> /dev/null
insmod /lib/modules/nf_tproxy_core.ko &> /dev/null
insmod /lib/modules/xt_TPROXY.ko &> /dev/null
insmod /lib/modules/iptable_mangle.ko &> /dev/null
v2raya
```

以DS3617xs 7.2.1-69057为例，bootstrap.sh文件内容如下，同样存放于配置目录中。

```bash
#!/bin/sh
insmod /lib/modules/nfnetlink.ko
insmod /lib/modules/ip_set.ko
insmod /lib/modules/ip_set_hash_ip.ko
insmod /lib/modules/xt_set.ko
insmod /lib/modules/ip_set_hash_net.ko
insmod /lib/modules/xt_mark.ko
insmod /lib/modules/xt_connmark.ko
insmod /lib/modules/xt_comment.ko
insmod /lib/modules/nf_conntrack_ipv6.ko
insmod /lib/modules/nf_defrag_ipv6.ko
insmod /lib/modules/xt_TPROXY.ko
insmod /lib/modules/xt_socket.ko
insmod /lib/modules/iptable_mangle.ko
insmod /lib/modules/textsearch.ko
insmod /lib/modules/ts_bm.ko
insmod /lib/modules/xt_string.ko
insmod /lib/modules/ip6_tables.ko
insmod /lib/modules/nf_nat.ko
insmod /lib/modules/nf_nat_ipv6.ko
insmod /lib/modules/nf_nat_masquerade_ipv6.ko
insmod /lib/modules/ip6t_MASQUERADE.ko
insmod /lib/modules/ip6table_nat.ko
insmod /lib/modules/ip6table_raw.ko
insmod /lib/modules/ip6table_mangle.ko
v2raya
```

{{% notice info %}}
不同群晖系统所需的内核模块可能不完全一样，具体参考 [syno-iptables](https://github.com/sjtuross/syno-iptables) 自行调整
{{% /notice %}}
