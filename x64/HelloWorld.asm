%include 'Functions.asm'

section .data
    msg     db "Hello Bugs!", 0Ah, 0Ah

section .bss

section .text
global _start

_start:
    mov     rbp, rsp

    mov     rdx, 12
    mov     rdi, 1          ;handle file out
    mov     rsi, msg        ;address msg
    mov     rax, 1          ;sys_write
    syscall

    mov     rax, 60         ;sys_exit
    mov     rdi, 0          ;exit code 0
    syscall
