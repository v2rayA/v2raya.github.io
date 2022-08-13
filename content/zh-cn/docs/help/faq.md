---
title: "FAQ"
description: "Answers to frequently asked questions."
lead: "Answers to frequently asked questions."
date: 2021-08-19T08:49:31+00:00
lastmod: 2021-08-19T08:49:31+00:00
draft: false
images: []
menu:
  docs:
    parent: "help"
toc: true
weight: 830
---

## v2rayA 会有 Electron 版本吗？

**A:** v2rayA 变成 Electron 是可能的，但是官方不会去做，因为大家的 PC 上有太多的 Chromium 了，我们不想让这个世界上再多一个 Chromium 的新皮肤。

## 开发组提供付费服务吗？

**A:** 不提供任何付费服务，如果你愿意支持我们，提交代码是一个非常好的选择。

## 旁路由需要注意什么？

**A:** 需要注意网关的层次，不能“互指”，同时建议开启“允许 IP 转发”以启用 Linux 系统的 `IP Forwarding` 功能。除此之外，DNS 查询也需要让 v2rayA 本身或者 v2rayA 所在主机的 DNS 查询软件接管，否则很可能无法避免 DNS 污染问题。

## v2rayA 开发者都是哪里人？

**A:** 我们都是 100% 的地球人，相信我，我们中间没有外星人或机器人。

## 为啥快捷方式/桌面图标打开来是空白的网页？

**A:** 桌面上的图标、菜单里面的图标的本质都是试图打开 <http://localhost:2017> 这个网页，即 v2rayA 默认监听的端口。你需要使用 `systemctl` 或 `brew services` 、 `/etc/init.d/v2raya` 或类似的命令来控制 v2rayA 本身的启动与关闭。

## OpenWrt 之外的 Linux 做网关合适吗？

**A:** 当然合适，以 Debian 举例，你可以用 `systemd-networkd` 做网络管理与 DHCPv4 服务器、DHCPv6 的中继器，用 `systemd-resolved` 来充当 DNS 查询转发工具，用 `pppoeconf` 来进行拨号。只是相对于 OpenWrt，普通 Linux 发行版需要你通过命令行来手动配置网络与 DNS。
