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

使用 v2rayA 的 `--transparent-hook` 参数以及对应的环境变量 `V2RAYA_TRANSPARENT_HOOK` 可在透明代理启动前、启动后，停止前、停止后运行用户提供的程序，用户可在自定义程序中添加、删除或修改 iptables 规则、sysctl 规则或执行任意其他命令，以达成高级用法。参数的传递请参考[环境变量和命令行参数]({{% relref "variable-argument#如何设置" %}})一节中的说明。

用户可在自定义程序中解析传入的参数，以判断当前 v2rayA 的透明代理类型 (tproxy, redirect, system_proxy)，以及当前所处阶段 (pre-start, post-start, pre-stop, post-stop)。

下面给出 bash 脚本作为自定义程序的例子，该例子将解析透明代理类型到 `$TYPE` 变量，以及当前所处阶段到 `$STAGE` 变量，最后将两个变量打印出来：

```bash
#!/bin/bash

# parse the arguments into $TYPE and $STAGE
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

# print $TYPE and $STAGE
echo "Transparent Type = ${TYPE}"
echo "Stage            = ${STAGE}"
```

有了这两个变量，用户就可以根据需求进行编写操作了。

为了验证这段程序的有效性，用户只需将脚本保存并通过 `chmod +x example.sh` 赋予执行权限后将脚本路径传参给 v2rayA 即可，输出结果会作为 v2rayA 日志进行输出。

该参数并不限于使用 bash 脚本，你也可传入具有执行权限的 python 脚本或其他可执行程序的文件路径。

{{% notice warning %}}
请务必使得传入 --transparent-hook 的脚本仅 root 具有写权限，以防止越权执行漏洞。
{{% /notice %}}

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

# parse the arguments into $TYPE and $STAGE
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
  # at the post-start stage
  # we first check the $TYPE so we know which table should we insert into
  if [ "$TYPE" = "tproxy" ]; then
    TABLE=mangle
  elif [ "$TYPE" = "redirect" ]; then
    TABLE=nat
  else
    echo "unexpected transparent type: ${TYPE}"
    exit 1
  fi
  # print what we are excuting and exit if it fails
  set -ex
  # insert the iptables rules for ipv4 and ipv6
  iptables -t "$TABLE" -I TP_OUT -m owner --gid-owner v2raya-skip -j RETURN
  ip6tables -t "$TABLE" -I TP_OUT -m owner --gid-owner v2raya-skip -j RETURN
  ;;
pre-stop)
  # we do nothing here because the TP_OUT chain will be flushed automatically by v2rayA.
  # we can also do it manually.
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

启动 v2raya 时添加参数 `--transparent-hook /etc/v2raya/tproxy-hook.sh`

使用指定组启动需要绕过的程序，以 curl 为例：

```bash
# 使用 sg
sudo sg v2raya-skip 'curl ip.sb'
# 或使用 su
sudo su -g v2raya-skip -c 'curl ip.sb'
```

同理，可使用类似命令启动 BT 下载程序，以达到不经过 v2ray-core 的直连效果。

### 使 tproxy 模式支持 docker 容器

由于默认情况下 docker 加载的 iptables 网桥模块并不被 tproxy 所支持，v2rayA 在 tproxy 模式下会添加一条规则跳过 docker 容器的代理。而根据 [springzfx/cgproxy#10](https://github.com/springzfx/cgproxy/issues/10#issuecomment-673437557) ，如果你不需要避免 hairpin nat 问题，可通过一些操作使得 tproxy 模式重新支持代理 docker 容器。

编写如下脚本，将其存储于 `/etc/v2raya/tproxy-hook.sh` ：

```bash
#!/bin/bash

# parse the arguments into $TYPE and $STAGE
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
  # at the post-start stage
  if [ "$TYPE" = "tproxy" ]; then
    # we check if the transparent type is tproxy, and if so, we disable the bridge netfilter call and remove the docker rule in the TP_RULE chain.
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

启动 v2raya 时添加参数 `--transparent-hook /etc/v2raya/tproxy-hook.sh`
