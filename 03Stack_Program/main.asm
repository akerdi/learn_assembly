section .data
    SYS_WRITE   equ 1
    STD_IN      equ 1
    SYS_EXIT    equ 60
    EXIT_CODE   equ 0

    WRONG_ARGC  db "Must be two command line argument!", 0x0a

section .text
    global _start
_start:
    pop rcx
    cmp rcx, 3
    jne .argcError

    ; argv[0] 放的是程序名, 跳过
    add rsp, 8

    ; 将第一个数字转化出来保存到r10
    pop rsi
    call .str_to_int
    mov r10, rax

    pop rsi
    call .str_to_int
    mov r11, rax

    add r10, r11

    ; rax 是涉及计算的寄存器, 默认操作数据都放到rax中
    mov rax, r10
    ; r12 等会用来统计字符串长度, xor 与或门将其置空
    xor r12, r12
    jmp .int_to_str

.str_to_int:
    xor rax, rax
    mov rcx, 10
.next:
    cmp [rsi], byte 0
    je .return_str
    mov bl, [rsi]
    sub bl, 48      ; 对数字减去'0', 得到实际数字序号
    mul rcx         ; mul rax, rcx, 首次0 * 10 = 0
    add rax, rbx    ; bl 已经得到值, 首次rax = 0 + rbx
    inc rsi         ; 继续下一个字符
    jmp .next
.return_str:
    ret

.int_to_str:
    mov rdx, 0      ; rdx 用来存放余数, rax 用来存放商
    mov rbx, 10     ; rbx 用来放除数
    div rbx         ; div rax, rbx -> 123 / 10 -> rax=12, rdx=3
    add rdx, 48     ; rax += 48 -> 3+48 = 51, 也就是字符'3'
    push rdx        ; 将字符'3'压入栈中
    inc r12         ; r12 作计数字符串长度
    cmp rax, 0x0    ; 判别rax 是否为0
    je .print
    jmp .int_to_str

.print:
    mov rax, 1
    mul r12         ; rax = r12 * 1, 根据上面r12位字符长度, "123", 那么rax = 1(rax) * 3(r12)
    mov r12, 8      ; 由于地址偏移是8位, 所以设置r12为8
    mul r12         ; rax = rax * 8 -> 3 * 8 = 24
    mov rdx, rax    ; 将长度给到rdx

    ; 开始打印
    mov rax, SYS_WRITE
    mov rdi, STD_IN
    mov rsi, rsp    ; 直接将栈顶地址给到rsi
    ; rdx 也已经有长度了
    syscall

    jmp .exit

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