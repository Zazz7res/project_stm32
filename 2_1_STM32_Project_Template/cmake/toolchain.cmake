set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR cortex-m3)

# 使用绝对路径指定编译器（根据你的 which 输出）
set(CMAKE_C_COMPILER /home/mini-harry/tools/arm-gnu-toolchain-15.2/bin/arm-none-eabi-gcc)
set(CMAKE_CXX_COMPILER /home/mini-harry/tools/arm-gnu-toolchain-15.2/bin/arm-none-eabi-g++)
set(CMAKE_ASM_COMPILER /home/mini-harry/tools/arm-gnu-toolchain-15.2/bin/arm-none-eabi-gcc)
set(CMAKE_OBJCOPY /home/mini-harry/tools/arm-gnu-toolchain-15.2/bin/arm-none-eabi-objcopy)
set(CMAKE_SIZE /home/mini-harry/tools/arm-gnu-toolchain-15.2/bin/arm-none-eabi-size)

# 避免 CMake 尝试链接可执行文件进行检测
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

set(COMMON_FLAGS "-mcpu=cortex-m3 -mthumb -mfloat-abi=soft -ffunction-sections -fdata-sections -g")
set(CMAKE_C_FLAGS "${COMMON_FLAGS} -std=gnu11 -Wall" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS "${COMMON_FLAGS} -std=gnu++14 -Wall" CACHE STRING "" FORCE)
set(CMAKE_ASM_FLAGS "${COMMON_FLAGS} -x assembler-with-cpp" CACHE STRING "" FORCE)
set(CMAKE_EXE_LINKER_FLAGS "-Wl,--gc-sections -Wl,-Map=${PROJECT_NAME}.map" CACHE STRING "" FORCE)

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
