---
title: Debian / Ubuntu
description: Install the V2Ray core and v2rayA
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

### Method 1: Install through the software source

#### Add public key

```bash
wget -qO - https://apt.v2raya.mzz.pub/key/public-key.asc | sudo apt-key add -
```

#### Add V2RayA software source

```bash
echo "deb https://apt.v2raya.mzz.pub/ v2raya main" | sudo tee /etc/apt/sources.list.d/v2raya.list
sudo apt update
```

#### Install V2RayA

```bash
sudo apt install v2raya
```

### Method 2: Manually install the deb package

After [downloading the deb package](https://github.com/v2rayA/v2rayA/releases) , you can use graphical tools such as Gdebi, QApt to install, or you can use the command line:

```bash
sudo apt install /path/download/installer_debian_xxx_vxxx.deb ### Replace the actual path where the deb package is located by yourself
```
