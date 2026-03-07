cmake_minimum_required(VERSION 3.20)
set(CMAKE_TOOLCHAIN_FILE ${CMAKE_SOURCE_DIR}/cmake/toolchain.cmake)
project(STM32F103C8T6 C CXX ASM)

# 芯片宏定义
add_definitions(-DSTM32F10X_MD)
add_definitions(-DUSE_STDPERIPH_DRIVER)

set(TARGET ${PROJECT_NAME}.elf)
add_executable(${TARGET})

target_link_options(${TARGET} PRIVATE -T ${CMAKE_SOURCE_DIR}/linker/STM32F103C8T6.ld)

target_include_directories(${TARGET} PRIVATE
    ${CMAKE_SOURCE_DIR}/config
    ${CMAKE_SOURCE_DIR}/include
    ${CMAKE_SOURCE_DIR}/drivers/CMSIS/CoreSupport
    ${CMAKE_SOURCE_DIR}/drivers/CMSIS/Device/ST/STM32F10x
    ${CMAKE_SOURCE_DIR}/drivers/STM32F10x_StdPeriph_Driver/inc
)

target_sources(${TARGET} PRIVATE
    ${CMAKE_SOURCE_DIR}/startup/startup_stm32f10x_md.s
    ${CMAKE_SOURCE_DIR}/drivers/CMSIS/Device/ST/STM32F10x/system_stm32f10x.c
    ${CMAKE_SOURCE_DIR}/drivers/STM32F10x_StdPeriph_Driver/src/misc.c
    ${CMAKE_SOURCE_DIR}/drivers/STM32F10x_StdPeriph_Driver/src/stm32f10x_rcc.c
    ${CMAKE_SOURCE_DIR}/drivers/STM32F10x_StdPeriph_Driver/src/stm32f10x_gpio.c
    ${CMAKE_SOURCE_DIR}/src/main.c
    ${CMAKE_SOURCE_DIR}/src/stm32f10x_it.c
    ${CMAKE_SOURCE_DIR}/drivers/bsp/bsp.c
    ${CMAKE_SOURCE_DIR}/src/app/task_led.c
    ${CMAKE_SOURCE_DIR}/src/utils/ringbuffer.c
)

add_custom_command(TARGET ${TARGET} POST_BUILD
    COMMAND ${CMAKE_OBJCOPY} -O ihex ${TARGET} ${PROJECT_NAME}.hex
    COMMAND ${CMAKE_OBJCOPY} -O binary ${TARGET} ${PROJECT_NAME}.bin
    COMMENT "Generating hex and bin files"
)
