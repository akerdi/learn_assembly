# 理解栈

这篇主要是理解一个例子，然后通过例子来理解栈。

在 x86-64 架构中，与栈操作相关的两个重要寄存器是 rsp 和 rbp：

1. rsp（Stack Pointer，栈顶指针）

- rsp 始终指向栈的顶部，即当前可用的最低地址位置。
- 栈的增长方向是从高地址向低地址扩展，因此当数据被压入栈时，rsp 的值会减小；当数据从栈中弹出时，rsp 的值会增加。

2. rbp（Base Pointer，基址指针）

- rbp 通常用于标记栈帧的底部（逻辑上的“栈底”），但实际上它指向的是一个固定位置，便于函数调用时访问局部变量和参数。
- 在函数调用过程中，rbp 的值一般不会改变，而 rsp 则会随着栈的操作动态调整。

3. 栈的方向性

- 栈是从高地址向低地址增长的。rbp 记录的是栈帧的逻辑底部（高地址），而 rsp 指向的是栈的实际顶部（低地址）。
- 当栈“增加”时，实际上是栈中存储的数据量增加，rsp 的值会向更低的地址移动。

=总结=

- rsp 是动态变化的，始终指向栈顶（低地址）。
- rbp 是静态的，用于标记栈帧的底部（高地址），便于函数调用时访问局部变量和参数。
- 栈的增长方向是从高地址向低地址，因此 rsp 的值随栈的增长而减小。

## 例子

这个例子通过输入两个参数, 对参数进行相加后打印结果值.

跳过定义初始数据部分, 直接看`_start`:

```asm
_start:
    pop rcx
    cmp rcx, 3
    jne .argcError

.argcError:
    mov rax, SYS_WRITE
    mov rdi, STD_IN
    mov rsi, WRONG_ARGC
    mov rdx, 35
    syscall

    jmp .exit

.exit:
    mov rax, SYS_EXIT
    mov rdi, EXIT_CODE
    syscall
```

> cmp 是判别指令, 结果储存在`ZF`中, `jne`是跳转指令, 如果`ZF`为0, 则跳转; 否则继续往下执行.

程序启动运行时, 栈顶位置记录的是参数个数, 所以`pop rcx`将参数个数弹出到`rcx`中, 然后比较`rcx`是否等于3, 不等于则输出错误信息, 然后退出程序.

比如执行时`./main 1 2`, 则栈内容如:

```
(gdb) b _start
(gdb) run 1 2
(gdb) x/4gx $rsp # 通过栈顶位置查看4个8字节(hex)
0x7fffffffd810: 0x0000000000000003      0x00007fffffffdb4a
0x7fffffffd820: 0x00007fffffffdb93      0x00007fffffffdb95
```

第一个很清楚, 他是整数, 就是3, 然后是程序运行字符串指针, 打印他: `x/s 0x00007fffffffdb4a` 结果为`xxxx/main`.

后面两个是参数字符串, 也可以打印出来.

所以首先执行pop rcx, 从栈中拿出参数个数, 不为3, 则打印错误后结束任务!

接下来我们跳过调用程序的字符串`add rsp, 8`后, 将参数argv[1] 和argv[2] 这两个字符串解析成数字分别保存到r10 和r11 寄存器中:

```asm
_start:
    ...

    add rsp, 8      ; 跳过调用程序的字符串

    pop rsi         ; argv[1]
    call .str_to_int;
    mov r10, rax
```

`jmp` 单纯就是跳转至指定的地址, 不会压栈.

`call` 用于调用子程序(函数); 在跳转到目标地址之前, 会将当前指令的下一条指令地址压入栈中; 当子程序执行完毕后, 通过ret 返回地址, 通过找到压栈的地址后, 继续执行源程序.

```asm
(gdb) disas _start
0x0000000000401000 <+0>:     pop    %rcx
0x0000000000401001 <+1>:     cmp    $0x3,%rcx
0x0000000000401005 <+5>:     jne    0x40108c <_start.argcError>
0x000000000040100b <+11>:    add    $0x8,%rsp
0x000000000040100f <+15>:    pop    %rsi
0x0000000000401010 <+16>:    callq  0x40102c <_start.str_to_int>
0x0000000000401015 <+21>:    mov    %rax,%r10
0x0000000000401018 <+24>:    pop    %rsi
0x0000000000401019 <+25>:    callq  0x40102c <_start.str_to_int>
0x000000000040101e <+30>:    mov    %rax,%r11
0x0000000000401021 <+33>:    add    %r11,%r10
0x0000000000401024 <+36>:    mov    %r10,%rax
0x0000000000401027 <+39>:    xor    %r12,%r12
0x000000000040102a <+42>:    jmp    0x40104a <_start.int_to_str>
```

看到`0x401010 <+16>:    callq  0x40102c <_start.str_to_int>` 下一行地址为`0x401015`. 当通过`si` 进入call 的子程序后, 通过`x/1gx $rsp` 看到地址`0x401015`就在其中.

### 实现字符串转数字

通过读取字符后, 对字符相减'0' 得到数字.

```asm
.int_to_str:
    mov rax, 0
    mov rcx, 10
.next:
    cmp [rsi], byte 0
    je .return_str
    mov bl, [rsi]           ;|245 -> '2'      |'45' -> bl = '4' |'5' -> bl = '5'    |
    sub bl, '0'             ;|'2' - 48 = 2    |'4' -> bl = 4    |'5' -> bl = 5      |
    mul rcx                 ;|rax = 0 * 10 = 0|rax = 2 * 10 = 20|rax = 24 * 10 = 240|
    add rax, rbx            ;|rax = 0 + 2 = 2 |rax = 20 + 4 = 24|rax = 240 + 5 = 245
    inc rsi                 ;|rsi++ -> '45'   |rsi++ -> '5'     |rsi++ -> 0         |
    jmp .next
.return_str:
    ret
```

代码有注释, 假设输入"245", 那么一列顺序就是对应的执行过程. ret 执行时, 之前压栈地址`0x401015`用于跳转回去的路标.

```asm
_start:
    ...

    add r10, r11
    mov rax, r10
    call .int_to_str
.int_to_str:
    mov rdx, 0      ; rdx 保存余数, rax既是被除数也是商
    mov rbx, 10     ; rbx 为除数
    div rbx         ; rax / rbx -> 245 / 10 -> rax = 24, rdx = 5
    add rbx, '0'    ; 还原数字字符
    push rbx        ; 把这个8byte存到栈里
    inc r12         ; r12 为计数器, 每次加1
    cmp rax, 0      ; 如果被除数不为0, 则继续除
    je .print_str
    jmp .int_to_str
.print_str:
    mov rax, 1
    mul r12         ; rax = rax * r12, 如果r12为3, 则1*3 = 3
    mov r12, 8      ; 当前栈当中保存的一个字符占8byte
    mul r12         ; rax = rax * r12, 如果r12为8, 则3*8 = 24bit

    mov rdx, rax    ; 将打印长度记录rax(如24)保存至rdx中, 等会syscall 用到
    mov rax, 1
    mov rdi, 1
    mov rsi, rsp    ; 将栈指针赋给rsi用于打印
    syscall

    .exit
```

以上是对数字处理为字符串的过程. 这里注意`div rbx` 结果存在rax中, 被除数是rax, 除数是rbx, 并且将余数保存在rdx中.