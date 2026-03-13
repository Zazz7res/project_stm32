操作stm32的GPIO总共需要三个步骤

1. 使用RCC开启是GPIO始终

2. 使用GPIO_Init函数初始化GPIO

3. 使用输出或者输入的函数控制GPIO口 

总之  这里涉及 RCC 和 GPIO 两个外设



stm32f10x_rcc.h 中  大多数函数是用不到的

但是会常用到这三个函数

```c
# RCC_AHB 外设时钟控制
void RCC_AHBPeriphClockCmd(uint32_t RCC_AHBPeriph, FunctionalState NewState);
# RCC_APB2 外设时钟控制
void RCC_APB2PeriphClockCmd(uint32_t RCC_APB2Periph, FunctionalState NewState);
# RCC_APB1 外设时钟控制
void RCC_APB1PeriphClockCmd(uint32_t RCC_APB1Periph, FunctionalState NewState);
```





stm32f10x_gpio.h### 第一部分：基础初始化与读写（最常用）

### 1. `void GPIO_DeInit(GPIO_TypeDef* GPIOx);`

- **作用：** **复位 GPIO 端口寄存器**。
- **解释：** 把指定端口（如 GPIOA、GPIOB）的所有配置寄存器恢复到默认状态（相当于恢复出厂设置）。
- **用途：** 通常在初始化函数的最开始调用，确保之前的配置不会干扰现在的设置，避免“脏数据”。

### 2. `void GPIO_AFIODeInit(void);`

- **作用：** **复位 AFIO 寄存器**。
- **解释：** 把复用功能 I/O（AFIO）的寄存器恢复到默认状态。
- **用途：** 很少用到。除非你动态切换了引脚复用功能，需要清除之前的重映射或中断配置时才用。

### 3. `void GPIO_Init(GPIO_TypeDef* GPIOx, GPIO_InitTypeDef* GPIO_InitStruct);`

- **作用：** **初始化 GPIO 引脚**。
- **解释：** **这是最重要的函数**。它根据结构体里的设置，配置引脚的模式（输入/输出/复用）、速度（10M/50M 等）和上下拉电阻。
- **用途：** 几乎所有 GPIO 使用场景都要调用它，比如配置 LED 为输出，配置按键为输入。

### 4. `void GPIO_StructInit(GPIO_InitTypeDef* GPIO_InitStruct);`

- **作用：** **填充结构体默认值**。
- **解释：** 把配置结构体里的所有成员填上默认值（通常是浮空输入）。
- **用途：** 好习惯。在调用 `GPIO_Init` 之前先调用它，防止结构体里有随机垃圾值导致配置错误。

### 5. `uint8_t GPIO_ReadInputDataBit(GPIO_TypeDef* GPIOx, uint16_t GPIO_Pin);`

- **作用：** **读取单个引脚电平**。
- **解释：** 读取指定引脚当前的物理电平状态，返回 0（低电平）或 1（高电平）。
- **用途：** 读取按键是否按下、传感器信号高低。

### 6. `uint16_t GPIO_ReadInputData(GPIO_TypeDef* GPIOx);`

- **作用：** **读取整个端口输入数据**。
- **解释：** 一次性读取该端口所有 16 个引脚的电平状态，返回一个 16 位的数据。
- **用途：** 同时读取多个引脚状态，比如读取并行数据总线。

### 7. `uint8_t GPIO_ReadOutputDataBit(GPIO_TypeDef* GPIOx, uint16_t GPIO_Pin);`

- **作用：** **读取输出寄存器位**。
- **解释：** 读取 CPU 写给该引脚的输出值（而不是物理引脚的实际电平）。
- **用途：** 确认程序里设定的输出状态是什么，常用于调试。

### 8. `uint16_t GPIO_ReadOutputData(GPIO_TypeDef* GPIOx);`

- **作用：** **读取整个端口输出数据**。
- **解释：** 一次性读取该端口所有 16 个引脚的输出寄存器值。
- **用途：** 确认整个端口的软件输出状态。

### 9. `void GPIO_SetBits(GPIO_TypeDef* GPIOx, uint16_t GPIO_Pin);`

