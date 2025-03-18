# 操作栈

这篇同样是跟着一个例子来分析栈的执行过程, 更有深度的理解栈.

## 例子

这个例子通过将一个字符串逆向翻转, 来展示栈的使用.

首先跳过程序定义数据, 直接来看实现代码:

```asm
_start:
    mov rsi, INPUT
    xor rcx, rcx
    cld
    mov rdi, $+15
    call calculateStrLength
    xor rax, rax
    xor rdi, rdi
    jmp reverseStr
```

以上我们将字符串放到rsi中, 然后设置rcx 为0, 然后通过调用cld 来设置flag df = 0, 这样指令(如 `lodsb` `stosb` `movsb` 等)读取字符串会从左到右读取.

接下来执行`calculateStrLength` 计算字符串长度, 之后跳转到reverseStr方法中. 以上忽略`mov rdi, $+15`, 我们后面来说明.

```asm
calculateStrLength:
    cmp byte [rsi], 0
    je .exitFromRoutine
    lodsb               ; load next byte from rsi into al, and inc rsi
    push rax
    inc rcx
    jmp calculateStrLength
```

这一段一开始判别是否当前rsi指针的字符为0, 如果是则结束这个子程序, 否则: lodsb 从rsi拿出一个byte 后到al, 并且rsi++. 将刚得到的al 推到栈中`push rax`, 将rcx加1, 然后跳转到`calculateStrLength`继续执行.

以上rcx 得到字符串长度, 并且栈(FILO)中保存了字符串.

得到结果后, 我们调到.exitFromRoutine 来执行ret 回到_start函数中, 如:

```asm
.exitFromRoutine:
    ; return to _start
    ret
```

但是以上这样是无法运作的! 为什么? 之前我们知道`call calculateStrLength`时会把下一个调用地址存在栈中, 这样ret 时就能找到返回的执行地址. 但是我们在calculateStrLength 方法中将字符串拆成每个字符存在栈中, 这样地址就被覆盖了, ret 时找不到跳转的地址: `Segmentation fault (core dumped)`.

这时我们该怎么做? 还记得之前那个奇怪的方法`mov rdi, $+15` 吗? 他的作用是将当前地址+15后传给rdi, 也就是rdi 得到当前位置偏移15的地址. 为什么要偏移15呢?

```sh
$ objdump -D build/main
build/main:     file format elf64-x86-64
Disassembly of section .text:
0000000000401000 <_start>:
401000:       48 be 01 20 40 00 00    movabs $0x402001,%rsi
401007:       00 00 00
40100a:       48 31 c9                xor    %rcx,%rcx
40100d:       fc                      cld
40100e:       48 bf 1d 10 40 00 00    movabs $0x40101d,%rdi
401015:       00 00 00
401018:       e8 08 00 00 00          call   401025 <calculateStrLength>
40101d:       48 31 c0                xor    %rax,%rax
401020:       48 31 ff                xor    %rdi,%rdi
401023:       eb 0d                   jmp    401032 <reverseStr>
```

上面可以看到 0x40100e 是执行时的地址, 下一步希望执行的地址是 0x40101d. 0x40101d - 0x40100e 正是15, 所以我们执行了 $+15 来得到地址 0x40101d, 然后将他发给rdi保存. 那是不是说, 我把rdi 放到栈上, 然后执行ret, 不就回去了? 是的:

```asm
.exitFromRoutine:
    ; 将返回地址再次放回栈上
    push rdi
    ; 返回到_start
    ret
```

现在我们已经回到_start了, 以上操作请参考[main01.asm 文件](./main01.asm).

现在处理翻转字符串方法:

```asm
_start:
    ...
    call calculateStrLength

    ; 置空rax 和rdi
    xor rax, rax
    xor rdi, rdi
    jmp reverseStr

reverseStr:
    cmp rcx, 0
    je printResult
    pop rax
    mov [OUTPUT+rdi], rax
    dec rcx
    inc rdi
    jmp reverseStr
```

这里将rax和rdi置空为后面使用. 接着就是将栈中8byte数据pop 到rax中, 然后将rax中的1byte 放到.bss 中. 接下来就是简单的打印:

```asm
printResult:
    mov rdx, rdi
    mov rax, SYS_WRITE
    mov rdi, STD_OUT
    mov rsi, OUTPUT
    syscall
    jmp printNewLine

printNewLine:
    mov rax, SYS_WRITE
    mov rdi, STD_OUT
    mov rsi, NEW_LINE
    mov rdx, 1
    syscall

    jmp exit

exit:
    mov rax, SYS_EXIT
    mov rdi, EXIT_CODE
    syscall
```

查看所有OUTPUT内容:

```bash
$gdb ./build/main
(gdb) b _start
(gdb) r
(gdb) info variables
(gdb) x/12bx OUTPUT
```