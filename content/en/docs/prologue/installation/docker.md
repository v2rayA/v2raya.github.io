---
title: Docker
description: Install the v2ray core and v2rayA
lead: The V2Ray core is integrated in the Docker image, so the core does not need to be installed.
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

### Docker Method

Use the docker command to deploy.

```bash
# run v2raya
docker run -d \
  --restart=always \
  --privileged \
  --network=host \
  --name v2raya \
  -e V2RAYA_ADDRESS=0.0.0.0:2017 \
  -v /lib/modules:/lib/modules:ro \
  -v /etc/resolv.conf:/etc/resolv.conf:ro \
  -v /etc/v2raya:/etc/v2raya \
  mzz2017/v2raya
```

---

If you use MacOSX or other environments that do not support host mode **, you cannot use the global transparent proxy** in this case, or you do not want to use the global transparent proxy, the docker command will be slightly different:

```bash
# run v2raya
docker run -d \
  -p 2017:2017 \
  -p 20170-20172:20170-20172 \
  --restart=always \
  --name v2raya \
  -v /etc/v2raya:/etc/v2raya \
  mzz2017/v2raya
```
