---
title: life cycle hook
description: Introduction and Examples of Lifecycle Hooks
lead: This section describes how to use lifecycle hooks.
date: '2022-07-03 13:59:39 +0100'
lastmod: '2022-07-03 13:59:39 +0100'
draft: 'false'
images: []
menu:
  docs:
    parent: manual
toc: 'true'
weight: '445'
---

Use the `--transparent-hook` parameter of v2rayA or the corresponding environment variable `V2RAYA_TRANSPARENT_HOOK` to run the program provided by the user before the transparent agent starts, after it starts, before it stops, and after it stops. The user can add, delete or modify iptables rules in the custom program , sysctl rules or execute any other command for advanced usage. For the transmission of v2rayA parameters, please refer to the instructions in the [Environment Variables and Command Line Parameters]({{% relref "variable-argument#How to set" %}}) section. Correspondingly, `--core-hook` can run the program provided by the user before v2ray-core starts, after starting, before stopping, and after stopping.

In addition to a parameter that the user needs to provide to v2rayA, v2rayA will also pass in parameters to inform the context information when executing the user-defined program. Users can analyze the incoming parameters in the custom program to determine the current v2rayA transparent proxy type (tproxy, redirect, system_proxy), and the current stage (pre-start, post-start, pre-stop, post-stop ).

The table below shows the parameters that the v2rayA corresponding hook type supports to pass in when running the user-defined program.

Hook type/parameter | --stage | --transparent-type | --v2raya-confdir
--- | --- | --- | ---
--transparent-hook | ✓ | ✓ | ✓
--core-hook | ✓ | ✗ | ✓

The following is an example of a bash script as a custom program for `--transparent-hook` . This example will resolve the transparent proxy type to the `$TYPE` variable, and the current stage to the `$STAGE` variable, and finally print out the context variable:

```bash
#!/bin/bash

# parse the arguments
for i in "$@"; do
  case $i in
    --transparent-type=*)
      TYPE="${i#*=}"
      shift
      ;;
    --stage=*)
      STAGE="${i#*=}"
      shift
      ;;
    --v2raya-confdir=*)
      CONFDIR="${i#*=}"
      shift
      ;;
    -*|--*)
      echo "Unknown option $i"
      shift
      ;;
    *)
      ;;
  esac
done

# print $TYPE, $STAGE and $CONFDIR
echo "Transparent Type = ${TYPE}"
echo "Stage            = ${STAGE}"
echo "Config Directory = ${CONFDIR}"
```

With context variables, users can write operations according to their needs.

In order to verify the validity of this program, the user only needs to save the script and grant execution permission through `chmod +x example.sh` , then pass the script path as `--transparent-hook` to v2rayA, and the output results will be displayed before and after the transparent proxy is executed. Output as v2rayA log.

This parameter is not limited to bash scripts, you can also pass in the file paths of python scripts or other executable programs with execute permission.

{{% notice warning %}} Make sure that only root has write permission for the incoming script to prevent unauthorized execution vulnerabilities. {{% /notice %}}
