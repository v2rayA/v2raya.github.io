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

## openSUSE MicroOS， SLE Micro， Fedora Silverblue / Kinoite

If your distribution uses an immutable file system layout, please **avoid** installing RPM version on host directly.

Go to: [Podman tutorial]().

## Fedora 34 / 35 / 36 and CentOS Stream 8

Warning: v2rayA is yet to make into Fedora 37 as of 11/19/2022. The following message from its COPR repo maintainer @zhullyb:

> Fedora 37 doesn't have golang 1.18, and the latest golang can't compile v2ray-core v4.X, v2rayA latest tag still hasn't implemented compatibility with v2ray-core v5.X.

If you want to use v2rayA on Fedora 37 right away, or to avoid this type of issues in the future, please follow the [podman tutorial]().

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

Warning: You should follow [podman tutorial]() instead. Avoid overlaying packages on Silverblue / Kinoite.

If you want to install it on host anyway, the tutorial to install v2rayA is as of the following:

### Add COPR source

```bash
sudo curl -Lo /etc/yum.repos.d/_copr:copr.fedorainfracloud.org:zhullyb:v2rayA.repo \
  https://copr.fedorainfracloud.org/coprs/zhullyb/v2rayA/repo/fedora-$(rpm -E %fedora)/zhullyb-v2rayA-fedora-$(rpm -E %fedora).repo
```

### Install v2rayA

```bash
sudo rpm-ostree install v2ray-core v2raya
```

Then, reboot your system. Or use the following command to apply changes to your running system:

```bash
sudo rpm-ostree ex apply-live --allow-replacement
```

Enable and start the service:

```
sudo systemctl enable --now v2raya.service
```

## Other rpm-based operating systems

{{% notice info %}} This way can install v2rayA for Alma Linux, Rocky Linux, openSUSE, CentOS 7 or other Linux distribution based on rpm package manager, provided that the **distribution you are using uses systemd as system management tools** . {{% /notice %}}

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
