; assembly has 4 section:
; - `.data`: data initialize at stack memory(high address)
; - `.bss`: data reserve space at stack memory(high address too), but uninitiailize
; - `.text`: code of the program, where the program execute
; - `.shstrtab`: stores references to the existing sections
section .data
    ; msg is the pointer, and `dq` means declare byte
    msg db "Hello, World", 0xa
    ; len_msg db $-msg ; declare a variable, then point to len_msg pointer
    len_msg equ $-msg ; declare a const variable

section .text
    ; The entry point sets the symbol `_start` visibly to the linker,
    ; then result in an executable file.
    global _start
_start:
    ; syscall number, 1 refers to write
    mov rax, 1
    ; command's first argument
    mov rdi, 1
    ; second argument
    mov rsi, msg
    ; third argument
    mov rdx, len_msg
    ; call syscall
    syscall

.exit:
    ; syscall numberm, 60 refers to exit
    mov rax, 60
    ; exit's first command, 0 equals to gcc's EXIT_SUCCESS
    mov rdi, 0
    syscall