section .data
    SYS_WRITE   equ 1
    STD_OUT     equ 1
    SYS_EXIT    equ 60
    EXIT_CODE   equ 0

    NEW_LINE     db 0x0a
    INPUT        db "Hello World!"

section .bss
    OUTPUT     resb 12

section .text
    global _start
_start:
    mov rsi, INPUT
    xor rcx, rcx
    ; resets df flag to zero
    ; we will handle symbols of string from left to right
    cld
    mov rdi, $+15
    call calculateStrLength

calculateStrLength:
    cmp byte [rsi], 0
    je .exitFromRoutine
    ; load next byte from rsi into al, and inc rsi
    lodsb
    push rax
    inc rcx
    jmp calculateStrLength

.exitFromRoutine
    push rdi
    ret
