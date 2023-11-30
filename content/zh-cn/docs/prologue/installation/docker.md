---
title: "Docker"
description: "安装内核和 v2rayA"
lead: "Docker 镜像内集成了 V2Ray 内核，因此内核无需额外被安装。"
date: 2020-11-16T13:59:39+01:00
lastmod: 2020-11-16T13:59:39+01:00
draft: false
images: []
menu:
  docs:
    parent: "installation"
weight: 15
toc: true
---

{{% notice note %}}
Docker 是一个以服务生产环境而开发的应用平台，在使用 Docker 部署之时，我们相信你已经掌握了运维一台服务器所必须的知识，同时也理解了容器化的概念与 Docker 的基础操作。如若不然，请使用其它更加简单的部署方式。
{{% /notice %}}

{{% notice info %}}
以下命令假定你在 root 用户下操作，如果你所使用的用户不是 root，那么你可能需要 `sudo` 或 `doas` 命令来进行提权操作。
{{% /notice %}}

## 方式一：始终使用最新版

### 获取镜像

```sh
docker pull mzz2017/v2raya
```

### 运行 v2rayA

停止正在运行的版本（如果存在）：

```sh
docker container stop v2raya
docker container rm v2raya
```

运行 v2rayA:

{{% notice note %}}

1. `V2RAYA_V2RAY_BIN` 的值应当是 `/usr/local/bin/v2ray` 或 `/usr/local/bin/xray`，默认的核心是 xray。
2. 如果你的宿主系统使用 nftables，那么就把 `V2RAYA_NFTABLES_SUPPORT` 设置为 `on`，否则会遇到 iptables 找不到 table 的故障。

{{% /notice %}}

```bash
docker run -d \
  --restart=always \
  --privileged \
  --network=host \
  --name v2raya \
  -e V2RAYA_LOG_FILE=/tmp/v2raya.log \
  -e V2RAYA_V2RAY_BIN=/usr/local/bin/v2ray \
  -e V2RAYA_NFTABLES_SUPPORT=off \
  -v /lib/modules:/lib/modules:ro \
  -v /etc/resolv.conf:/etc/resolv.conf \
  -v /etc/v2raya:/etc/v2raya \
  mzz2017/v2raya
```

如果你使用 macOS 或其他不支持 host 模式的环境，在该情况下**无法使用全局透明代理**，或者你不希望使用全局透明代理，docker 命令会略有不同：

```bash
# run v2raya
docker run -d \
  -p 2017:2017 \
  -p 20170-20172:20170-20172 \
  --restart=always \
  --name v2raya \
  -e V2RAYA_V2RAY_BIN=/usr/local/bin/v2ray \
  -e V2RAYA_LOG_FILE=/tmp/v2raya.log \
  -v /etc/v2raya:/etc/v2raya \
  mzz2017/v2raya
```

查看状态：

```sh
docker container stats v2raya
```

## 方式二：获取指定版本

Docker 允许用户同时下载不同版本的 v2rayA。通过错开端口等操作，用户还可以运行多个不同版本的 v2rayA。

### 获取镜像

获取最新的版本号：

```bash
Latest_version=$(curl -L "https://api.github.com/repos/v2rayA/v2rayA/releases/latest" | grep 'tag_name' | awk -F '"' '{print $4}' | awk -F 'v' '{print $2}')
echo $Latest_version
```

如果你不需要最新的版本，你也可以访问 [Docker 镜像仓库](https://hub.docker.com/r/mzz2017/v2raya/tags) 查找所需的版本。比如，你需要 1.5.8 版本，那么将 `$Latest_version` 替换为你所需的版本即可。

获取 Docker 镜像：

```sh
docker pull mzz2017/v2raya:$Latest_version
```

### 运行 v2rayA

使用 docker 运行 v2rayA:

```bash
# run v2raya
docker run -d \
  --restart=always \
  --privileged \
  --network=host \
  --name v2raya \
  -e V2RAYA_LOG_FILE=/tmp/v2raya.log \
  -v /lib/modules:/lib/modules:ro \
  -v /etc/resolv.conf:/etc/resolv.conf \
  -v /etc/v2raya:/etc/v2raya \
  mzz2017/v2raya:$Latest_version
```

如果你使用 MacOSX 或其他不支持 host 模式的环境，在该情况下**无法使用全局透明代理**，或者你不希望使用全局透明代理，docker 命令会略有不同：

```bash
# run v2raya
docker run -d \
  -p 2017:2017 \
  -p 20170-20172:20170-20172 \
  --restart=always \
  --name v2raya \
  -e V2RAYA_LOG_FILE=/tmp/v2raya.log \
  -v /etc/v2raya:/etc/v2raya \
  mzz2017/v2raya:$Latest_version
```

查看状态：

```sh
docker container stats v2raya
```

### 更新 v2rayA

使用 [获取镜像]({{< ref "#获取镜像" >}}) 中所提到的命令获取最新版本的镜像，然后停止当前容器：

```sh
docker container stop v2raya
docker container rm v2raya
```

最后使用 [运行 v2rayA]({{< ref "#运行-v2raya" >}}) 里面所提到的命令运行新版本 v2rayA。更新 v2rayA 之后，你可以考虑删除旧版本镜像。