- **作用：** **置位（输出高电平）**。
- **解释：** 将指定引脚设置为高电平（1）。这是一个原子操作，不会影响同一端口的其他引脚。
- **用途：** 点亮 LED、发送高电平信号。

### 10. `void GPIO_ResetBits(GPIO_TypeDef* GPIOx, uint16_t GPIO_Pin);`

- **作用：** **复位（输出低电平）**。
- **解释：** 将指定引脚设置为低电平（0）。这也是原子操作。
- **用途：** 熄灭 LED、发送低电平信号。

### 11. `void GPIO_WriteBit(GPIO_TypeDef* GPIOx, uint16_t GPIO_Pin, BitAction BitVal);`

- **作用：** **写入单个位值**。
- **解释：** 根据传入的参数（`Bit_SET` 或 `Bit_RESET`），将引脚设为高或低。
- **用途：** `SetBits` 和 `ResetBits` 的合体版，方便根据变量控制电平。

### 12. `void GPIO_Write(GPIO_TypeDef* GPIOx, uint16_t PortVal);`

- **作用：** **写入整个端口数据**。
- **解释：** 直接向端口的输出数据寄存器写入一个 16 位的值，一次性控制所有引脚。
- **用途：** 控制并行总线、数码管段选等需要同时改变多个引脚的场景。

---

### 第二部分：高级配置（之前解释过的，原样输出）

### 13. `GPIO_PinLockConfig`

- **作用：** **锁定引脚配置**。
- **解释：** 一旦你调用这个函数锁定了某个引脚，该引脚的配置寄存器（模式、速度、上下拉等）就被“冻结”了。在下次芯片复位（Reset）之前，任何代码都无法再修改这个引脚的配置。
- **用途：** 防止程序跑飞或者误操作导致关键引脚（如系统时钟引脚、调试引脚）被意外修改，提高系统安全性。

### 14. `GPIO_EventOutputConfig`

- **作用：** **配置事件输出源**。
- **解释：** STM32 内部有一个“事件输出”功能，可以把某个 GPIO 引脚的状态变化输出到一个特定的引脚上（通常是 PE0）。这个函数用来选择**哪个端口的哪个引脚**作为事件源。
- **用途：** 主要用于**调试**。比如你想观察某个引脚的电平变化时序，可以用示波器测这个事件输出引脚。

### 15. `GPIO_EventOutputCmd`

- **作用：** **使能或禁用事件输出**。
- **解释：** 配合上一个函数使用。配置好源之后，用这个函数来打开（Enable）或关闭（Disable）事件输出功能。
- **用途：** 相当于事件输出功能的“开关”。

### 16. `GPIO_PinRemapConfig`

- **作用：** **引脚重映射**。
- **解释：** STM32 的某些外设（如串口 USART、SPI、I2C、JTAG 等）默认固定在特定的引脚上。这个函数允许你把它们**换到别的引脚**上去。
  - *例如：* 默认 USART1 的 TX 在 PA9，通过重映射可以把它换到 PB6。
- **注意：** 使用此函数前，必须开启 **AFIO 时钟** (`RCC_APB2PeriphClockCmd(RCC_APB2Periph_AFIO, ENABLE)`).
- **用途：** 当默认引脚被占用，或者 PCB 布线需要时，非常有用。

### 17. `GPIO_EXTILineConfig`

- **作用：** **配置外部中断线映射**。
- **解释：** STM32 的外部中断线（EXTI0 ~ EXTI15）是固定的，但每个中断线可以连接不同端口的同编号引脚。这个函数用来指定**哪个端口的引脚**连接到**哪个中断线**。
  - *例如：* 把 PA5 连接到 EXTI5 中断线，或者把 PB5 连接到 EXTI5 中断线（同一时间只能选一个）。
- **注意：** 同样需要开启 **AFIO 时钟**。
- **用途：** 配置外部中断触发源（比如按键中断）时必须配置这一步。

### 18. `GPIO_ETH_MediaInterfaceConfig`

