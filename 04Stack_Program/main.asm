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
    xor rax, rax
    xor rdi, rdi
    jmp reverseStr

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

reverseStr:
    cmp rcx, 0
    je printResult
    pop rax
    mov [OUTPUT+rdi], rax
    dec rcx
    inc rdi
    jmp reverseStr

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