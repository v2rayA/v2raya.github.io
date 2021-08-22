---
title: 快速上手
description: Quick start v2rayA
lead: 'TODO: Create account password, import node, connect, set up transparent proxy, browser proxy, system proxy, etc. Basic usage, remind again how to switch the kernel, refer to the manual chapter. In this section, try not to quote from outside as much as possible, and simply introduce the process.'
date: '2020-11-16 13:59:39 +0100'
lastmod: '2020-11-16 13:59:39 +0100'
draft: 'false'
images: []
menu:
  docs:
    parent: prologue
weight: '20'
toc: 'true'
---

## Requirements

Doks uses npm to centralize dependency management, making it [easy to update]({{&lt; relref "how-to-update" &gt;}}) resources, build tooling, plugins, and build scripts:

- Download and install [Node.js](https://nodejs.org/) (it includes npm) for your platform.

## Start a new Doks project

Create a new site, change directories, install dependencies, and start development server.

### Create a new site

Doks is available as a child theme, and a starter theme:

- Use the Doks child theme, if you do **not** plan to customize a lot, and/or need future Doks updates.
- Use the Doks starter theme, if you plan to customize a lot, and/or do **not** need future Doks updates.

Not quite sure? Use the Doks child theme.

#### Doks child theme

```bash
git clone https://github.com/v2rayA/v2raya.github.io-child-theme.git my-doks-site
```

#### Doks starter theme

```bash
git clone https://github.com/v2rayA/v2raya.github.io.git my-doks-site
```

### Change directories

```bash
cd my-doks-site
```

### Install dependencies

```bash
npm install
```

### Start development server

```bash
npm run start
```

Doks will start the Hugo development webserver accessible by default at `http://localhost:1313` . Saved changes will live reload in the browser.

## Other commands
