#!/bin/bash
set -e

# 项目根目录
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_DIR"

# 删除旧的 build 目录（彻底清理）
rm -rf build
mkdir build
cd build

# 配置 CMake（使用 Ninja）
cmake .. -G Ninja -DCMAKE_BUILD_TYPE=Debug -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
# 编译
ninja

echo "✅ 构建完成！输出文件在 build/ 目录下"
