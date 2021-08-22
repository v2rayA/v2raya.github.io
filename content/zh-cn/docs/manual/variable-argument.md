---
title: "环境变量和命令行参数"
description: "v2rayA 环境变量和命令行参数的介绍"
lead: ""
date: 2020-11-16T13:59:39+01:00
lastmod: 2020-11-16T13:59:39+01:00
draft: false
images: []
menu:
  docs:
    parent: "manual"
toc: true
weight: 600
---

`V2RAYA_ADDRESS`: 监听地址 (默认 "0.0.0.0:2017")

`V2RAYA_CONFIG`: v2rayA 配置文件目录 (默认 "/etc/v2raya")

`V2RAYA_V2RAY_BIN`: v2ray 可执行文件路径. 留空将自动检测. 可修改为 v2ray 分支如 xray 等文件路径

`V2RAYA_V2RAY_CONFDIR`: 附加的 v2ray 配置文件目录, 该目录中的 v2ray 配置文件会与 v2rayA 生成的配置文件进行组合

`V2RAYA_WEBDIR`: v2rayA 前端 GUI 文件目录 (默认 "/etc/v2raya/web")

`V2RAYA_PLUGINLISTENPORT`: v2rayA 内部插件端口 (默认 32346)

`V2RAYA_FORCE_IPV6_ON`: 强制启用 IPv6，即使 v2rayA 认为该机器不支持 IPv6。

`V2RAYA_PASSCHECKROOT`: 跳过 root 权限检测, 确认你有 root 权限而 v2rayA 判断出错时使用

`V2RAYA_VERBOSE`: 详细日志模式，混合打印 v2ray-core 和 v2rayA 的运行日志

`V2RAYA_RESET_PASSWORD`: 重设密码
