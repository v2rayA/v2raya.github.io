---
title: "拓展规则库 .dat 文件"
description: "v2rayA 拓展规则库的介绍"
lead: "扩展规则库可用于 RoutingA 书写，下面以 v2ray-core 为例，其他 core 需要对应做出修改。"
date: 2020-11-16T13:59:39+01:00
lastmod: 2022-09-02T13:59:39+01:00
draft: false
images: []
menu:
  docs:
    parent: "manual"
toc: true
weight: 410
---

## 存放位置

### Windows

当 `$V2RAY_LOCATION_ASSET`（`$XRAY_LOCATION_ASSET`）或 `--v2ray-assetsdir` 被显式定义时，v2ray-core 的查找顺序是：

```text
环境变量 $V2RAY_LOCATION_ASSET 或 `--v2ray-assetsdir` 所定义的路径
```

{{% notice info %}}
使用安装包安装时，`$V2RAY_LOCATION_ASSET` 会被设定为安装目录，因此用户可将 .dat 文件存放到安装目录下。
{{% /notice %}}

当 `$V2RAY_LOCATION_ASSET` 和 `--v2ray-assetsdir` 未被显式定义时，v2ray-core 查找顺序是：

```text
v2ray.exe 可执行文件所在目录
```

### Linux/MacOS

当 `$V2RAY_LOCATION_ASSET`（`$XRAY_LOCATION_ASSET`）或 `--v2ray-assetsdir` 被显式定义时，v2ray-core 的查找顺序是：

```text
环境变量 $V2RAY_LOCATION_ASSET 或 `--v2ray-assetsdir` 所定义的路径
/usr/local/share/v2ray/
/usr/share/v2ray/
/opt/share/v2ray/
```

然而，当 v2rayA 检查到 `$V2RAY_LOCATION_ASSET` 和 `--v2ray-assetsdir` 未被显式定义时，`$V2RAY_LOCATION_ASSET` 将被 v2rayA 定义为 `/run/user/{uid}/v2raya`，一般 root 用户的 uid 为 0。此时，v2rayA 会按 `$XDG_DATA_HOME`、`$XDG_DATA_DIRS` 的顺序查找文件并软链接到 `/run/user/{uid}/v2raya`。

简言之，当 `$V2RAY_LOCATION_ASSET` 或 `--v2ray-assetsdir` 未被显式定义时，v2ray-core 的查找顺序是：

```text
环境变量 $XDG_DATA_HOME 所定义的路径
环境变量 $XDG_DATA_DIRS 所定义的路径
/usr/local/share/v2ray/
/usr/share/v2ray/
/opt/share/v2ray/
```

## 使用方法

扩展规则库用于定义 v2ray 路由规则，在 v2rayA 中可使用 RoutingA 进行书写。在将 .dat 文件放置到正确位置后，可使用如下 RoutingA 句式书写：

```bash
# 示例
domain(ext:"LoyalsoldierSite.dat:geolocation-!cn")->proxy
ip(ext:"LoyalsoldierIP.dat:telegram")->proxy
```

参考 [RoutingA]({{% relref "routingA" %}})
