---
title: "将 v2rayA 部署于前缀路径中"
description: "将 v2rayA 部署到指定域名的指定路径下"
lead: "本节介绍如何将 v2rayA 部署到指定域名的指定路径下。"
date: 2022-06-22T13:59:39+01:00
lastmod: 2022-06-22T13:59:39+01:00
draft: false
images: []
menu:
  docs:
    parent: "advanced-application"
toc: true
weight: 700
---

## Nginx

下面例子中将 v2rayA 部署到 http://example.com:8080/v2raya 。注意，例中未包含 TLS 相关配置，建议添加 TLS 相关配置。

```nginx
http {
  map $http_upgrade $connection_upgrade {
    default upgrade;
    '' close;
  }
  server {
    listen 8080;
    server_name example.com;
    location ^~ /v2raya {
      proxy_pass http://bla:2017/;
      proxy_http_version 1.1;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection 'upgrade';
      proxy_set_header Host $host;
      proxy_cache_bypass $http_upgrade;

      proxy_redirect http://bla:2017/ /v2rayb/;
      sub_filter 'href="/' 'href="/v2rayb/';
      sub_filter 'src="/' 'src="/v2rayb/';
      sub_filter_once off;
    }
  }
}
```
