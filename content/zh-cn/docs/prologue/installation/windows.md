---
title: "Windows"
description: "安装核心和 v2rayA"
lead: "本节介绍如何在 Windows 上安装 v2rayA。需要注意的是，目前在 Windows 上仅支持一键配置系统代理而非透明代理。"
date: 2021-08-31T14:48:45+08:00
lastmod: 2021-08-31T14:48:45+08:00
draft: false
images: []
menu:
  docs:
    parent: "installation"
weight: 15
toc: true
---

## 使用安装包

{{% notice info %}}
安装包将内置 v2ray-core，如需更换 Xray-core，可在安装完毕后于安装目录手动进行替换。
{{% /notice %}}

### 方法一：通过 WinGet 自动安装

[WinGet](https://www.microsoft.com/en-us/p/app-installer/9nblggh4nns1) 是微软推出的软件包管理器，适用于 Windows 10 以及更新版本的操作系统。

```ps1
winget install --id v2raya.win
```

### 方法二：手动运行安装包

从 [GitHub Releases](https://github.com/v2rayA/v2rayA/releases) 下载适用于 Windows 的安装包，例如 installer_windows_x64_1.5.6.exe，按照指示安装完毕即可。

### 使用方法

通过安装包安装 v2rayA 后，v2rayA 将以服务的形式运行，默认情况下将开机自启，你也可以在任务管理器中的“服务”选项卡管理 v2rayA 的启动与停止。你可以通过运行桌面快捷方式或直接访问 http://127.0.0.1:2017 打开管理页面。

## 使用 Scoop 安装二进制

### 安装 v2rayA

{{% notice info %}}
所有的命令都在 PowerShell 中运行，CMD 用户请注意命令格式。
{{% /notice %}}

你首先需要安装 [Scoop](https://scoop.sh) ，然后才能从 scoop 安装 v2rayA。

添加 Scoop 源：

```ps1
scoop bucket add v2raya https://github.com/v2rayA/v2raya-scoop
```

更新 Scoop 信息：

```ps1
scoop update
```

安装：

```ps1
scoop install v2raya
```

V2Ray 核心将作为依赖包而被安装，如果想使用 Xray，请指定 `--v2ray-bin` 参数。

### 运行 v2rayA

#### 前台运行

打开一个 CMD 或者 PowerShell 窗口，然后运行：

```ps1
v2rayaWin --lite
```

#### 后台运行

使用 `start-v2ray` 命令运行 v2rayA，使用 `stop-v2raya` 命令关掉 v2rayA。

#### 开机自启

将你 `scoop\shims` 目录下的 `start-v2raya-unstable.cmd` 复制到“启动”文件夹（一般位于 `C:\Users\YourUserName\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup`）即可。示例命令如下：

```ps1
Copy-Item -Path '~\scoop\shims\start-v2raya.cmd' -Destination '~\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup'
```

## 手动安装

### 下载 v2rayA

从 [GitHub Releases](https://github.com/v2rayA/v2rayA/releases) 或 GitHub Action 下载适用于 Windows 的二进制文件（名称一般类似于 v2raya_windows_arm64_1.5.6.2.exe），然后重命名为 `v2raya.exe`（格外注意 Windows 系统下不能丢失扩展名）。

### 下载 V2Ray 核心 / Xray 核心

> 安装 V2Ray：<https://www.v2fly.org/guide/install.html>
> 安装 Xray：<https://xtls.github.io/document/install.html>

下载压缩包之后解压即可。

### 运行 v2rayA

假设 v2rayA 与 v2ray 都放在了 `D:\v2rayA`:

```ps1
D:\v2rayA\v2raya.exe --lite --v2ray-bin D:\v2rayA\v2ray.exe
```

## 其它信息

以下假设 v2rayA 是通过 scoop 安装的，如果是手动安装的请注意修改路径。

### 作为服务运行(使用 WinSW)

使用 [WinSW](https://github.com/winsw/winsw/) 可以将 v2rayA 作为服务运行并自动开机启动，下载 WinSW 并将其重命名为 `winsw.exe`，再将其放到一个你认为合适的目录，然后同样的目录下新建 `v2raya-service.xml` ：

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

此处的用户名是你显示在“计算机管理”中的用户名，而非在控制面板或系统设置里面看到的完整用户名。密码是你的本地账户密码或者微软账户密码。

如果是手动安装的 v2rayA，那么你需要指定 `--v2ray-bin` 参数，或者将 v2ray 添加到 path。

保存文件，然后运行（需要管理员权限）：

```ps1
.\winsw.exe install .\v2raya-service.xml
```

### 作为服务运行(使用 NSSM)

使用 [NSSM - the Non-Sucking Service Manager](https://nssm.cc/) 可以将 v2rayA 作为服务运行并自动开机启动。
下载 NSSM 并放在一个合适的目录或者使用 scoop 安装 NSSM。

```ps1
scoop install nssm
```

然后以管理员身份安装一个名为 v2raya 的 service：

```ps1
nssm install v2raya
```

此时会弹出一个 NSSM 窗口：
`Path` 为 v2rayA 路径 `C:\Users\YourHomeDir\scoop\apps\v2raya\current\v2rayaWin.exe`；
`Srartup directory` 可留空，默认为 v2rayA 所在目录；
`Arguments` 填写 `--lite --v2ray-bin C:\Users\YourHomeDir\scoop\apps\v2ray\current\v2ray.exe`。

可能用得到的其他参数：`--log-file v2raya.log` 会在 `Srartup directory` 生成 log 文件并在前端显示。

最后以管理员身份运行：

```ps1
nssm start v2raya
```

```ps1
nssm remove v2raya # 删除服务
nssm edit v2raya # 编辑服务
nssm start/stop/restart v2raya # 启动、停止、重启服务
```

### 后台运行（通过 PowerShell 隐藏窗口）：

```ps1
Start-Process "v2rayaWin.exe" -Arg "--lite" -WindowStyle Hidden
```

如果想在后台运行时也在前端输出日志，需要在参数里指定日志的输出文件（这里指定工作目录为当前用户的`%temp%`目录），可以使用如下的powershell命令：

```ps1
Start-Process "v2raya.exe" -WorkingDirectory "~\AppData\Local\Temp" -Arg "--log-file v2raya.log" -WindowStyle Hidden
```

### 后台运行（使用 ConEmu）

[ConEmu](https://conemu.github.io/) 是一个 Windows 下的终端程序，右击它窗口上的最小化按钮可以让它把窗口最小化到托盘区。在 ConEmu 中的 PowerShell 会话中使用 [直接运行]({{< ref "#直接运行" >}}) 项里面提到的命令运行 v2rayA 即可。

## 系统代理问题

截至 v1.5.8.2，v2rayA 在 Windows 上仅支持系统代理，该方式不同于透明代理，无法作用于部分应用。

另外，Windows 存在着开启系统代理后 UWP 应用无法联网的问题，这是因为出于安全问题，UWP 应用在默认情况下不允许访问本地回环地址，因此需要借助一些工具来避免这种问题，例如 Fiddler 的 [Enable Loopback Utility](https://telerik-fiddler.s3.amazonaws.com/fiddler/addons/enableloopbackutility.exe) 或开源项目 [Loopback Exemption Manager](https://github.com/tiagonmas/Windows-Loopback-Exemption-Manager)。
