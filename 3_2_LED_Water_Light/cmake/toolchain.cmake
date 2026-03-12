set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR cortex-m3)

set(TOOLCHAIN_PATH "/home/mini-harry/tools/arm-gnu-toolchain-15.2/bin")
set(CMAKE_C_COMPILER      ${TOOLCHAIN_PATH}/arm-none-eabi-gcc)
set(CMAKE_CXX_COMPILER    ${TOOLCHAIN_PATH}/arm-none-eabi-g++)
set(CMAKE_ASM_COMPILER    ${TOOLCHAIN_PATH}/arm-none-eabi-gcc)
set(CMAKE_OBJCOPY         ${TOOLCHAIN_PATH}/arm-none-eabi-objcopy)
set(CMAKE_SIZE            ${TOOLCHAIN_PATH}/arm-none-eabi-size)

# ✅ 关键：裸机项目必须，让 CMake 测试只编译不链接
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

# ✅ 正确：只设置编译 flag，不设置链接 flag
set(COMMON_FLAGS "-mcpu=cortex-m3 -mthumb -mfloat-abi=soft -ffunction-sections -fdata-sections -g")
set(CMAKE_C_FLAGS   "${COMMON_FLAGS} -std=gnu11 -Wall" CACHE STRING "" FORCE)
set(CMAKE_CXX_FLAGS "${COMMON_FLAGS} -std=gnu++14 -Wall" CACHE STRING "" FORCE)
set(CMAKE_ASM_FLAGS "${COMMON_FLAGS} -x assembler-with-cpp" CACHE STRING "" FORCE)

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
