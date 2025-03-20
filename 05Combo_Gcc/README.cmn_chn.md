# C/C++ 加载Assembly

一个**Object文件**(.0), 包含有机器码或者字节码, 同时也包含其他数据和元数据等信息. 他通常是由编译器或者汇编的方式从源代码生成.

从.asm 生成.o 文件, 和从.c 生成.o 文件, 生成的文件格式一样, 那就以为着可以通用.

## C 调用Assembly的方法

```c
#include <stdio.h>
int main() {
    char* str = "Hello World";
    int len = strlen(str);
    printHelloWorld(str, len);
    return 0;
}
```

我们之前知道传递参数<= 6个时, 参数分别是放在rdi, rsi, rdx, rcx, r8, r9, 剩下的参数放在栈上. 由此, 上边传递的两个参数, 放在rdi, rsi中.


```asm
global printHelloWorld

section .text
printHelloWorld:
    mov r10, rdi
    mov r11, rsi

    mov rax, 1
    mov rdi, 1
    mov rsi, r10
    mov rdx, r11
    syscall

    ret
```

编译执行:

    make casm

或者手动编译执行:

    nasm -f elf64 -o casm.o casm.asm
    gcc -o casm casm.o casm.c
    ./casm

## C 内部执行Assembly

[文件inline](./inline.c)

    gcc -o build/inline inline.c
    ./build/inline

## Assembly 调用C

[C文件](./asmc.c) / [Assembly文件](./asmc.asm)

    gcc -c asmc.c -o build/asmc.c.o
    nasm -f elf64 asmc.asm -o build/asmc.asm.o
    ld -dynamic-linker /lib64/ld-linux-x86-64.so.2 -lc build/asmc.asm.o build/asmc.c.o -o build/asmc
    ./build/asmc