---
title: "指定 Docker 容器代理"
description: "v2rayA 指定 Docker 容器代理的介绍"
lead: "本节介绍如何利用桥接的 docker 容器有单独 IP 的特点，通过 source IP 的限制，对特定 docker 容器进行代理，其他走直连。"
date: 2020-11-16T13:59:39+01:00
lastmod: 2020-11-16T13:59:39+01:00
draft: false
images: []
menu:
  docs:
    parent: "advanced-application"
toc: true
weight: 630
---

## 指定 Docker 容器代理

{{% notice info %}}
此方法只能适用于 v2rayA 与要控制路由的 Docker 容器在同一台机器的情况。
{{% /notice %}}

### 透明代理使用 redirect 模式

正如 [BT 下载直连]({{% relref "pass-bt" %}}) 中所列方法，我们可以控制每一个桥接的 Docker 容器的路由。

当 BT 应用运行在 Docker 时，默认的网络模式使用桥接模式（--network=bridge），此时容器会单独获得一个 IP 地址。而 Docker 的默认桥接网络为 `172.17.0.0/16`，容器会在该地址段中获取一个 IP 使用。如果我们想让所有桥接容器走直连，而特定容器走代理，可使用 RoutingA 进行控制，例如：

```python
# 将规则插入到较前位置
source(172.17.0.213) -> proxy
source(172.17.0.0/16) -> direct
```

上述规则使得 `172.17.0.213` 走代理，而 `172.17.0.0/16` 段直连。

当 docker 服务重启时，容器的 IP 地址可能会发生变化，因此需要固定容器的 IP 地址，方法参见 [StackOverflow](https://stackoverflow.com/questions/27937185/assign-static-ip-to-docker-container) 上的讨论。

### 透明代理使用 tproxy 模式

由于一些限制，在此模式下，所有桥接容器默认直连，因此要走代理的容器需要将网络设为 `host`，即在容器启动时使用 `--network host` 参数。

注意，`host` 模式下该容器将无法进行端口映射，容器内部监听的端口将直接监听在宿主上，容易引起端口冲突。
