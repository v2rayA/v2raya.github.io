---
title: "如何更新"
description: "由于部署方式众多，请仔细查阅，根据自己部署的方式选择相应的更新方式。"
lead: "由于部署方式众多，请仔细查阅，根据自己部署的方式选择相应的更新方式。"
date: 2020-11-12T13:26:54+01:00
lastmod: 2020-11-12T13:26:54+01:00
draft: false
images: []
menu:
  docs:
    parent: "help"
toc: true
weight: 810
---

## 更新

### Docker 启动方式

Docker 部署方式更新较为简单、只需要拉取最新镜像重建容器即可

#### 拉取最新镜像

```bash
docker pull mzz2017/v2raya
# nightly 版本
# docker pull mzz2017/v2raya-nightly
```

#### 重建容器

 > 注意：如果原来并没有进行目录挂载、则会导致配置丢失。

 ```bash
 # 重新执行原来的 `docker run` 命令
 docker run ....
 ```

#### 提取并保留容器配置

> 注意：如果原来并未进行目录挂载、想在新建容器时保留原来的配置，则需要提取原始容器内部的配置文件，并进行目录映射。

```bash
# 提取配置文件夹
# 其中 v2raya 为你的容器名称
docker cp v2raya:/etc/v2raya/ /path/to/config

# docker run 命令添加目录挂载信息
# ... 为省略信息
docker run .... -v /path/to/config:/etc/v2raya/ ....  mzz2017/v2raya
```
