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

## Install V2Ray core / Xray core

V2Ray installation: [https://github.com/v2fly/fhs-install-v2ray](https://github.com/v2fly/fhs-install-v2ray)

Xray installation: [https://github.com/XTLS/Xray-install](https://github.com/XTLS/Xray-install)

You can turn off the service after installation, because v2rayA does not depend on the systemd service.

```bash
sudo systemctl disable v2ray --now ### Xray needs to replace the service with xray
```

## Install v2rayA

After [downloading the rpm package](https://github.com/v2rayA/v2rayA/releases) , run:

```bash
sudo rpm -i /path/download/installer_redhat_xxx_vxxx.rpm ### Replace the actual path where the rpm package is located by yourself
```
