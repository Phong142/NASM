%include 'Functions.asm'

section .data
    msg     db "Seconds since Jan 01 1970: ", 0h

section .bss

section .text
global _start

_start:
    mov     eax, msg
    call    _printf 

    mov     eax, 13
    int     80h 
    call    _iprintfnl

    call    _exit