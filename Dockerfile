# 使用最新 Ubuntu 作为基础镜像
FROM ubuntu:latest

# 1. 安装构建和运行 Lua 所需的依赖（不删除系统自带 Lua）
# 包括构建工具、开发头文件、证书等
RUN apt update && \
    apt install -y \
    curl \
    build-essential \
    libreadline-dev \
    unzip \
    pkg-config \
    ca-certificates

# 2. 设置构建 Lua 的工作目录
WORKDIR /usr/local/src

# 3. 自动获取并编译安装 Lua 最新稳定版本
RUN latest_version=$(curl -sL https://www.lua.org/ftp/ | \
    grep -o 'lua-[0-9]\+\.[0-9]\+\.[0-9]\+\.tar\.gz' | \
    sort -V | tail -n 1 | \
    sed 's/lua-\([0-9.]*\)\.tar\.gz/\1/') && \
    echo "Latest Lua version: $latest_version" && \
    curl -LO https://www.lua.org/ftp/lua-$latest_version.tar.gz && \
    tar zxf lua-$latest_version.tar.gz && \
    cd lua-$latest_version && \
    make linux test && \
    make install

# 4. 安装匹配 Lua 的最新版本 LuaRocks
RUN luarocks_version=$(curl -sL https://luarocks.org/releases/ | grep -o 'luarocks-[0-9.]*\.tar\.gz' | sort -V | tail -n 1 | sed 's/luarocks-//;s/.tar.gz//') && \
    echo "LuaRocks version: $luarocks_version" && \
    curl -LO https://luarocks.org/releases/luarocks-$luarocks_version.tar.gz && \
    tar xzf luarocks-$luarocks_version.tar.gz && \
    cd luarocks-$luarocks_version && \
    ./configure --with-lua=/usr/local && \
    make && make install

# 5. 清理构建中间产物，并创建实际使用的默认工作目录
RUN rm -rf /usr/local/src && mkdir -p /app
WORKDIR /app

# 6. 确保 Lua 的头文件能被系统识别（便于安装依赖扩展）
RUN ln -sf /usr/local/include/lua*.h /usr/include/

# 7. 创建默认启动脚本：打印 Lua 环境信息并进入交互终端
RUN bash -c 'cat > /usr/local/bin/start-lua' <<'EOF'
#!/bin/bash

clear

# 输出居中函数
CENTER() {
  term_width=$(tput cols)
  padding=$(( (term_width - ${#1}) / 2 ))
  printf "%*s%s\n" "$padding" "" "$1"
}

# 欢迎信息
echo -e "\033[1;36m"
CENTER "🐉 Welcome to Lua Development Environment"
echo -e "\033[0m"

echo ""
CENTER "🔹 Lua version:"
lua -v | while read line; do CENTER "$line"; done

echo ""
CENTER "🔹 LuaRocks version:"
luarocks --version | head -n 1 | while read line; do CENTER "$line"; done

echo ""
CENTER "🔹 Installed LuaRocks modules:"
luarocks list | while read line; do CENTER "$line"; done

echo ""
CENTER "🔹 Lua package.path:"
lua -e 'print(package.path)' | while read line; do CENTER "$line"; done

echo ""
CENTER "🔹 Lua package.cpath:"
lua -e 'print(package.cpath)' | while read line; do CENTER "$line"; done

# 提示准备完毕
echo -e "\033[1;32m"
CENTER "📦 Ready in /app"
echo -e "\033[0m"
echo ""

# 启动交互终端
exec bash
EOF

# 赋予启动脚本可执行权限
RUN chmod +x /usr/local/bin/start-lua

# 设置容器默认启动命令
CMD ["/usr/local/bin/start-lua"]
