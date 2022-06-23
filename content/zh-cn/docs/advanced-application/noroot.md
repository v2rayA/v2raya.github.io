---
title: "无 ROOT 权限运行 v2rayA"
description: "v2rayA 无 ROOT 权限运行的介绍"
lead: "本节介绍如何以非 root 权限运行 v2rayA。"
date: 2020-11-16T13:59:39+01:00
lastmod: 2020-11-16T13:59:39+01:00
draft: false
images: []
menu:
  docs:
    parent: "advanced-application"
toc: true
weight: 610
---

{{% notice info %}}
以非 ROOT 权限运行 v2rayA 将无法使用部分功能，例如透明代理。

然而如果你希望以 ROOT 权限运行，且已拥有 ROOT 权限而 v2rayA 判断错误，可使用 `--passcheckroot` 跳过 root 权限检查。
{{% /notice %}}

一般地，使用环境变量 `V2RAYA_LITE` 或命令行参数 `--lite` 以使用非 ROOT 权限启动 v2rayA。

如果你使用 systemd，可通过控制用户服务 `v2raya-lite.service` 以本用户运行，例如：

```bash
systemctl --user enable --now v2raya-lite.service
```

注意，该服务启动后，v2rayA 默认占据 2017 端口。因此如果已有其他实例在 2017 监听，需要先将其关闭，例如：

```bash
systemctl disable --now v2raya.service
```
