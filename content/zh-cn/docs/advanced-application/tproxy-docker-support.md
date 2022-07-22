---
title: "使 tproxy 支持本机 docker 容器"
description: "使 tproxy 支持本机 docker 容器"
lead: "本节介绍如何利用生命周期钩子修改透明代理规则，使 tproxy 支持本机 docker 容器。"
date: 2022-07-10T13:59:39+01:00
lastmod: 2022-07-10T13:59:39+01:00
draft: false
images: []
menu:
  docs:
    parent: "advanced-application"
toc: true
weight: 710
---

### 使 tproxy 模式支持 docker 容器

由于默认情况下 docker 加载的 iptables 网桥模块并不被 tproxy 所支持，v2rayA 在 tproxy 模式下会添加一条规则跳过 docker 容器的代理。而根据 [springzfx/cgproxy#10](https://github.com/springzfx/cgproxy/issues/10#issuecomment-673437557) ，如果你不需要避免 hairpin nat 问题，可通过一些操作使得 tproxy 模式重新支持代理 docker 容器。

下面介绍利用透明代理生命周期钩子修改 iptables 规则使得 tproxy 支持 docker 容器。生命周期钩子的介绍见 [生命周期钩子]({{% relref "hook" %}}) 一节。

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
  if [ "$TYPE" = "tproxy" ]; then
    # we check if the transparent type is tproxy, and if so, we disable the bridge netfilter call and remove the docker rule in the TP_RULE chain.
    modprobe br_netfilter
    sysctl net.bridge.bridge-nf-call-ip6tables=0
    sysctl net.bridge.bridge-nf-call-iptables=0
    sysctl net.bridge.bridge-nf-call-arptables=0
    iptables -t mangle -D TP_RULE -i docker+ -j RETURN
  fi
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

启动 v2raya 时添加参数 `--transparent-hook /etc/v2raya/tproxy-hook.sh`。