- **作用：** **配置以太网媒体接口**。
- **解释：** 如果你的手机板带以太网功能（如 STM32F107, F4, F7 等），这个函数用来选择以太网 MAC 使用哪种物理接口标准：**MII** 还是 **RMII**。
- **用途：** 仅在带有以太网外设的芯片上使用，普通 GPIO 操作不需要关心。







gpio八种工作模式的参数



就是gpio 结构体内的变量参数

先定义结构体   然后在给下面的函数赋值，第二个函数就是下面列表需要赋值的了

```c
    GPIO_Init(GPIOA, GPIO_InitTypeDef *GPIO_InitStruct);
```



```c
typedef enum
{ GPIO_Mode_AIN = 0x0,
  GPIO_Mode_IN_FLOATING = 0x04,
  GPIO_Mode_IPD = 0x28,
  GPIO_Mode_IPU = 0x48,
  GPIO_Mode_Out_OD = 0x14,
  GPIO_Mode_Out_PP = 0x10,
  GPIO_Mode_AF_OD = 0x1C,
  GPIO_Mode_AF_PP = 0x18
}GPIOMode_TypeDef;

```



第一部分：输入模式（4 种）

1. GPIO_Mode_AIN (Analog Input)
- 作用： 模拟输入。
- 解释： 关闭引脚上的数字电路（施密特触发器），只保留模拟电路。这样既省电，又能让外部电压信号直接进入 ADC 模块。
- 用途： ADC 采集电压、低功耗待机唤醒。如果你不用 ADC 也不输出，建议设为此模式以省电。
2. GPIO_Mode_IN_FLOATING (Floating Input)
- 作用： 浮空输入。
- 解释： 引脚内部既不上拉也不下拉，电平完全由外部电路决定。如果外部悬空，读到的电平是不确定的（随机跳变）。
- 用途： I2C 数据线（外部有上拉电阻时）、按键（外部有上下拉电路时）、标准串口 RX（某些情况）。
3. GPIO_Mode_IPD (Input Pull-Down)
- 作用： 下拉输入。
- 解释： 引脚内部连接了一个电阻到地（GND）。如果没有外部信号，引脚默认被拉到低电平（0）。
- 用途： 防止引脚悬空误触发。适用于外部信号默认是高电平，需要检测低电平有效的场景。
4. GPIO_Mode_IPU (Input Pull-Up)
- 作用： 上拉输入。
- 解释： 引脚内部连接了一个电阻到电源（VCC）。如果没有外部信号，引脚默认被拉到高电平（1）。
- 用途： 最常用的按键输入模式。按键一端接地，按下为 0，松开为 1（内部上拉）。

---

第二部分：输出模式（4 种）

5. GPIO_Mode_Out_OD (Output Open-Drain)
- 作用： 开漏输出。
- 解释： 引脚只能输出低电平（0）或高阻态（悬空）。无法直接输出高电平。要想输出高电平，必须在外部接一个上拉电阻。
- 用途： I2C 总线（SCL/SDA）、电平转换（连接 5V 设备）、“线与”逻辑（多个输出连在一起）。
6. GPIO_Mode_Out_PP (Output Push-Pull)
- 作用： 推挽输出。
- 解释： 引脚可以强力输出高电平（1）和低电平（0）。驱动能力强，速度快。
- 用途： 点亮 LED、驱动蜂鸣器、UART TX、SPI 引脚。这是最常用的输出模式。
7. GPIO_Mode_AF_OD (Alternate Function Open-Drain)
- 作用： 复用开漏输出。
- 解释： 引脚控制权交给内部外设（如 I2C），而不是 GPIO 寄存器。输出方式是开漏的（需外部上拉）。
- 用途： I2C 的 SCL 和 SDA 引脚。必须选这个模式，I2C 才能正常工作。
8. GPIO_Mode_AF_PP (Alternate Function Push-Pull)
- 作用： 复用推挽输出。
- 解释： 引脚控制权交给内部外设（如串口、SPI），输出方式是推挽的。
- 用途： UART 的 TX 引脚、SPI 的 MOSI/SCK 引脚、TIM 的 PWM 输出引脚。








