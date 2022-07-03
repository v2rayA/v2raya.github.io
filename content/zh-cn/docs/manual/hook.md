---
title: "透明代理生命周期钩子"
description: "透明代理生命周期钩子介绍与示例"
lead: "本节介绍如何使用透明代理生命周期钩子。"
date: 2022-07-3T13:59:39+01:00
lastmod: 2022-07-3T13:59:39+01:00
draft: false
images: []
menu:
  docs:
    parent: "manual"
toc: true
weight: 445
---

使用 v2rayA 的 `--transparent-hook` 参数以及对应的环境变量 `V2RAYA_TRANSPARENT_HOOK` 可在透明代理生命周期过程中插入执行用户提供的脚本，用户需要将可执行文件路径作为该参数传入。

在生命周期阶段 (pre-start, post-start, pre-stop, post-stop) v2rayA 会执行用户提供的可执行文件，并传入两个参数 `--transparent-type` 及 `--stage` ，前者为透明代理类型 (tproxy, redirect, system_proxy)，后者为上述生命周期阶段。用户可在提供的程序内部解析传入的两个参数。

下面给出 bash 脚本解析参数示例：

```bash
#!/bin/bash

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
      exit 1
      ;;
    *)
      ;;
  esac
done

echo "Transparent Type = ${TYPE}"
echo "Stage            = ${STAGE}"
```

将脚本保存并通过 `chmod +x example.sh` 赋予执行权限后将脚本路径传参给 v2rayA 即可。

另外，也可使用具有执行权限的 python 脚本或其他可执行程序的文件路径作为 `--transparent-hook` 的传参。

## 示例

### 使本机特定程序无条件直连

该方法可使得特定程序的所有流量均不经过 v2ray-core。

首先创建用户组：

```bash
sudo groupadd v2raya-skip
```

而后，编写如下脚本，将其存储于 `/etc/v2raya/tproxy-hook.sh` ：

```bash
#!/bin/bash

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
      exit 1
      ;;
    *)
      ;;
  esac
done


case "$STAGE" in
post-start)
  if [ "$TYPE" = "tproxy" ]; then
    TABLE=mangle
  elif [ "$TYPE" = "redirect" ]; then
    TABLE=nat
  else
  echo "unexpected transparent type: ${TYPE}"
  exit 1
  fi
  set -ex
  iptables -t "$TABLE" -I TP_OUT -m owner --gid-owner v2raya-skip -j RETURN
  ip6tables -t "$TABLE" -I TP_OUT -m owner --gid-owner v2raya-skip -j RETURN
  ;;
*)
  exit 0
  ;;
esac
```

赋予可执行权限：

```bash
chmod +x /etc/v2raya/tproxy-hook.sh
```

启动 v2raya 时添加参数 `--transparent-hook /etc/v2raya/tproxy-hook.sh`

使用指定组启动需要绕过的程序，以 curl 为例：

```bash
# 使用 sg
sudo sg v2raya-skip 'curl ip.sb'
# 或使用 su
sudo su -g v2raya-skip -c 'curl ip.sb'
```

同理，可使用类似命令启动 BT 下载程序，以达到不经过 v2ray-core 的直连效果。
