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

## Use the installation package

{{% notice info %}}
The installation package will have v2ray-core built-in. If you need to replace Xray-core, you can manually replace it in the installation directory after the installation is complete.
{{% /notice %}}

### Method 1: Automatic installation through WinGet

[WinGet](https://www.microsoft.com/en-us/p/app-installer/9nblggh4nns1) is a package manager launched by Microsoft for Windows 10 and newer operating systems.

```ps1
winget install --id v2rayA.v2rayA
```

### Method 2: Manually run the installer

Download the installation package for Windows from [GitHub Releases](https://github.com/v2rayA/v2rayA/releases) , such as `installer_windows_inno_x64_2.0.1.exe` , and follow the instructions to complete the installation.

### Instructions

After installing v2rayA through the installation package, v2rayA will run as a service. By default, it will start automatically. You can also manage the start and stop of v2rayA in the "Service" tab of the task manager. You can open the management page by running the desktop shortcut or directly visiting [http://127.0.0.1:2017](http://127.0.0.1:2017) .

## Install binaries through Scoop

### Install v2rayA

{{% notice info %}} All commands are run in PowerShell, CMD users please pay attention to the command format. {{% /notice %}}

You need to install [Scoop](https://scoop.sh) first, then you can install v2rayA from scoop.

Add Scoop repo:

```ps1
scoop bucket add v2raya https://github.com/v2rayA/v2raya-scoop
```

Update Scoop information:

```ps1
scoop update
```

Install:

```ps1
scoop install v2raya
```

V2Ray core will be installed as a dependency package.

### Run v2rayA

#### Running in the foreground

Open a CMD or PowerShell window and run:

```ps1
v2rayaWin --lite
```

#### Running in the background

Use the `start-v2raya` command run v2rayA, and use the `stop-v2raya` command to shut down v2rayA.

#### Auto-start

Copy `start-v2raya.cmd` in `scoop\shims` directory to the "Startup" folder (usually located at `C:\Users\YourUserName\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup` ). Example commands are as follows:

```ps1
Copy-Item -Path '~\scoop\shims\start-v2raya.cmd' -Destination '~\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup'
```

## Manual installation

### Download v2rayA

Download the binary for Windows (generally named like v2raya_windows_amd64_1.5.6.2.exe) from [GitHub Releases](https://github.com/v2rayA/v2rayA/releases) or GitHub Action, then rename it to `v2raya.exe` (be careful not to lose the extension on Windows).

### Download V2Ray Core

> Install V2Ray: [https://www.v2fly.org/guide/install.html](https://www.v2fly.org/guide/install.html)

After downloading the compressed package, unzip it.

### Run v2rayA

Suppose both v2rayA and v2ray are placed in `D:\v2rayA` :

```ps1
D:\v2rayA\v2raya.exe --lite --v2ray-bin D:\v2rayA\v2ray.exe
```

## Other Information

The following assumes that v2rayA is installed through scoop, if it is installed manually, please pay attention to modify the path.

### Run as a service (using WinSW)

Using [WinSW,](https://github.com/winsw/winsw/) you can run v2rayA as a service and start it automatically. Download WinSW and rename it to `winsw.exe` , put it in a directory you think is appropriate, and then create a new `v2raya-service.xml` in the same directory:

```xml
<service>
  <id>org.v2raya.v2raya</id>
  <name>v2rayA</name>
  <description>This service runs v2rayA.</description>
  <executable>C:\Users\YourHomeDir\scoop\apps\v2raya\current\v2rayaWin.exe</executable>
  <arguments>--lite</arguments>
  <log mode="roll"></log>
  <env name="V2RAYA_LOG_FILE" value="%v2raya.log%"/>
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

If v2rayA is manually installed, then you need to specify the `--v2ray-bin` parameter, or add v2ray to the path.

Save the file, then run (requires administrator privileges):

```ps1
.\winsw.exe install .\v2raya-service.xml
```

### Run as a service (using NSSM)

Use [NSSM - the Non-Sucking Service Manager](https://nssm.cc/) to run v2rayA as a service and start it automatically. Download NSSM and place it in a suitable directory or use scoop to install NSSM.

```ps1
scoop install nssm
```

Then install a service called v2raya as an administrator:

```ps1
nssm install v2raya
```

At this time, an NSSM window will pop up: `Path` is v2rayA path `C:\Users\YourHomeDir\scoop\apps\v2raya\current\v2rayaWin.exe` ; `Srartup directory` can be left blank, and the default is the directory where v2rayA is located; `Arguments` fill in `--lite --v2ray-bin C:\Users\YourHomeDir\scoop\apps\v2ray\current\v2ray.exe` .

Other parameters that may be used: `--log-file v2raya.log` will generate a log file in `Srartup directory` and display it on the front end.

Finally run as administrator:

```ps1
nssm start v2raya
```

```ps1
nssm remove v2raya # delete service
nssm edit v2raya # Edit service
nssm start/stop/restart v2raya # start, stop, restart service
```

### Running in background (hide window via PowerShell):

```ps1
Start-Process "v2rayaWin.exe" -Arg "--lite" -WindowStyle Hidden
```

If you want to output the log at the front end while running in the background, you need to specify the output file of the log in the parameter (here the specified working directory is `%temp%` directory of the current user), you can use the following powershell command:

```ps1
Start-Process "v2raya.exe" -WorkingDirectory "~\AppData\Local\Temp" -Arg "--log-file v2raya.log" -WindowStyle Hidden
```

### Run in the background (using ConEmu)

[ConEmu](https://conemu.github.io/) is a terminal program under Windows. Right-clicking the minimize button on its window can make it minimize the window to the tray area. In the PowerShell session in ConEmu, use the command mentioned in the [Direct Run]({{&lt; ref "#Direct Run" &gt;}}) item to run v2rayA.

### system proxy

#### Turn on system proxy

v2rayA currently only supports system proxy on Windows, you can enable System Proxy in the web interface to enable it.

{{% notice info %}} Some applications (such as command-line programs) may not read or use the system proxy, you may need `proxychains` to force them to use the proxy, or use the program's own proxy configuration. {{% /notice %}}

{{% notice info %}} If v2rayA exits unexpectedly, then v2rayA cannot help you cancel the system proxy when exiting. In this case, you need to turn off the proxy in Internet options or system settings. {{% /notice %}}

#### Let the UWP application go through the proxy

> Reference content: [https://github.com/Qv2ray/Qv2ray/issues/562](https://github.com/Qv2ray/Qv2ray/issues/562)

Windows has the problem that UWP applications cannot connect to the Internet after the system proxy is turned on. This is because for security reasons, UWP applications are not allowed to access the local loopback address by default, and most proxies will listen to the loopback address in order to provide socks and http proxy Entrance. In order to circumvent this problem, we need some tools, such as Fiddler's [Enable Loopback Utility](https://telerik-fiddler.s3.amazonaws.com/fiddler/addons/enableloopbackutility.exe) or the open source project [Loopback Exemption Manager](https://github.com/tiagonmas/Windows-Loopback-Exemption-Manager) . Alternatively, you can do this in bulk with the following PowerShell command, open a PowerShell window with administrator privileges, and run:

```ps1
Get-ChildItem -Path Registry::"HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Mappings\" -name | ForEach-Object {CheckNetIsolation.exe LoopbackExempt -a -p="$_"}
```

### Reset password under Windows

#### v2rayA installed by Scoop

```ps1
v2raya --reset-password
```

Replace the command with `v2raya-unstable` or `v2raya-git` according to the package you installed, and you need to restart v2rayA after password reset.

#### v2rayA installed by the inno installation package

Open a PowerShell window with administrator privileges, and run:

```ps1
sc.exe stop v2rayA
${env:V2RAYA_CONFIG} = 'C:\Program Files\v2rayA'
&'C:\Program Files\v2rayA\bin\v2raya.exe' --lite --reset-password
sc.exe start v2rayA

```
