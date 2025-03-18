section .data
    num1 dq 75
    num2 dq 75
    msg db "The sum is correct!", 0x0a, 0x00
    msg_len equ $ - msg

section .text
    global _start

_start:
    mov rax, [num1]
    mov rbx, [num2]
    add rax, rbx
.compare:
    ; compare function
    cmp rax, 150
    ; if not equal, jump to exit
    jne exit
    ; else jump to correctSum
    jmp correctSum

correctSum:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, msg_len
    syscall

    jmp exit

exit:
    mov rax, 60
    mov rdi, 0
    syscall
