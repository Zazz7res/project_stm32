/* STM32F103C8T6 链接脚本 - 64K Flash, 20K RAM */

MEMORY
{
    FLASH (rx)  : ORIGIN = 0x08000000, LENGTH = 64K
    RAM   (xrw) : ORIGIN = 0x20000000, LENGTH = 20K
}

/* 入口点 */
ENTRY(Reset_Handler)

/* 栈顶地址（RAM 末尾） */
_estack = ORIGIN(RAM) + LENGTH(RAM);

SECTIONS
{
    /* 中断向量表 */
    .isr_vector :
    {
        . = ALIGN(4);
        KEEP(*(.isr_vector))
        . = ALIGN(4);
    } > FLASH

    /* 代码段 */
    .text :
    {
        . = ALIGN(4);
        *(.text)
        *(.text*)
        *(.glue_7)
        *(.glue_7t)
        *(.eh_frame)

        KEEP(*(.init))
        KEEP(*(.fini))

        . = ALIGN(4);
        _etext = .;
    } > FLASH

    /* 只读数据 */
    .rodata :
    {
        . = ALIGN(4);
        *(.rodata)
        *(.rodata*)
        . = ALIGN(4);
    } > FLASH

    /* 初始化数据段（在 Flash 中存储初始值） */
    _sidata = LOADADDR(.data);
    .data : 
    {
        . = ALIGN(4);
        _sdata = .;        /* 数据段起始地址（RAM 中） */
        *(.data)
        *(.data*)
        . = ALIGN(4);
        _edata = .;        /* 数据段结束地址（RAM 中） */
    } > RAM AT > FLASH

    /* 未初始化数据段 */
    .bss :
    {
        . = ALIGN(4);
        _sbss = .;
        *(.bss)
        *(.bss*)
        *(COMMON)
        . = ALIGN(4);
        _ebss = .;
    } > RAM

    /* 堆（可选） */
    .heap :
    {
        . = ALIGN(8);
        _sheap = .;
        . = . + 0x400;     /* 1KB 堆 */
        _eheap = .;
    } > RAM

    /* 栈（已由启动文件设置） */
    .stack :
    {
        . = ALIGN(8);
        _sstack = .;
        . = . + 0x400;     /* 1KB 栈 */
        . = ALIGN(8);
        _estack = .;
    } > RAM
}
