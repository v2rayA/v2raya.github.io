---
title: "自定义 v2ray-core 配置"
description: "自定义 v2ray-core 配置"
lead: "本节介绍如何利用 core 生命周期钩子自定义 v2ray-core 配置。"
date: 2022-07-10T13:59:39+01:00
lastmod: 2022-07-10T13:59:39+01:00
draft: false
images: []
menu:
  docs:
    parent: "advanced-application"
toc: true
weight: 720
---

### 自定义 v2ray-core 配置

下面介绍利用 core 生命周期钩子修改 v2ray-core 的 config.json，使得自定义配置文件成为可能。生命周期钩子的介绍见 [生命周期钩子]({{% relref "hook" %}}) 一节。

下面使用脚本在 v2ray-core 启动前添加一个支持 sniffing 的 sniffing-socks 入站，并修改路由部分使得该端口的分流模式跟随规则端口。

首先确保 `/usr/bin/python` 可用。

编写如下 python 脚本，将其存储于 `/etc/v2raya/core-hook.py` ：

```python
#!/usr/bin/python

import argparse
from os import path
import json

def main():
    # parse the arguments
    parser = argparse.ArgumentParser()
    parser.add_argument('--v2raya-confdir', type=str, required=True)
    parser.add_argument('--stage', type=str, required=True)
    args = parser.parse_args()

    # we only modify the config file at the pre-start stage
    if args.stage != 'pre-start':
        return
    # read the content from the config.json
    conf_path = path.join(args.v2raya_confdir, 'config.json')
    with open(conf_path) as f:
        conf = json.loads(f.read())
    # append a socks with sniffing and routing rule inbound
    sniffing_socks = {'port': 11698, 'protocol': 'socks', 'listen': '0.0.0.0', 'sniffing': {'enabled': True}, 'tag': 'sniffing-socks'}
    conf['inbounds'].append(sniffing_socks)
    # add routing rule support for this inbound (follow the rule port)
    for rule in conf['routing']['rules']:
        if 'inboundTag' not in rule:
            continue
        with_rule = False
        for tag in rule['inboundTag']:
            if tag.startswith('rule-http'):
                with_rule = True
                break
        if with_rule:
            rule['inboundTag'].append(sniffing_socks['tag'])
            
    # write back to the file
    with open(conf_path, 'w') as f:
        f.write(json.dumps(conf))

if __name__ == '__main__':
    main()
```

赋予可执行权限：

```bash
sudo chmod +x /etc/v2raya/core-hook.sh
```

启动 v2raya 时添加参数 `--core-hook /etc/v2raya/core-hook.sh`。
