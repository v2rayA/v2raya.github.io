---
title: "Podman"
description: "使用Podman运行v2rayA"
lead: "此教程需要你的发行版使用systemd。如果使用其它init系统则需要你手动配置开机自动启动。"
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

你可以使用[rootful模式](#rootful-模式)或者[rootless模式](#rootless-模式)。

{{% notice info %}}
此教程使用的容器镜像由@mzz2017直接维护，意味着没有发行版软件源的审查。继续使用此镜像意味着你信任@mzz2017。
{{% /notice %}}

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

### 配置iptables自动加载

```bash
sudo mkdir /etc/modules-load.d
cat << 'EOF' | sudo tee /etc/modules-load.d/ip_tables.conf >> /dev/null 2>&1
ip_tables
ip6_tables
EOF
sudo modprobe ip_tables ip6_tables
```

### 创建SELinux规则

{{% notice info %}}
如果你的发行版不使用SELinux，可以跳过这一节。</br>
跳转：[创建容器](#创建容器)
{{% /notice %}}

SELinux会拦截一部分v2rayA的行为，导致透明代理不能正常使用。

{{% notice warning %}}
安全警告：请确保当前工作目录不会被**任何**其它低权限用户程序写入。
{{% /notice %}}

创建规则：

```bash
cat << 'EOF' | tee my_v2raya_container.cil >> /dev/null 2>&1
(block v2raya_container
  (type process)
  (type socket)
  (roletype system_r process)
  (typeattributeset domain ( process ))
  (typeattributeset container_domain ( process ))
  (typeattributeset svirt_sandbox_domain ( process ))
  (typeattributeset mcs_constrained_type ( process ))
  (typeattributeset file_type ( socket ))
  (allow process socket ( sock_file ( create open getattr setattr read write rename link unlink ioctl lock append )))
  (allow process proc_type ( file ( getattr open read )))
  (allow process cpu_online_t ( file ( getattr open read )))
  (allow container_runtime_t process ( key ( create link read search setattr view write )))
  (allow process kernel_t ( system ( module_request )))
  (allow process dns_port_t ( udp_socket ( name_bind )))
  (allow process ephemeral_port_t ( tcp_socket ( name_connect )))
  (allow process http_port_t ( tcp_socket ( name_connect )))
  (allow process node_t ( tcp_socket ( node_bind )))
  (allow process node_t ( udp_socket ( node_bind )))
  (allow process ntp_port_t ( udp_socket ( name_bind )))
  (allow process reserved_port_t ( udp_socket (name_bind )))
  (allow process self ( netlink_route_socket ( nlmsg_write )))
  (allow process self ( tcp_socket ( listen )))
  (allow process unreserved_port_t ( tcp_socket ( name_bind name_connect )))
  (allow process unreserved_port_t ( udp_socket ( name_bind )))
)
EOF
```

加载这个规则：

```bash
sudo semodule -i my_v2raya_container.cil
```

#### 创建容器

```bash
sudo mkdir -p /etc/v2raya
sudo podman create -it \
  --name v2raya \
  --restart=always \
  --label io.containers.autoupdate=registry \
  --cgroup-parent=machine-v2raya.slice \
  --security-opt no-new-privileges \
  --security-opt label=type:v2raya_container.process \
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

现在你可以用systemd控制v2rayA服务了。

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

如果您不再想使用v2rayA，移除v2rayA镜像：

```bash
sudo podman image rm docker.io/mzz2017/v2raya
```

以及移除SELinux规则 / iptables自动加载：

```bash
sudo semodule -r my_v2raya_container
sudo rm /etc/modules-load.d/ip_tables.conf
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

现在你可以用systemd控制v2rayA服务了。

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

v2rayA服务会跟随用户会话一起启动/停止。如果你想让v2rayA随系统启动，并且在用户会话结束后保持运行，使用以下命令：

```bash
loginctl enable-linger
```

#### 移除容器

```bash
systemctl --user disable --now container-v2raya.service
rm ~/.config/systemd/user/container-v2raya.service
systemctl --user daemon-reload
```

你也可以选择删除v2rayA的配置文件：

```bash
rm -r ~/.config/v2raya
```

如果您不再想使用v2rayA，移除v2rayA镜像：

```bash
podman image rm docker.io/mzz2017/v2raya
```

关闭linger：

```bash
loginctl disable-linger
```
