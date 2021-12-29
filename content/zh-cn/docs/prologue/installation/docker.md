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

### Docker 方式

使用 docker 命令部署。

```bash
# run v2raya
docker run -d \
  --restart=always \
  --privileged \
  --network=host \
  --name v2raya \
  -e V2RAYA_ADDRESS=0.0.0.0:2017 \
      -v /lib/modules:/lib/modules \
  -v /etc/resolv.conf:/etc/resolv.conf \
  -v /etc/v2raya:/etc/v2raya \
  mzz2017/v2raya
```

---

如果你使用 MacOSX 或其他不支持 host 模式的环境，在该情况下**无法使用全局透明代理**，或者你不希望使用全局透明代理，docker 命令会略有不同：

```bash
# run v2raya
docker run -d \
  -p 2017:2017 \
  -p 20170-20172:20170-20172 \
  --restart=always \
  --privileged \
  --name v2raya \
  -v /etc/v2raya:/etc/v2raya \
  mzz2017/v2raya
```
