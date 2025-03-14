
section .text
    global _start

_add_a_b:
    push rbx
    mov rax, [rsp+8]
    mov rbx, [rsp+16]
    add rax, rbx
    pop rbx
    ret

_start:
    mov rdi, 2
    mov rsi, 3
    sub rsp, 16
    mov [rsp+8], rsi
    mov [rsp+16], rdi

    call _add_a_b
    add rsp, 16

    mov rax, 60
    mov rdi, 0
    syscall