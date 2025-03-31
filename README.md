# 🐉 Lua Development Environment (Ubuntu-based)

这是一个基于 Ubuntu 构建的轻量级 Lua 开发容器，自动安装最新版 Lua 和 LuaRocks，适合本地开发、教学演示、模块测试等用途。

---

## 🔧 功能特性

- 基于官方 `ubuntu:latest` 镜像
- 自动安装最新版 **Lua**
- 自动安装对应版本的 **LuaRocks**
- 自动配置头文件支持（便于编译 Lua 扩展）
- 启动时美观展示版本信息、模块列表、包路径等
- 默认进入 `/app` 目录，适合挂载项目

---

## 🚀 快速开始

### 1. 构建镜像

```bash
docker build -t my-lua-dev .
```

### 2. 运行容器

```bash
docker run -it --rm my-lua-dev
```

启动后将自动显示 Lua 环境信息，并进入交互式终端。

---

## 📦 启动脚本行为

容器默认执行 `/usr/local/bin/start-lua` 脚本，功能如下：

- 清屏并居中打印欢迎信息
- 输出：
  - Lua 版本
  - LuaRocks 版本
  - 已安装 LuaRocks 模块列表
  - Lua `package.path` 与 `package.cpath`
- 最后进入 `/app` 工作目录并附带 Bash 交互终端

---

## 🧩 可扩展建议

- 修改 Dockerfile 增加更多 Lua 模块（如 luasocket、luasec 等）
- 将宿主机代码挂载到 `/app` 进行实时开发：
  
  ```bash
  docker run -it --rm -v $(pwd):/app my-lua-dev
  ```

- 将 `start-lua` 替换为自定义启动脚本，支持参数或脚本执行

---

## 📁 目录结构建议

推荐将 Lua 项目源文件放入 `/app`，容器运行后默认进入此目录。

---

## 📜 License

自由使用与修改，无限制。
