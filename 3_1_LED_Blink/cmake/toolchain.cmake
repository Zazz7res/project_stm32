# 目标系统 
set(CMAKE_SYSTEM_NAME Generic)

# 目标处理器架构
set(CMAKE_SYSTEM_PROCESSOR cortex-m3)

# 编译器配置（绝对路径方式）
set(TOOLCHAIN_PATH "/home/mini-harry/tools/arm-gnu-toolchain-15.2/bin")
set(CMAKE_C_COMPILER      ${TOOLCHAIN_PATH}/arm-none-eabi-gcc)
set(CMAKE_CXX_COMPILER    ${TOOLCHAIN_PATH}/arm-none-eabi-g++) set(CMAKE_ASM_COMPILER    ${TOOLCHAIN_PATH}/arm-none-eabi-gcc) set(CMAKE_OBJCOPY         ${TOOLCHAIN_PATH}/arm-none-eabi-objcopy) set(CMAKE_SIZE            ${TOOLCHAIN_PATH}/arm-none-eabi-size) # 避免 CMAKE 链接测试（裸机无 libc) set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

# 编译选项
set(COMMON_FLAGS "-mcpu=cortex-m3 -mthumb -mfloat-abi=soft -ffunction-sections -fdata-sections -g")
set(CMAKE_C_FLAGS   "${COMMON_FLAGS} -std=gnu11 -Wall" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS "${COMMON_FLAGS} -std=gnu++14 -Wall" CACHE STRING "" FORCE)
set(CMAKE_ASM_FLAGS "${COMMON_FLAGS} -x assembler-with-cpp" CACHE STRING "" FORCE)


# 链接选项
set(CMAKE_EXE_LINKER_FLAGS "-Wl,--gc-sections -Wl,-Map=${PROJECT_NAME}.map" CACHE STRING "" FORCE) 
 

# 查找策略（防止找到主机文件）
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
