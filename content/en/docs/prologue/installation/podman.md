---
title: "Podman"
description: "Use Podman to run v2rayA"
lead: "This tutorial requires systemd to be installed. Auto-start needs to be handled manually otherwise."
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

This tutorial is made for:

- Fedora Silverblue / Kinoite
- SLE Micro / openSUSE Leap Micro
- openSUSE MicroOS

But it also works on general-purpose distributions, such as:

- Fedora Workstation
- openSUSE Leap / Tumbleweed
- CentOS Stream

## Install Podman

Podman came pre-installed on some distributions. If yours haven't, follow this tutorial:

[https://podman.io/getting-started/installation.html#installing-on-linux](
https://podman.io/getting-started/installation.html#installing-on-linux)

## Setup v2rayA

Both [rootful mode](#rootful-mode) and [rootless mode](#rootless-mode) are supported.

{{% notice info %}}
The container image used in this tutorial is maintained directly by @mzz2017, circumventing security audits by your distribution repository. Continuing using it implies trusting @mzz2017.
{{% /notice %}}

### Rootful Mode

If you want to use transparent proxy or routing, you need to use rootful mode.

#### Download container image

Direct download:

```bash
sudo podman pull \
    docker.io/mzz2017/v2raya
```

If your device can't access Docker Hub directly, use an existing HTTP proxy to download:

```bash
sudo env \
HTTP_PROXY=http://<Address>:<Port> \
HTTPS_PROXY=http://<Address>:<Port> \
  podman pull \
    docker.io/mzz2017/v2raya
```

You may also use `sudo podman image import` to import container image from other sources.

### Auto load iptables modules

```bash
sudo mkdir /etc/modules-load.d
cat << 'EOF' | sudo tee /etc/modules-load.d/ip_tables.conf >> /dev/null 2>&1
ip_tables
ip6_tables
EOF
sudo modprobe ip_tables ip6_tables
```

### Create SELinux policies

{{% notice info %}}
If your distribution does not use SELinux, skip this part.</br>
Go to: [Create container](#create-container)
{{% /notice %}}

SELinux tends to block some v2rayA actions, causing transparent proxy to fail to setup.

{{% notice warning %}}
Security warning: Make sure no other user privilege process have write access to the current working directory.
{{% /notice %}}

Create policy file:

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

Load the policy file.

```bash
sudo semodule -i my_v2raya_container.cil
```

#### Create container

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

Configurations are stored in `/etc/v2raya`.

#### Create systemd service

```bash
bash -c \
  "sudo mkdir -p /etc/systemd/system \
  && cd /etc/systemd/system \
  && sudo podman generate systemd --new --files --name v2raya \
  && sudo systemctl daemon-reload"
```

#### Enable container auto update

```bash
sudo systemctl enable --now podman-auto-update.timer
```

#### Enable v2rayA service

Now you can manage v2rayA service with systemd.

Check service status:

```bash
systemctl status container-v2raya.service
```

Enable and start the service:

```bash
sudo systemctl enable --now container-v2raya.service
```

Open your browser and visit [http://localhost:2017](http://localhost:2017).

#### Remove container

```bash
sudo systemctl disable --now container-v2raya.service
sudo rm /etc/systemd/system/container-v2raya.service
sudo systemctl daemon-reload
```

Optionally delete v2rayA configurations:

```bash
sudo rm -r /etc/v2raya
```

In case you do not want to use v2rayA again, remove image from local storage:

```bash
sudo podman image rm docker.io/mzz2017/v2raya
```

And remove SELinux policy / iptables auto load:

```bash
sudo semodule -r my_v2raya_container
sudo rm /etc/modules-load.d/ip_tables.conf
```

### Rootless Mode

In case the only thing you need was a SOCKS5/HTTP port, you may run the container as standard user account, furthur reducing attack surface:

#### Download container image

Direct download:

```bash
podman pull \
    docker.io/mzz2017/v2raya
```

If your device can't access Docker Hub directly, use an existing HTTP proxy to download:

```bash
env \
HTTP_PROXY=http://<Address>:<Port> \
HTTPS_PROXY=http://<Address>:<Port> \
  podman pull \
    docker.io/mzz2017/v2raya
```

You may also use `podman image import` to import container image from other sources.

#### Create container

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

Configurations are stored in `~/.config/v2raya`.

#### Create systemd service

```bash
bash -c \
  "mkdir -p ~/.config/systemd/user \
  && cd ~/.config/systemd/user \
  && podman generate systemd --new --files --name v2raya \
  && systemctl --user daemon-reload"
```

#### Enable container auto update

```bash
systemctl --user enable --now podman-auto-update.timer
```

#### Enable v2rayA service

Now you can manage v2rayA service with SystemD.

Check service status:

```bash
systemctl --user status container-v2raya.service
```

Enable and start the service:

```bash
systemctl --user enable --now container-v2raya.service
```

Open your browser and visit [http://localhost:2017](http://localhost:2017).

Then you can configure proxy settings to `http://localhost:20171` in system settings.

v2rayA service starts/stops with user session. If you want to make v2rayA start regardless of user session and to continue running after user session is destroyed, use this command:

```bash
loginctl enable-linger
```

#### Remove container

```bash
systemctl --user disable --now container-v2raya.service
rm ~/.config/systemd/user/container-v2raya.service
systemctl --user daemon-reload
```

Optionally delete v2rayA configurations:

```bash
rm -r ~/.config/v2raya
```

In case you do not want to use v2rayA again, remove image from local storage:

```bash
podman image rm docker.io/mzz2017/v2raya
```

Disable lingering:

```bash
loginctl disable-linger
```
