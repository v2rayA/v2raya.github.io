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
      proxy_redirect off;
      proxy_set_header Accept-Encoding "";
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection $connection_upgrade;
      rewrite ^/v2raya$ / break;
      rewrite ^/v2raya/(.*)$ /$1 break;
      sub_filter '\"static/' '\"/v2raya/static/';
      sub_filter '\"/api/' '\"/v2raya/api/';
      sub_filter_once off;
      sub_filter_types application/javascript;
      proxy_pass http://127.0.0.1:2017;
    }
  }
}
```
