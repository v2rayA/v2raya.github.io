---
title: "使用其他核心"
description: "v2rayA 使用其他核心的介绍"
lead: "本节介绍如何使 v2rayA 更换其他核心。"
date: 2020-11-16T13:59:39+01:00
lastmod: 2020-11-16T13:59:39+01:00
draft: false
images: []
menu:
  docs:
    parent: "manual"
toc: false
weight: 590
---

如不明确指定，v2rayA 在启动后会在 `$PATH` 中依次查找 v2ray 和 xray 命令，因此确保使用命令`command -v v2ray`及`command -v xray`能有正确的输出即可。

v2rayA 会优先使用 v2ray，其次是 xray。如果你的 v2ray 或 xray 不在 `$PATH` 中，或你想使用其他的核心，可在环境变量或命令行参数中明确指定。参考[环境变量和命令行参数]({{< relref "variable-argument#如何设置" >}})一节中的说明。
