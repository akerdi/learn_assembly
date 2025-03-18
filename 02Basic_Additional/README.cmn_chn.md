# Basic additional knowledge or code

## 例子1: 对比gcc 文件

编译:

    gcc -S add_a_b.c -O0 -masm=intel -o build/add_a_b.s

然后查看文件build/add_a_b.s 文件, 可以看到gcc 中传输超过6个参数后, 是怎么处理的.

## 例子2:

[查看示例](./arbitrary_sum_150.asm).

## 例子3: _add_a_b

[查看示例](./add_a_b.asm)

实现一个 _add_a_b 的方法, 调用时传入参数2 / 3. 这个程序了解程序stack 中增减的过程.

`_start:` 这个label 是我们的程序code 入口, 前两行code 将参数2和参数3分别rdi和rsi 这两个寄存器中, 此时程序stack 是没有变化的.

**rsp** 管理程序栈, 第三行`sub rsp, 16` 是将程序stack 减少16个字节, 并往其中填充rsi 和rdi 的值, 此时程序stack 是这样的:

> stack 在程序中是高地址往低地址执行FILO的操作, 此时sub 就相当于rsp地址往后移动16byte. 而后两句分别填充了8byte(64位)数据.

```
0000reverved space00000
rsp00000000000000000000

-> sub 和mov 操作后:
`sub rsp, 16`
0000reverved space00000
[2][3]rsp
```

**_start** 操作完数据后, 执行call 命令. call 实际上是有好几个操作:

- 将下一条待运行指令指针的地址压入栈中
- 当前指令指针(RIP)指向 _add_a_b后面的下一条指令
- 跳转到 _add_a_b 的地址开始执行
- `ret` 时, 拿到压入的栈地址, 并且jmp 回去. jmp成功后, 弹出地址数据(栈向上移动8byte)

是将下一条指令的地址(返回地址)压入栈中, 意味着stack 再度增加(地址减少8byte), 存储了地址:

```
`call _add_a_b`
0000reverved space00000
[2][3][0x40102d]rsp
```

下一步是执行`push rbx`, 该动作和pop rbx 是为了确保rbx 原有的值不会被污染, 所以先将其值保存至栈中, 最后pop 返回给rbx. 如此一来, 下方就可以轻松使用rbx 了. 因为执行了`push` 命令, 那么栈会再度增加(地址减少8byte)

```
`push rbx`
0000reverved space00000
[2][3][0x40102d][xx]rsp
```

`_add_a_b` 内部执行`pop rbx` rsp地址+8; `ret` rsp地址再+8:

```
`pop rbx`
0000reverved space00000
[2][3][0x40102d]rsp

`ret`
0000reverved space00000
[2][3]rsp
```

以上就是整个程序stack 栈的伸缩使用情况.

我们可以使用`gdb`来查看stack的使用情况:

编译:
    nasm  -f elf64 -g -F dwarf -o build/add_a_b add_a_b.asm
    ld -o build/add_a_b build/add_a_b.o

运行executable:
    gdb build/add_a_b
    # 设置断点
    b _start # break _start
    # 开始运行
    run
    # 查看普通寄存器
    info registers [$rcx] # 所有: info all-registers
    # 反汇编_start
    disas _start # 可以看到每行代码运行地址之后RIP 指向的地址
    disas _add_a_b # 同上, 也可以`disassemble _add_a_b`
    # 设置更新打印(如果是临时打印, 则`print /x $rsp` 或者 print /x *(long*)($rsp+8))
    display/i $rsp $rax $rbp $rdx $rip
    # 单步进入
    si # stepi
    # 单步跳过
    ni # nexti
    # 打印行号20 的内存地址信息
    info line 22 # 或者 info line *0x40102d

> 关于标记(label) 前面是否加`.`(如`.compare` 和`correctSum`): 当为全局函数时, 则不加点, 局部方法时, 则加点. 此时`.compare` 使用 `disas _start` 查看时, 会显示为 `<_start.compare>`, 而`correctSum` 使用 `disas _start` 查看时, 会显示为 `<correctSum>`.
