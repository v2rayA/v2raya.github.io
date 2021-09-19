---
title: "解锁网易云灰色歌曲"
description: "v2rayA 解锁网易云灰色歌曲介绍"
lead: ""
date: 2020-11-16T13:59:39+01:00
lastmod: 2020-11-16T13:59:39+01:00
draft: false
images: []
menu:
  docs:
    parent: "advanced-application"
toc: true
weight: 650
---

本案例将会向你展示如何使用 [nondanee/UnblockNeteaseMusic](https://github.com/nondanee/UnblockNeteaseMusic) 解锁网易云音乐的灰色歌曲。

1. 下载由 nondanee/UnblockNeteaseMusic 项目的作者提供的[证书](https://cdn.jsdelivr.net/gh/nondanee/UnblockNeteaseMusic@latest/ca.crt)。

2. 信任此证书。信任的办法取决于你使用的 Linux 发行版，(**archlinux/manjaro** 可以使用 `sudo trust anchor --store ca.crt`) [[ubuntu可以点我]](https://superuser.com/questions/437330/how-do-you-add-a-certificate-authority-ca-to-ubuntu)，其他发行版自己搜一下啦

   如果你想让在 LAN 网络的苹果设备也生效, 在 Safari 打开[证书](https://cdn.jsdelivr.net/gh/nondanee/UnblockNeteaseMusic@latest/ca.crt)并在`设置-通用-描述文件`中安装。安装成功后，在`设置-通用-关于本机-证书信任设置`中信任此证书

   ~~Android devices need to modify the network setting you connect (such as WLAN and APN) and set proxy to port 20172. Or if you have root privileges, you can try adding the certificate to **SYSTEM** root cert list (not USER one) [UnblockNeteaseMusic#423](https://github.com/nondanee/UnblockNeteaseMusic/issues/423#issuecomment-596621392)~~

   Fortunately, no additional operations need to do for Android devices.

3. 安装 nondanee/unblockneteasemusic:

   ```bash
   docker run -d -p 18080:8080 --restart always --name unblock nondanee/unblockneteasemusic -p 8080:8081 -e https://music.163.com
   ```

4. 设置 RoutingA:

   **基于大陆白名单模式：**

   ```bash
   outbound: unblockneteasemusic = http(address:"127.0.0.1", port:"18080")

   default: proxy

   # 下一行是为安卓设备准备的, 如果你不使用安卓设备，请你移除下一行，否则这将有可能影响到听歌记录。
   domain(regexp:clientlog\d*.music.163.com)->block
   domain(domain:163.com,domain:netease.com) && source(172.16.0.0/12)->direct
   domain(domain:163.com,domain:netease.com)->unblockneteasemusic

   domain(geosite:geolocation-!cn)->proxy
   domain(geosite:google-scholar)->proxy
   domain(geosite:cn, geosite:category-scholar-!cn, geosite:category-scholar-cn)->direct
   ip(geoip:hk,geoip:mo)->proxy
   ip(geoip:private, geoip:cn)->direct
   ```

   **基于GFWList模式:**

   ```bash
   outbound: unblockneteasemusic = http(address:"127.0.0.1", port:"18080")

   default: direct

   # 下一行是为安卓设备准备的, 如果你不使用安卓设备，请你移除下一行，否则这将有可能影响到听歌记录。
   domain(regexp:clientlog\d*.music.163.com)->block
   domain(domain:163.com,domain:netease.com) && source(172.16.0.0/12)->direct
   domain(domain:163.com,domain:netease.com)->unblockneteasemusic

   domain(geosite:geolocation-!cn)->proxy
   ```

5. 将透明代理设置为 "与规则端口所选模式一致"。

6. 完成啦！
