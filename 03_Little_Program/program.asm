section .data
    SYS_WRITE   equ 1
    STD_IN      equ 1
    SYS_EXIT    equ 60
    EXIT_CODE   equ 0

    NEW_LINE    db 0x0a
    WRONG_ARGC  db "Must be two command line argument!", 0x0a

section .text
    global _start
_start:
    pop rcx
    cmp rcx, 3
    jne .argcError

    add rsp, 8
    pop rsi
    call str_to_int

    mov r10, rax
    pop rsi
    call str_to_int
    mov r11, rax