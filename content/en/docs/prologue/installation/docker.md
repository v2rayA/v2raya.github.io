---
title: Docker
description: Install the v2ray core and v2rayA
lead: The V2Ray core is integrated in the Docker image, so the core does not need to be installed.
date: 2020-11-16T13:59:39+01:00
lastmod: 2020-11-16T13:59:39+01:00
draft: false
images: []
menu:
  docs:
    parent: "installation"
weight: 15
toc: true
---

{{% notice info %}}
Docker is a platform for deploying applications that is designed for production environments. When using Docker for deployment, we assume that you have the knowledge necessary to operate a server, as well as an understanding of the concepts of containerization and the basics of Docker operations. If not, please use a simpler deployment method.
{{% /notice %}}

{{% notice info %}}
The following commands assume that you are operating as the root user. If you are not using the root user, you may need to use the `sudo` or `doas` commands to elevate your privileges.
{{% /notice %}}

## Method 1: Always use the latest version

### Pull the image

```sh
docker pull mzz2017/v2raya
```

### Run v2rayA

Stop the running version (if it exists):

```sh
docker container stop v2raya
docker container rm v2raya
```

Run v2rayA:

```bash
# run v2raya
docker run -d \
  --restart=always \
  --privileged \
  --network=host \
  --name v2raya \
  -e V2RAYA_LOG_FILE=/tmp/v2raya.log \
  -e V2RAYA_V2RAY_BIN=/usr/local/bin/v2ray \
  # use /usr/local/bin/v2ray or
  # /usr/local/bin/xray for V2RAYA_V2RAY_BIN
  # the default core is xray
  -e V2RAYA_NFTABLES_SUPPORT=off \
  # If you have nftables support on your host
  # set V2RAYA_NFTABLES_SUPPORT to on
  # Or you might meet iptables errors
  -v /lib/modules:/lib/modules:ro \
  -v /etc/resolv.conf:/etc/resolv.conf \
  -v /etc/v2raya:/etc/v2raya \
  mzz2017/v2raya
```

If you use macOS or other environments that do not support host mode, **you cannot use the global transparent proxy** in this case, or you do not want to use the global transparent proxy, the docker command will be slightly different:

```bash
# run v2raya
docker run -d \
  -p 2017:2017 \
  -p 20170-20172:20170-20172 \
  --restart=always \
  --name v2raya \
  -e V2RAYA_V2RAY_BIN=/usr/local/bin/v2ray \
  -e V2RAYA_LOG_FILE=/tmp/v2raya.log \
  -v /etc/v2raya:/etc/v2raya \
  mzz2017/v2raya
```

Check status:

```sh
docker container stats v2raya
```

## Method 2: Get a specific version

Docker allows users to download different versions of v2rayA simultaneously. By using different ports, users can also run multiple different versions of v2rayA.

```bash
Latest_version=$(curl -L "https://api.github.com/repos/v2rayA/v2rayA/releases/latest" | grep 'tag_name' | awk -F '"' '{print $4}' | awk -F 'v' '{print $2}')
echo $Latest_version
```

If you don't need the latest version, you can also visit the Docker image repository: [https://hub.docker.com/r/mzz2017/v2raya/tags](https://hub.docker.com/r/mzz2017/v2raya/tags) to find the version you need. For example, if you need the 1.5.8 version, then you can replace `$Latest_version` with the version you need.

Pull Docker images:

```sh
docker pull mzz2017/v2raya:$Latest_version
```

### Run v2rayA

```bash
# run v2raya
docker run -d \
  --restart=always \
  --privileged \
  --network=host \
  --name v2raya \
  -e V2RAYA_LOG_FILE=/tmp/v2raya.log \
  -v /lib/modules:/lib/modules:ro \
  -v /etc/resolv.conf:/etc/resolv.conf \
  -v /etc/v2raya:/etc/v2raya \
  mzz2017/v2raya:$Latest_version
```

If you use macOS or other environments that do not support host mode, **you cannot use the global transparent proxy** in this case, or you do not want to use the global transparent proxy, the docker command will be slightly different:

```bash
# run v2raya
docker run -d \
  -p 2017:2017 \
  -p 20170-20172:20170-20172 \
  --restart=always \
  --name v2raya \
  -e V2RAYA_LOG_FILE=/tmp/v2raya.log \
  -v /etc/v2raya:/etc/v2raya \
  mzz2017/v2raya:$Latest_version
```

Check status:

```sh
docker container stats v2raya
```

### Upgrade v2rayA

Use the command mentioned in [Pull the image]({{< ref "#pull-the-image" >}}) to get the latest version of the image, then stop the current container.

```sh
docker container stop v2raya
docker container rm v2raya
```

Finally, use the commands mentioned in [Run v2rayA]({{< ref "#run-v2raya" >}}) to run the new version of v2rayA. After updating v2rayA, you may consider deleting the old version image.
