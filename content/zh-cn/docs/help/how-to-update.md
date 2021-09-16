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
## 更新 V2Ray / Xray

### 通过脚本更新

脚本会自动获取最新版本然后安装，因此，你只需要重新运行一次安装脚本就能更新核心

### 软件源更新

如果你从软件源安装了 v2rayA，那么在你更新系统与软件的时候，v2rayA 的更新也会随之安装。以 Debian 系统为例，更新系统与软件的命令为：

```bash
sudo apt update
sudo apt upgrade
```

Fedora / CentOS Stream 8 用户应当使用 `dnf` 命令以取代 `apt` 命令来获取更新，除此之外，Gnome Software、Discover、系统更新器等图形化工具也可以更新核心。

## 更新 v2rayA

### Docker 启动方式

Docker 部署方式更新较为简单、只需要拉取最新镜像重建容器即可

#### 拉取最新镜像

```bash
docker pull mzz2017/v2raya
# nightly 版本
# docker pull mzz2017/v2raya-nightly
```

#### 重建容器

{{% notice warning %}}
如果原来并没有进行目录挂载、则会导致配置丢失。
{{% /notice %}}

 ```bash
 # 重新执行原来的 `docker run` 命令
 docker run ....
 ```

#### 提取并保留容器配置

{{% notice warning %}}
如果原来并未进行目录挂载、想在新建容器时保留原来的配置，则需要提取原始容器内部的配置文件，并进行目录映射。
{{% /notice %}}

```bash
# 提取配置文件夹
# 其中 v2raya 为你的容器名称
docker cp v2raya:/etc/v2raya/ /path/to/config

# docker run 命令添加目录挂载信息
# ... 为省略信息
docker run .... -v /path/to/config:/etc/v2raya/ ....  mzz2017/v2raya
```

### Debian / Ubuntu

#### 软件源方式

如果你从软件源安装了 v2rayA，那么在你更新系统与软件的时候，v2rayA 的更新也会随之安装。更新系统与软件的命令为：

```bash
sudo apt update
sudo apt upgrade
```

Gnome Software、Discover、系统更新器等图形化工具也可以更新 v2rayA。

#### 手动更新

从 GitHub 的 Releases 下载新版本，然后覆盖安装即可。

### Fedora / CentOS Stream

#### 软件源方式

如果你从软件源安装了 v2rayA，那么在你更新系统与软件的时候，v2rayA 的更新也会随之安装。更新系统与软件的命令为：

```bash
sudo dnf upgrade
```

Gnome Software、Discover、系统更新器等图形化工具也可以更新 v2rayA。

#### 手动更新

从 GitHub 的 Releases 下载新版本，然后覆盖安装即可。

### 其它基于 rpm 的发行版

#### 手动更新

从 GitHub 的 Releases 下载新版本，然后覆盖安装即可。

### Arch Linux

作为一个 Arch 用户，更新软件这事就不用教了吧！

什么？还是要教？看 Manjaro 的！

### Manjaro Linux

#### 从 AUR 更新

```bash
yay -Syu v2raya #软件包也可能是 v2raya-bin 或 v2raya-git，看你自己
```

#### 手动更新

从 GitHub 的 Releases 下载新版本，然后覆盖安装即可。

#### 从 Arch Linux CN 源更新

<font color="#FF0000">
更新是可以的，v2rayA 也是能正常用的，但是其它软件会不会炸掉那是难说的，所以 Manjaro 用户是不被建议去用适配 Arch 的软件源的。
</font>
