# 🐉 Lua Development Environment (Ubuntu & Alpine based)

这是一个轻量级的 Lua 开发容器项目，提供两个基础镜像版本（Ubuntu 与 Alpine），自动构建并配置最新版本的 Lua 和 LuaRocks，适合本地开发、教学演示、模块测试等用途。

---

## 🔧 功能特性

- 提供两个可选构建版本：
  - `ubuntu:latest`（功能完整，适合通用开发）
  - `alpine:latest`（镜像极小，适合轻量场景）
- 自动安装最新版本 **Lua**
- 自动安装对应版本的 **LuaRocks**
- 自动配置头文件支持（便于编译 Lua 扩展）
- 启动时美观展示版本信息、模块列表、包路径等
- 默认进入 `/app` 目录，适合挂载项目

---

## 🚀 快速开始

### 1. 构建镜像

#### Ubuntu 版本：

```bash
docker build -t my-lua-dev -f Dockerfile .
```

#### Alpine 版本：

```bash
docker build -t my-lua-dev-alpine -f Dockerfile.alpine .
```

---

### 2. 运行容器

#### Ubuntu 版：

```bash
docker run -it --rm my-lua-dev
```

#### Alpine 版：

```bash
docker run -it --rm my-lua-dev-alpine
```

启动后将自动显示 Lua 环境信息，并进入交互式终端。

---

## 📁 项目目录结构建议

推荐将宿主机的 Lua 项目源文件挂载至 `/app`，容器运行后默认进入此目录：

```bash
docker run -it --rm -v $(pwd):/app my-lua-dev
# 或
docker run -it --rm -v $(pwd):/app my-lua-dev-alpine
```

---

## 📜 启动脚本行为

容器默认执行 `/usr/local/bin/start-lua`，执行行为：

- 清屏并居中打印欢迎信息
- 输出环境信息：
  - Lua 版本
  - LuaRocks 版本
  - 已安装的 LuaRocks 模块
  - `package.path` 与 `package.cpath`
- 最后附带进入 Bash 交互终端，位于 `/app`

---

## 🧹 可扩展建议

- 可在 Dockerfile 中预装常用 Lua 模块（如 `luasocket`, `luasec`, `busted` 等）
- 自定义启动脚本（比如改为执行某个 Lua 文件）
- 可用于 CI 测试 Lua 模块编译与运行环境

---

## 🏷️ 标签建议（构建产物）

| 版本       | 构建文件           | 镜像标签             |
|------------|--------------------|----------------------|
| Ubuntu     | `Dockerfile`       | `my-lua-dev`         |
| Alpine     | `Dockerfile.alpine`| `my-lua-dev-alpine`  |

---

## 📆 License

自由使用与修改，无限制。
