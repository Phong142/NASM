%include 'Functions.asm'

section .data
    fname   db 'readme.txt', 0h 

section .bss

section .text
global _start

_start:
    mov     ebx, fname
    mov     eax, 10
    int     80h

    call    _exit