---
title: "局域网特定 IP 直连"
description: "局域网特定 IP 直连"
lead: "本节介绍如何在透明代理开启时使得特定连入 IP（例如局域网内某 IP）直连。"
date: 2022-09-19T13:59:39+08:00
lastmod: 2022-09-19T13:59:39+08:00
draft: false
images: []
menu:
  docs:
    parent: "advanced-application"
toc: true
weight: 725
---

### 经过 core 直连

这种情况下会经过 core 的一层 NAT，不仅耗费资源，源端口会发生改变，如果 core 的 NAT 类型受限时，UDP 的 NAT 类型也会受限，是一种较为局限的直连方式。但该方式配置简单，可在要求不高的情况下使用。

1. 将“透明代理”选为“与规则端口所选模式一致”；将“规则端口的分流模式”选为“RoutingA”。

2. 使用 RoutingA 设置直连源 IP：

   ```python
   # 下条规则需要插入靠前位置
   source(192.168.0.12/32, 192.168.0.15/32) -> direct
   ```

3. 此时 `192.168.0.12/32` 和 `192.168.0.15/32` 即可直连。上述 IP 表示法为 CIDR，如需表示多个 IP，可于互联网搜索 CIDR 相关写法，也可通过多写几条规则实现。

### 不经过 core 的完全直连

由于经过 core 的直连有诸多弊处，下面介绍利用 tproxy 生命周期钩子修改 iptables 规则，使得局域网 IP 不经过 core 直连。生命周期钩子的介绍见 [生命周期钩子]({{% relref "hook" %}}) 一节。

下面以使局域网 IP `192.168.0.12` 直连为例。

编写如下脚本，将其存储于 `/etc/v2raya/tproxy-hook.sh` ：

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
    POS=3
  elif [ "$TYPE" = "redirect" ]; then
    TABLE=nat
    POS=1
  else
    echo "unexpected transparent type: ${TYPE}"
    exit 1
  fi
  # print what we are excuting and exit if it fails
  set -ex
  # insert the iptables rules for ipv4
  iptables -t "$TABLE" -I TP_RULE "$POS" -s 192.168.0.12/32 -j RETURN
  ;;
pre-stop)
  # we do nothing here because the TP_RULE chain will be flushed automatically by v2rayA.
  # we can also do it manually.
  ;;
*)
  ;;
esac

exit 0
```

上述脚本将在 TP_RULE 链的最前插入使得 `192.168.0.12/32` 的源 IP 地址跳过的规则。上述 IP 表示法为 CIDR，如需表示多个 IP，可于互联网搜索 CIDR 相关写法，也可通过多写几条规则实现。

赋予可执行权限：

```shell
sudo chmod +x /etc/v2raya/tproxy-hook.sh
```

启动 v2raya 时添加透明代理生命周期钩子，添加参数 `--transparent-hook /etc/v2raya/tproxy-hook.sh`。
