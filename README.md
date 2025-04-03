# 🐉 Lua Development Environment (Progressive: Ubuntu → Alpine → Slim)

这是一个可进化的 Lua 开发容器项目，提供三个阶段性的镜像版本：Ubuntu、Alpine 和 Alpine Slim，分别面向不同开发与部署场景，适用于本地开发、POSIX 环境验证、以及最终嵌入式部署优化。

---

## 🧭 设计理念

本项目遵循从「功能丰富」到「极致精简」的递进式构建思路：

1. ✅ **Ubuntu**：面向开发者的全功能 Lua 环境（支持 LuaRocks、bash 等）
2. ✅ **Alpine**：轻量级 POSIX Lua 环境，接近嵌入式系统运行形态
3. ✅ **Alpine Slim**：纯 Lua 精简镜像（无 LuaRocks、无 bash），为嵌入式部署打基础

目标是逐步压缩环境规模，最终导向一个可手工裁剪的 Lua 程序与 POSIX C 库，满足对资源敏感的嵌入式设备部署需求。

---

## 🔧 功能特性

- 提供三种构建选项：
  - `ubuntu:latest`：功能最全，适合开发与测试
  - `alpine:latest`：紧凑 POSIX 环境，可验证兼容性
  - `alpine.slim`：构建后的最小纯 Lua 镜像，用于封装或嵌入部署
- 自动安装最新 **Lua**
- 可选安装 **LuaRocks**（Ubuntu/Alpine）
- 启动时输出版本信息、模块、路径等
- 默认工作目录 `/app`，方便挂载项目
- 启动脚本支持终端居中、彩色输出（含 `tput`）

---

## 🚀 快速开始

### 1. 构建镜像

```bash
# Ubuntu
docker build -t my-lua-dev -f Dockerfile .

# Alpine
docker build -t my-lua-dev-alpine -f Dockerfile.alpine .

# Alpine Slim
docker build -t my-lua-dev-slim -f Dockerfile.alpine.slim .
```

---

### 2. 运行容器

```bash
# Ubuntu
docker run -it --rm my-lua-dev

# Alpine
docker run -it --rm my-lua-dev-alpine

# Slim
docker run -it --rm my-lua-dev-slim
```

---

## 📁 项目挂载建议

将本地项目挂载至 `/app`，容器启动后默认进入：

```bash
# Ubuntu 版本
docker run -it --rm -v $(pwd):/app my-lua-dev

# Alpine 版本
docker run -it --rm -v $(pwd):/app my-lua-dev-alpine

# Alpine Slim 版本
docker run -it --rm -v $(pwd):/app my-lua-dev-slim
```

---

## 📜 启动脚本行为

默认执行 `/usr/local/bin/start-lua`，脚本行为因镜像而异：

- Ubuntu 与 Alpine 版本：
  - 使用 bash 执行
  - 输出 Lua 与 LuaRocks 版本、模块列表、包路径
  - 启动交互式 bash shell

- Alpine Slim 版本：
  - 使用 sh 执行
  - 输出 Lua 版本与路径（无 LuaRocks）
  - 启动极简 `/bin/sh` 终端

---

## 🧩 可扩展建议

- 预装常用模块（如 luasocket、luasec）
- 添加 CI 支持或交叉编译工具链
- 使用 Alpine Slim 镜像构建定制 Lua 程序（如单文件发布）

---

## 🏷️ 镜像构建对照表

| 版本         | 构建文件               | 镜像标签            | 特点                         |
|--------------|------------------------|---------------------|------------------------------|
| Ubuntu       | `Dockerfile`           | `my-lua-dev`        | 全功能 Lua 开发环境         |
| Alpine       | `Dockerfile.alpine`    | `my-lua-dev-alpine` | POSIX 精简 Lua 环境         |
| Alpine Slim  | `Dockerfile.alpine.slim`| `my-lua-dev-slim`  | 极简纯 Lua 运行环境（嵌入式）|

---

## 📦 后续方向（建议）

- 构建静态链接的 Lua VM
- 手工集成所需 POSIX C 库
- 实现仅需 `/bin/sh + lua` 的裸运行时
- 构建跨架构（如 armv7, mips）嵌入式支持版本

---

## 📆 License

自由使用、修改与分享，无限制。
