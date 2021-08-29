---
title: Get started quickly
description: Quick start v2rayA
lead: This section will introduce the most basic usage of v2rayA.
date: '2020-11-16 13:59:39 +0100'
lastmod: '2020-11-16 13:59:39 +0100'
draft: 'false'
images: []
menu:
  docs:
    parent: prologue
weight: '20'
toc: 'true'
---

## Prepare

If you have not installed v2rayA or v2ray-core, please refer to the [Installation]({{% relref "installation" %}}) section. If you need to replace other cores, such as Xray-core, please refer to the [Use other cores]({{% relref "use-other-core" %}}) section.

## Start

If you cannot access the UI interface through the 2017 port such as [http://localhost:2017](http://localhost:2017) , please check whether your service has been started. [related issue](https://github.com/v2rayA/v2rayA/issues/237)

Next, enter the UI, this section will introduce the basic operation process of v2rayA.

### Create an account

![Create an account](images/create-account.png)

When you enter the page for the first time, you need to create an administrator account. Please keep your username and password properly. If you forget, use the `sudo v2raya --reset-password` command to reset.

### Import nodes

![Import nodes](images/import-servers.png)

Import nodes by creating or importing, and import supports node links, subscription links, scanning QR codes, and batch import.

### Connect nodes and start services

#### Connect a node

![Connect a node](images/connect1.png)

After the import is successful, the node will be displayed in the `SERVER` or new tab. The picture shows the interface after importing a subscription.

![Connect a node](images/connect2.png)

Switch to this tab and select one or more nodes to connect. It is not recommended to select too many nodes here, 6 or less is better.

{{% notice note %}}

As of August 27, 2021, xray has not yet supported observation-based load balancing, so connecting multiple nodes in v2rayA is unique to v2fly/v2ray-core. For load balancing, please refer to the [Load Balancing] ({{% relref "loadbalance" %}}) section.

If you need to check the availability of the node before connecting, such as delay test, please refer to the [Node and subscription operation] ({{% relref "manipulation" %}}) section.

{{% /notice %}}

#### Start the service

![Start service](images/connect3.png)

When the service is not started, the connected node appears teak red. We click the corresponding button in the upper left corner to start the service.

![Start service](images/connect4.png)

After the service is started, the connected node is blue, and the icon in the upper left corner is also displayed as blue, which means the service is started successfully.

### Configure proxy

Because by default v2rayA will open 20170 (socks5), 20171 (http), 20172 (http with shunt rules) ports through the core. To modify the port, please refer to the [Backend Address and Inbound Port Settings] ({{% relref "address-port" %}}) section.

If you need to provide a proxy for other machines in the LAN, please turn on "LAN Sharing" in the settings and check the firewall opening.

Here are three ways to use the proxy.

#### Transparent proxy

![Transparent proxy](images/tproxy.png)

This method is recommended by v2rayA. Compared with other methods, it has many advantages. v2rayA can open a transparent proxy with one click and provide proxy services **for almost all programs.**

In the settings, select the splitting method and implementation method of the transparent proxy, and then save it. For details, please refer to the [Transparent Proxy] ({{% relref "transparent-proxy" %}}) section.

Note that if you need to select GFWList, you need to download the corresponding rule library. Please click Update in the upper right corner to complete the download.

#### System proxy

System agents can provide agent services **for programs that actively support agents.** The locations set in different desktop environments are different, please search by yourself through search engines.

#### SwitchyOmega

Browser plug-ins such as SwitchyOmega can provide proxy services **for the browser.** For specific methods, please search by yourself through a search engine.

## Summarize

This section provides the most basic usage of v2rayA. v2rayA has more rich functions. Please refer to the "Manual" and "Advanced Applications" chapters for more understanding.
