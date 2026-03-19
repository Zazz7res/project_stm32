#!/bin/bash
# STM32 LED Blink 项目构建脚本

set -e  # 遇到错误立即退出

# 获取脚本所在目录和项目根目录
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "============================================"
echo "  STM32 LED Blink - Build Script"
echo "  Project: $(basename "$PROJECT_DIR")"
echo "  Time: $(date '+%Y-%m-%d %H:%M:%S')"
echo "============================================"
echo ""

# 1. 清理旧构建
echo "[1/5] 🧹 Cleaning build directory..."
rm -rf "$PROJECT_DIR/build"

# 2. 创建新构建目录
echo "[2/5] 📁 Creating build directory..."
mkdir -p "$PROJECT_DIR/build"
cd "$PROJECT_DIR/build"

# 3. 配置 CMake（生成 compile_commands.json）
echo "[3/5] ⚙️  Configuring CMake..."
cmake -G Ninja \
    -DCMAKE_TOOLCHAIN_FILE=../cmake/toolchain.cmake \
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
    -DCMAKE_BUILD_TYPE=Debug \
    ..

# 4. 编译
echo "[4/5] 🔨 Building..."
ninja

# 5. 创建符号链接（方便 VS Code 查找）
echo "[5/5] 🔗 Creating compile_commands.json symlink..."
ln -sf build/compile_commands.json "$PROJECT_DIR/compile_commands.json"

# 6. 显示结果
echo ""
echo "============================================"
echo "  ✅ Build Complete!"
echo "============================================"
echo "  📦 Output Files:"
ls -lh "$PROJECT_DIR/build"/*.elf "$PROJECT_DIR/build"/*.bin "$PROJECT_DIR/build"/*.hex 2>/dev/null || true
echo ""
echo "  📄 Compile DB: $PROJECT_DIR/compile_commands.json"
echo "  📍 Location: $(pwd)"
echo "============================================"
