#!/bin/bash
# ==========================================================================
# 文件名：build.sh
# 作用：一键清理并编译项目 (集成 bear 生成 compile_commands.json)
# 位置：cmake_build/scripts/build.sh
# ==========================================================================

# 1. 安全设置
set -e  # 关键！如果任何命令失败，立即停止脚本
set -u  # 如果使用未定义变量，报错

# 2. 获取路径信息
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CMAKE_BUILD_DIR="$(dirname "$SCRIPT_DIR")"      # 即 cmake_build 目录
PROJECT_ROOT="$(dirname "$CMAKE_BUILD_DIR")"    # 即项目真正的根目录 (包含 src 和 cmake_build 的那一层)

# 3. 进入构建目录
cd "$CMAKE_BUILD_DIR"

# 4. 清理旧构建 (避免旧文件干扰，这对 bear 很重要，确保捕获所有命令)
echo "🧹 清理旧构建..."
rm -rf build
mkdir -p build
cd build

# 5. 配置 CMake
echo "⚙️ 配置 CMake..."
cmake .. \
    -DCMAKE_TOOLCHAIN_FILE=../toolchain-arm-none-eabi.cmake \
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
    -GNinja

# 6. 开始编译 (使用 bear 拦截编译命令)
echo "🔨 开始编译 (Bear 监听中...)..."
# 修改点：将 json 输出到 PROJECT_ROOT (项目根目录)，方便 Vim/LSP 自动识别
bear --output "$PROJECT_ROOT/compile_commands.json" -- ninja

# 7. 完成提示
echo "✅ 编译成功！"
echo "📦 输出文件：$CMAKE_BUILD_DIR/build/OLED_Display.bin"
echo "📄 索引文件：$PROJECT_ROOT/compile_commands.json"
