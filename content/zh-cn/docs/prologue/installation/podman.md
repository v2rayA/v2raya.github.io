---
title: "Podman"
description: "使用Podman运行v2rayA"
lead: "此教程需要你的发行版使用SystemD。如果使用其它init系统则需要你手动配置开机自动启动。"
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

此页面的内容适用于：

- Fedora Silverblue / Kinoite
- SLE Micro / openSUSE Micro Leap
- openSUSE MicroOS

但同时也适用于普通发行版，如：

- Fedora Workstation
- openSUSE Leap / Tumbleweed
- CentOS Stream

## 安装 Podman

Podman已经在一部分发行版中预装了。若你的发行版没有预装Podman，请参考具体安装步骤：

[https://podman.io/getting-started/installation.html#installing-on-linux](
https://podman.io/getting-started/installation.html#installing-on-linux)

## 配置

你可以使用[rootful模式](#rootful-模式) 或者 [rootless模式](#rootless-模式)。

注意：此教程使用的容器镜像由@mzz2017直接维护，意味着没有发行版软件源的审查。继续使用此镜像意味着你信任@mzz2017。

### Rootful 模式

如果你想使用透明代理、路由转发等功能，则需要使用rootful模式。

#### 下载容器镜像

直接下载镜像：

```bash
sudo podman pull \
    docker.io/mzz2017/v2raya
```

如果你的设备无法直接访问到Docker Hub，可以使用现有的HTTP代理下载镜像：

```bash
sudo env \
HTTP_PROXY=http://<Address>:<Port> \
HTTPS_PROXY=http://<Address>:<Port> \
  podman pull \
    docker.io/mzz2017/v2raya
```

你也可以使用 `sudo podman image import` 导入其它来源提供的v2rayA容器镜像。

#### 创建容器

```bash
sudo mkdir -p /etc/v2raya
sudo podman create -it \
  --name v2raya \
  --restart=always \
  --label io.containers.autoupdate=registry \
  --cgroup-parent=machine-v2raya.slice \
  --security-opt no-new-privileges \
  --cap-drop all --cap-add cap_net_bind_service,cap_net_broadcast,cap_net_admin,cap_net_raw \
  --network=host \
  --memory=500M \
  --volume /etc/v2raya:/etc/v2raya:z \
  docker.io/mzz2017/v2raya
```

配置文件保存在 `/etc/v2raya` 中。

#### 创建服务

```bash
bash -c \
  "sudo mkdir -p /etc/systemd/system \
  && cd /etc/systemd/system \
  && sudo podman generate systemd --new --files --name v2raya \
  && sudo systemctl daemon-reload"
```

#### 开启容器自动更新

```bash
sudo systemctl enable --now podman-auto-update.timer
```

#### 开启v2rayA服务

现在你可以用SystemD控制v2rayA服务了。

查看服务状态：

```bash
systemctl status container-v2raya.service
```

设置开机自启动，并且现在开始运行：

```bash
sudo systemctl enable --now container-v2raya.service
```

打开浏览器，访问[http://localhost:2017](http://localhost:2017)。

#### 移除容器

```bash
sudo systemctl disable --now container-v2raya.service
sudo rm /etc/systemd/system/container-v2raya.service
sudo systemctl daemon-reload
```

你也可以选择删除v2rayA的配置文件：

```bash
sudo rm -r /etc/v2raya
```

### Rootless 模式

如果你只需要一个SOCKS5/HTTP代理端口，则可以让容器运行于普通用户权限，进一步降低风险。

#### 下载容器镜像

直接下载镜像：

```bash
podman pull \
    docker.io/mzz2017/v2raya
```

如果你的设备无法直接访问到Docker Hub，可以使用现有的HTTP代理下载镜像：

```bash
env \
HTTP_PROXY=http://<Address>:<Port> \
HTTPS_PROXY=http://<Address>:<Port> \
  podman pull \
    docker.io/mzz2017/v2raya
```

你也可以使用 `podman image import` 导入其它来源提供的v2rayA容器镜像。

#### 创建容器

```bash
mkdir -p ~/.config/v2raya
podman create -it \
  --name v2raya \
  --restart=always \
  --label io.containers.autoupdate=registry \
  --cgroup-parent=v2raya.slice \
  --security-opt no-new-privileges \
  --cap-drop all \
  --network host \
  --memory=500M \
  --volume ~/.config/v2raya:/etc/v2raya:z \
  docker.io/mzz2017/v2raya
```

配置文件保存在 `~/.config/v2raya` 中。

#### 创建服务

```bash
bash -c \
  "mkdir -p ~/.config/systemd/user \
  && cd ~/.config/systemd/user \
  && podman generate systemd --new --files --name v2raya \
  && systemctl --user daemon-reload"
```

#### 开启容器自动更新

```bash
systemctl --user enable --now podman-auto-update.timer
```

#### 开启v2rayA服务

现在你可以用SystemD控制v2rayA服务了。

查看服务状态：

```bash
systemctl --user status container-v2raya.service
```

设置开机自启动，并且现在开始运行：

```bash
systemctl --user enable --now container-v2raya.service
```

打开浏览器，访问[http://localhost:2017](http://localhost:2017)。

然后你可以在系统设置中使用代理： `http://localhost:20171` 。

#### 移除容器

```bash
systemctl --user disable --now container-v2raya.service
rm ~/.config/systemd/user/container-v2raya.service
systemctl --user daemon-reload
```

你也可以选择删除v2rayA的配置文件：

```bash
sudo rm -r ~/.config/v2raya
```
