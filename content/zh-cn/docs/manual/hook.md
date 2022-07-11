---
title: "生命周期钩子"
description: "生命周期钩子介绍与示例"
lead: "本节介绍如何使用生命周期钩子。"
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

使用 v2rayA 的 `--transparent-hook` 参数以及对应的环境变量 `V2RAYA_TRANSPARENT_HOOK` 可在透明代理启动前、启动后，停止前、停止后运行用户提供的程序，用户可在自定义程序中添加、删除或修改 iptables 规则、sysctl 规则或执行任意其他命令，以达成高级用法。v2rayA 参数的传递请参考 [环境变量和命令行参数]({{% relref "variable-argument#如何设置" %}}) 一节中的说明。与其对应的，`--core-hook` 可在 v2ray-core 启动前、启动后，停止前、停止后运行用户提供的程序。

除了用户需要给 v2rayA 提供的一个参数外，v2rayA 还会在执行用户自定义程序时传入参数以告知上下文信息。用户可在自定义程序中解析传入的参数，以判断当前 v2rayA 的透明代理类型 (tproxy, redirect, system_proxy)，以及当前所处阶段 (pre-start, post-start, pre-stop, post-stop)。

下表表示了 v2rayA 对应钩子类型在运行用户自定义程序时支持传入的参数。

| 钩子类型/参数      | --stage | --transparent-type | --v2raya-confdir |
| ------------------ | ------- | ------------------ | ---------------- |
| --transparent-hook | ✓       | ✓                  | ✓                |
| --core-hook        | ✓       | ✗                  | ✓                |

下面给出 bash 脚本作为 `--transparent-hook` 的自定义程序的例子，该例子将解析透明代理类型到 `$TYPE` 变量，以及当前所处阶段到 `$STAGE` 变量，最后将上下文变量打印出来：

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
    --v2raya-confidr=*)
      CONFDIR="${i#*=}"
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

# print $TYPE, $STAGE and $CONFDIR
echo "Transparent Type = ${TYPE}"
echo "Stage            = ${STAGE}"
echo "Config Directory = ${CONFDIR}"
```

有了上下文变量，用户就可以根据需求进行编写操作了。

为了验证这段程序的有效性，用户只需将脚本保存并通过 `chmod +x example.sh` 赋予执行权限后将脚本路径作为 `--transparent-hook` 传递给 v2rayA 即可，在透明代理执行前后输出结果会作为 v2rayA 日志进行输出。

该参数并不限于使用 bash 脚本，你也可传入具有执行权限的 python 脚本或其他可执行程序的文件路径。

{{% notice warning %}}
请务必使得传入的脚本仅 root 具有写权限，以防止越权执行漏洞。
{{% /notice %}}
