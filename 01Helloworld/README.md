# Introduction to assembly

<!-- You are eager to learn or to know what is assembly, and how the binary executable works, so you are here. -->

In the first grade README.md, we have follow to successfully run the first assembly program, and the terminal prints `Hello world!`.

<!-- From now on, let's start diving into the basic knowledgement of assembly. -->

Let's first look at "Hello, World" example, compare it to gcc's accomplish of function `puts`:

## "Hello, World" example

We use makefile to build main.asm:

        make run # make && ./main

Let's take a look at the [code](./main.asm):

```asm
; Definition of the `data` section.
section .data
    ; 0xa == \n, so msg = "Hello, World\n"
    msg db "Hello, World", 0xa
    ; $ means current address, $ subtract pointer msg address, results msg.length.
    len_msg equ $-msg
; Definition of the `text` section, code will write here.
section .text
    ; reference to the entry point of our program.
    global _start
; Code entry point.
_start:
    ; specify the number of the system call(1 is `sys_write`).
    mov rax, 1
    ; set the first argument of `sys_write`(`sys_write` need three arguments).
    mov rdi, 1
    ; set the msg address to the second argument of `sys_write`.
    mov rsi, msg
    ; set the third arugment.
    mov rdx, len_msg
    ; call the `sys_write` system call.
    syscall
; Add a label, it is just a signature, code will continue going,
; until meet `ret` or `jump` to stop going down.
.exit:
    ; specify the number of the system call(60 is `sys_exit`).
    mov rax, 60
    ; set the first argument of `sys_exit` to 0, then program will exit correctly.
    mov rdi, 0
    ; call system call.
    syscall
```

If you type `man 2 write` in linux CMD line, it prints out `ssize_t write(int fd, const void*buf, size_t count);` function description, it follows syscall's format, and you read more [here](https://github.com/torvalds/linux/blob/master/arch/x86/entry/syscalls/syscall_64.tbl) or [here](https://www.chromium.org/chromium-os/developer-library/reference/linux-constants/syscalls/).

After successfully get the result of the example, we are now more familiar to the construction of this language.

<!-- This prints result "Hello, World". -->

## Basic

Let's start learning how this really execute.

<!-- Execution is triggered by entry point as `_start` label, which label is set to visible by command `global`, then evaluate later on. -->

Before a program can execute, there are two steps need to be done:
* Compilation to an [object file](https://en.wikipedia.org/wiki/Object_file)
* Building an executable from the object files with a [linker](https://en.wikipedia.org/wiki/Linker_(computing)).

> A linker sets the entry point in the resulted executable file. That is why we must specify the entry point in the `.text` section of our program so that the linker can find it.

Program consists by diagram like below:

```asm
; this is comment line

; Definition of a section block,
; and this block is .data block, using for initializing memory data.
section .data
    ; this part contains initialized memory data.
; Definition of a section block, .text block contains logic code.
section .text
    ; assign the executable's entry point, expose it to linker
    global _start
_start:
; [label:] instruction [operands] [; comment]
```

Just like example:

<!-- ```asm
section .text
    global _start
_start:
    ...
.exit:
    mov rax, 0
    ...
``` -->

So section includes information with variables or codes, it is the first step we should get to know.

Besides section, there are some parts, such as `registers`(nasm x86_64 general-purpose registers); `instructions`(common instruction: [mov|jmp|call|ret|syscall]); `sys calls`; program `stack`; `heap`.

### Section

<!-- Code usually consists of two main elements: the code itself and comments. Comments in assembly start with the `;` symbol. -->

Assembly has 4 kinds of section:

- `.data`: data initialize at stack memory(high address)
- `.bss`: data reserve space at stack memory(high address too), but uninitiailize
- `.text`: code of the program, where the program execute
- `.shstrtab`: stores references to the existing sections

The most use of sections are `.data` and `.text`. Every program is a set of instructions that tell the computer how to perform a specific task.

<!-- Section splite a running executation into several parts, each part stores -->

### CPU registers

<!-- , 16: [rax|rbx|rcx|rdx|rsi|rdi|rbp|rsp|r8|r9|r10|r11|r12|r13|r14|r15] -->

In the `Hello, World` example, after defining section .text, we expose `_start` to the linker, and the linker will enter the actual code under label `_start:`. The `move` instruction is to place specific values into a register. This instruction expects two operands and puts the value of the second operand into the first one. But what are these `rax`, `rdi`, and `rsi`? We can read in the Wikipedia:

> A central processing unit(CPU) is the hardware within a computer that carries out the instructions of a computer program by performing the basic arithmetical, logical, and input/output operations of the system.

A CPU can store data using the main memory, while which place is relatively slow. Reading and storing data in the main memory slows down the operations because it involves complicated steps to send data requests through the control bus. Read each io speed [at link](https://samwho.dev/numbers/). To speed things up, the CPU uses small fast storage locations called **general-purpose registers**.

Each register has a specific size and purpose. For `x86_64` CPUS, general-purpose registers include:

![01Helloworld02_gpregisters.jpg](../Assets/01Helloworld02_gpregisters.jpg)

We can consider each register as a very small memory slot that can store a value with a size specified in the table above. For example, the rax register can contain a value of up to `64` bits, the `ax` register may contains a value of up to `16` bits, and is save in the lower 16 bits of the `rax`. Despite these registers are called **general-purpose registers**, does it means that use any register for any purpose? The simple answer is yes. We can use them to perform arithmetic, logical, data transfer and other basic operations. However, there are specific cases when you should use these registers as specified in the [Application Binary Interface](https://en.wikipedia.org/wiki/Application_binary_interface) and the [calling conventions](https://en.wikipedia.org/wiki/X86_calling_conventions) documents. Since the tutorials are focused on assembly for Linux `x86_64`, the registers have the following meanings:

- rax - used to store temporary values. In the case of a system call, it should store the system call number.
- rdi - used to pass the first argument to a function.
- rsi - used to pass the second.
- rdx - used to pass the third.



### Instructions

### Sys calls

### Stack

### Heap

## Conclusion

Now we had taken a glance at Assembly's basic infomation.

> Word with ref flag comes from original author in [0xAX/asm](https://github.com/0xAX/asm/blob/master/content/asm_1.md) or some other articles. Not reference at this ref phrase=_=.

## Ref

[system call table](https://www.chromium.org/chromium-os/developer-library/reference/linux-constants/syscalls/)
