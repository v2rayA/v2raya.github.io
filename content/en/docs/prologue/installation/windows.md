---
title: Windows
description: Install core and v2rayA
lead: This section describes how to install v2rayA on Windows. It should be noted that currently only one-click configuration system proxy is supported on Windows, not transparent proxy.
date: '2021-08-31 14:48:45 +0800'
lastmod: '2021-08-31 14:48:45 +0800'
draft: 'false'
images: []
menu:
  docs:
    parent: installation
weight: '15'
toc: 'true'
---

## Using the installer

The {{% notice info %}} instaler will have v2ray-core built in. If you need to replace Xray-core, you can manually replace it in the installation directory after installation. {{% /notice %}}

### Method 1: Install via WinGet

[WinGet](https://www.microsoft.com/en-us/p/app-installer/9nblggh4nns1) is a package manager launched by Microsoft for Windows 10 and newer operating systems.

```ps1
winget install --id v2raya.win
```

### Method 2: Manually run the installer

Download the installer for Windows from [GitHub Releases](https://github.com/v2rayA/v2rayA/releases) , such as installer_windows_x64_1.5.6.exe, and follow the instructions to install it.

### Instructions

After installing v2rayA through the installer, v2rayA will run as a service. By default, it will start automatically. You can also manage the start and stop of v2rayA in the "Services" tab in the task manager. You can open the admin page by running the desktop shortcut or by visiting http://127.0.0.1:2017 directly.

## Using the v2rayA binary

{{% notice info %}} All commands are run in PowerShell, CMD users please pay attention to the command format. {{% /notice %}}

### Method 1: Install via Scoop

You can install v2rayA through [Scoop](https://scoop.sh) , and you can run the `v2raya` command directly after the installation is complete.

Add Scoop repo:

```ps1
scoop bucket add v2raya https://github.com/v2rayA/v2raya-scoop
```

Update Scoop information:

```ps1
scoop update
```

Install v2rayA:

```ps1
scoop install v2raya
```

The V2Ray core will be installed as a dependency package. If you want to use Xray, please specify `--v2ray-bin` parameter.

### Method 2: Manual download

#### Download v2rayA

Download the binary for Windows (generally named like v2raya_windows_amd64_1.5.6.2.exe) from [GitHub Releases](https://github.com/v2rayA/v2rayA/releases) or GitHub Action, then rename it to `v2raya.exe` (be careful not to lose the extension on Windows).

#### Download V2Ray Core / Xray Core

> Install V2Ray: [https://www.v2fly.org/guide/install.html](https://www.v2fly.org/guide/install.html)<br> Install Xray: [https://xtls.github.io/document/install.html](https://xtls.github.io/document/install.html)

After downloading the compressed package, unzip it.

### Run v2rayA

The following assumes that both v2rayA and the core are installed via scoop. If you downloaded v2rayA and core manually, it is recommended that you add them to Path, or use absolute paths.

#### Run on "Runs" Window

Just run the `v2raya` command, which comes with the `--lite` parameter. You can also use the following command to run:

```ps1
v2rayaWin --lite
```

#### Run as a service

Using [WinSW,](https://github.com/winsw/winsw/) you can run v2rayA as a service and start it automatically. Download WinSW and rename it to `winsw.exe` , put it in a directory you think is appropriate, and then create a new `v2raya-service.xml` in the same directory:

```xml
<service>
  <id>org.v2raya.v2raya</id>
  <name>v2rayA</name>
  <description>This service runs v2rayA.</description>
  <executable>C:\Users\YourHomeDir\scoop\apps\v2raya\current\v2rayaWin.exe</executable>
  <arguments>--lite</arguments>
  <log mode="roll"></log>
  <delayedAutoStart>true</delayedAutoStart>
  <onfailure action="restart" delay="10 sec"/>
  <onfailure action="restart" delay="20 sec"/>
  <serviceaccount>
    <username>.\YourUserName</username>
    <password>YourPassword</password>
    <allowservicelogon>true</allowservicelogon>
  </serviceaccount>
</service>
```

The username here is the username you see in Computer Management, not the full username you see in Control Panel or System Settings. The password is your local account password or Microsoft account password.

Save the file, then run:

```ps1
.\winsw.exe install .\v2raya-service.xml
```

This operation requires administrator rights, and the log file (output by WinSW) can be viewed in the directory where WinSW is located. If you want to view logs in v2rayA's web frontend, you need to specify a log file with the `--log-file` parameter.

#### Run in the background (using PowerShell's hidden window feature):

```ps1
Start-Process "v2rayaWin.exe" -Arg "--lite" -WindowStyle Hidden
```

#### Run in the background (using ConEmu)

[ConEmu](https://conemu.github.io/) is a terminal program under Windows. Right-clicking the minimize button on its window can make it minimize the window to the tray area. In the PowerShell session in ConEmu, use the command mentioned in the [Direct Run]({{&lt; ref "#Direct Run" &gt;}}) item to run v2rayA.
