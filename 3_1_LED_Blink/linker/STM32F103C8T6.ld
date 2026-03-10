/* STM32F103C8T6 链接脚本 - 64K Flash, 20K RAM */

/* 入口点：复位中断服务函数 */
ENTRY(Reset_Handler)

/* 内存区域定义 */
MEMORY
{
    FLASH (rx)  : ORIGIN = 0x08000000, LENGTH = 64K
    RAM   (xrw) : ORIGIN = 0x20000000, LENGTH = 20K
}

/* 栈顶地址（RAM 末尾）- 启动文件需要这个符号 */
_estack = ORIGIN(RAM) + LENGTH(RAM);

/* 段（Sections）定义 */
SECTIONS
{
    /* 1. 中断向量表 - 必须放在 Flash 开头 */
    .isr_vector :
    {
        . = ALIGN(4);
        KEEP(*(.isr_vector))      /* 确保向量表不被优化掉 */
        . = ALIGN(4);
    } > FLASH

    /* 2. 程序代码和只读数据 */
    .text :
    {
        . = ALIGN(4);
        *(.text)                   /* 程序代码 */
        *(.text*)                  /* 程序代码（带后缀） */
        *(.glue_7)                 /* 用于 ARM-Thumb 交互 */
        *(.glue_7t)                /* 用于 ARM-Thumb 交互 */
        *(.eh_frame)               /* 异常处理帧（C++） */
        
        KEEP(*(.init))              /* 构造函数（C++） */
        KEEP(*(.fini))              /* 析构函数（C++） */
        
        . = ALIGN(4);
        _etext = .;                 /* 代码段结束地址 */
    } > FLASH

    /* 3. 只读数据（常量） */
    .rodata :
    {
        . = ALIGN(4);
        *(.rodata)                  /* 只读数据 */
        *(.rodata*)                 /* 只读数据（带后缀） */
        . = ALIGN(4);
    } > FLASH

    /* 4. 初始化数据（在 Flash 中存储初始值，运行时复制到 RAM） */
    _sidata = LOADADDR(.data);      /* 数据在 Flash 中的加载地址 */
    .data :
    {
        . = ALIGN(4);
        _sdata = .;                  /* RAM 中数据段起始地址 */
        *(.data)                     /* 已初始化数据 */
        *(.data*)                    /* 已初始化数据（带后缀） */
        . = ALIGN(4);
        _edata = .;                  /* RAM 中数据段结束地址 */
    } > RAM AT > FLASH

    /* 5. 未初始化数据（在 RAM 中，启动时清零） */
    .bss :
    {
        . = ALIGN(4);
        _sbss = .;                   /* BSS 段起始地址 */
        __bss_start__ = _sbss;       /* 兼容某些启动文件 */
        *(.bss)                      /* 未初始化数据 */
        *(.bss*)                     /* 未初始化数据（带后缀） */
        *(COMMON)                    /* 通用符号 */
        . = ALIGN(4);
        _ebss = .;                   /* BSS 段结束地址 */
        __bss_end__ = _ebss;         /* 兼容某些启动文件 */
    } > RAM

    /* 6. 堆（可选）- 如果使用 malloc 等动态内存分配 */
    .heap :
    {
        . = ALIGN(8);
        _sheap = .;                  /* 堆起始地址 */
        . = . + 0x400;               /* 1KB 堆 */
        . = ALIGN(8);
        _eheap = .;                  /* 堆结束地址 */
    } > RAM

    /* 7. 栈（由启动文件设置，这里只是占位标记） */
    .stack :
    {
        . = ALIGN(8);
        _sstack = .;                 /* 栈起始地址 */
        . = . + 0x400;               /* 1KB 栈（可根据需要调整） */
        . = ALIGN(8);
        _estack = .;                  /* 栈结束地址（会被前面的 _estack 覆盖） */
    } > RAM

    /* 8. 丢弃不需要的段 */
    /DISCARD/ :
    {
        libc.a ( * )                 /* 裸机环境下通常不需要标准库 */
        libm.a ( * )                 /* 数学库（如果需要可保留） */
        libgcc.a ( * )               /* GCC 辅助库 */
        *(.comment)                  /* 注释信息 */
        *(.note.gnu.build-id)        /* 构建 ID（可选保留） */
    }
}
