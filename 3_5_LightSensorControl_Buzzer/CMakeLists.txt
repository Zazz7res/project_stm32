cmake_minimum_required(VERSION 3.16)
set(CMAKE_TOOLCHAIN_FILE ${CMAKE_SOURCE_DIR}/cmake/toolchain.cmake)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
project(STM32F103C8T6 C CXX ASM)

add_definitions(-DSTM32F10X_MD -DUSE_STDPERIPH_DRIVER)

add_executable(${PROJECT_NAME}.elf
    ${CMAKE_SOURCE_DIR}/startup/startup_stm32f10x_md.s
    ${CMAKE_SOURCE_DIR}/drivers/CMSIS/Device/ST/STM32F10x/system_stm32f10x.c
    ${CMAKE_SOURCE_DIR}/drivers/STM32F10x_StdPeriph_Driver/src/misc.c
    ${CMAKE_SOURCE_DIR}/drivers/STM32F10x_StdPeriph_Driver/src/stm32f10x_rcc.c
    ${CMAKE_SOURCE_DIR}/drivers/STM32F10x_StdPeriph_Driver/src/stm32f10x_gpio.c
    ${CMAKE_SOURCE_DIR}/src/main.c
    ${CMAKE_SOURCE_DIR}/src/stm32f10x_it.c
    ${CMAKE_SOURCE_DIR}/src/utils/Delay.c
    ${CMAKE_SOURCE_DIR}/src/hardware/LED.c
    ${CMAKE_SOURCE_DIR}/src/hardware/Key.c
)

# ✅ 正确：局部头文件路径，只影响当前目标
target_include_directories(${PROJECT_NAME}.elf PRIVATE
    ${CMAKE_SOURCE_DIR}/config
    ${CMAKE_SOURCE_DIR}/include
    ${CMAKE_SOURCE_DIR}/drivers/CMSIS/CoreSupport
    ${CMAKE_SOURCE_DIR}/drivers/CMSIS/Device/ST/STM32F10x
    ${CMAKE_SOURCE_DIR}/drivers/STM32F10x_StdPeriph_Driver/inc
    ${CMAKE_SOURCE_DIR}/src/hardware
)

# ✅ 正确：局部编译选项
target_compile_options(${PROJECT_NAME}.elf PRIVATE
    -Wall
    -ffunction-sections
    -fdata-sections
)

# ✅ 正确：局部链接选项（链接脚本、Map 文件放这里）
target_link_options(${PROJECT_NAME}.elf PRIVATE
    -T ${CMAKE_SOURCE_DIR}/linker/STM32F103C8T6.ld
    -Wl,--gc-sections
    -Wl,-Map=${PROJECT_NAME}.map
)

# 生成 hex/bin
add_custom_command(TARGET ${PROJECT_NAME}.elf POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} -O ihex ${PROJECT_NAME}.elf ${PROJECT_NAME}.hex
    COMMAND ${CMAKE_OBJCOPY} -O binary ${PROJECT_NAME}.elf ${PROJECT_NAME}.bin
)
