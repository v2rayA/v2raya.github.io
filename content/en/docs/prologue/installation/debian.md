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

## Install v2rayA

### Method 1: Install through the software source

#### Add public key

```bash
wget -qO - https://github.com/v2rayA/v2raya-apt/blob/master/key/public-key.asc | sudo tee /etc/apt/keyrings/v2raya.asc
```

#### Add V2RayA software source

```bash
echo "deb [signed-by=/etc/apt/keyrings/v2raya.asc] https://github.com/v2rayA/v2raya-apt/raw/master v2raya main" | sudo tee /etc/apt/sources.list.d/v2raya.list
sudo apt update
```

#### Install V2RayA

```bash
sudo apt install v2raya v2ray ## you can install xray package instead of if you want
```

### Method 2: Manually install the deb package

After [downloading the deb package](https://github.com/v2rayA/v2rayA/releases) , you can use graphical tools such as Gdebi, QApt to install, or you can use the command line:

```bash
sudo apt install /path/download/installer_debian_xxx_vxxx.deb ### Replace the actual path where the deb package is located by yourself
```

V2Ray and Xray debian packages can be found in [APT Repo](https://github.com/v2rayA/v2raya-apt/tree/master/pool/main/)

## Start v2rayA / Enable v2rayA start automatically

> From the 1.5 version, it will no longer default start v2rayA and set auto-start.

- Start v2rayA

    ```bash
    sudo systemctl start v2raya.service
    ```

- Set auto-start

    ```bash
    sudo systemctl enable v2raya.service
    ```

<!-- ## Switch iptables to iptables-nft

For Debian11 users, iptables has been deprecated. Use nftables as the backend of iptables for adaptation:

Install iptables, automatically enabling iptables-nft:

```bash
apt install iptables
```

It is also possible to manually set up nftables as the backend for iptables for adaptation:

```bash
update-alternatives --set iptables /usr/sbin/iptables-nft
update-alternatives --set ip6tables /usr/sbin/ip6tables-nft
update-alternatives --set arptables /usr/sbin/arptables-nft
update-alternatives --set ebtables /usr/sbin/ebtables-nft
```

If you want to switch back to the legacy version:

```bash
update-alternatives --set iptables /usr/sbin/iptables-legacy
update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
update-alternatives --set arptables /usr/sbin/arptables-legacy
update-alternatives --set ebtables /usr/sbin/ebtables-legacy
```

Restart after switching. -->

## Use nftables

If you already have `nftables` firewall on your system, then v2rayA will use `nft` command first to create firewall rules. You can use the `--nftables-support` parameter or `V2RAYA_NFTABLES_SUPPORT` to control whether to enable nftables support.
