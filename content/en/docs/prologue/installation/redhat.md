---
title: RedHat / openSUSE
description: Install the core and v2rayA
lead: The function of v2rayA depends on the V2Ray core, so the kernel needs to be installed.
date: '2020-11-16 13:59:39 +0100'
lastmod: '2020-11-16 13:59:39 +0100'
draft: 'false'
images: []
menu:
  docs:
    parent: installation
weight: '15'
toc: 'true'
---

## Fedora 34 / 35 and CentOS Stream 8

### Enable copr source

```bash
sudo dnf copr enable zhullyb/v2rayA
```

### Install V2ray Core

```bash
sudo dnf install v2ray-core
```

> Xray installation: [https://github.com/XTLS/Xray-install](https://github.com/XTLS/Xray-install)

### Install v2rayA

```bash
sudo dnf install v2raya
```

## Fedora Silverblue / Kinoite

### Reliable way

Switch to a suitable directory:

```bash
cd ~/Downloads
mkdir v2rayA
cd v2rayA
```

Enter the toolbox:

```bash
toolbox enter
```

Enable the copr repository:

```bash
sudo dnf copr enable zhullyb/v2rayA
```

Download packages:

```bash
dnf download --resolve v2ray-core v2raya
```

Exit to host:

```bash
exit
```

Install downloaded packages on the host:

```bash
rpm-ostree install ./*.rpm
```

{{% notice warning %}}
Warning: Be aware of the race condition where downloaded packages got replaced by unprivileged malware before installing it on the host.
{{% /notice %}}

Then, reboot your PC, either by GUI or by command:

```bash
systemctl reboot
```

Enable and start `v2rayA`:

```bash
sudo systemctl enable --now v2raya.service
```

Package updates should be handled by user manually.

### Fast way

COPR repository is not supported by Fedora Silverblue / Kinoite where containerized workflows are expected, use it at your own risk. It seems to work for now but relavent functionalities may be changed or removed in the future.

```bash
# Add copr repository to your system
sudo curl -Lo /etc/yum.repos.d/_copr:copr.fedorainfracloud.org:zhullyb:v2rayA.repo \
  https://copr.fedorainfracloud.org/coprs/zhullyb/v2rayA/repo/fedora-$(rpm -E %fedora)/zhullyb-v2rayA-fedora-$(rpm -E %fedora).repo
# Install packages without rebooting
sudo rpm-ostree install -A v2ray-core v2raya
# Enable and start the service
sudo systemctl enable --now v2raya.service
```

Package updates are handled by `rpm-ostree` automatically.

## Other rpm-based operating systems

{{% notice info %}}
This method can install v2rayA for Alma Linux, Rocky Linux, openSUSE or other Linux distributions based on the rpm package manager, provided that the **distribution you are using uses systemd as a system management tool** .
{{% /notice %}}

### Install V2Ray core / Xray core

#### Official script of V2Ray / Xray

V2Ray installation: [https://github.com/v2fly/fhs-install-v2ray](https://github.com/v2fly/fhs-install-v2ray)

Xray installation: [https://github.com/XTLS/Xray-install](https://github.com/XTLS/Xray-install)

#### Mirror script provided by v2rayA (recommended)

```bash
curl -Ls https://mirrors.v2raya.org/go.sh | sudo bash
```

You can turn off the service after installation, because v2rayA does not depend on the systemd service.

```bash
sudo systemctl disable v2ray --now ### Xray needs to replace the service with xray
```

### Install v2rayA

After [downloading the rpm package](https://github.com/v2rayA/v2rayA/releases) , run:

```bash
sudo rpm -i /path/download/installer_redhat_xxx_vxxx.rpm ### Replace the actual path where the rpm package is located by yourself
```

## Notice

### Start v2rayA / Enable v2rayA start automatically

> Starting from version 1.5, v2rayA will no longer be started by default for users, nor will it be set to automatically start up by default.

- Start v2rayA

    ```bash
    sudo systemctl start v2raya.service
    ```

- Set auto-start

    ```bash
    sudo systemctl enable v2raya.service
    ```
