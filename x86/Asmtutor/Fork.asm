%include 'Functions.asm'

section .data
    mo      db "mother", 0h
    son     db "son", 0h

section .bss

section .text
global _start

_start:
    mov     eax, 2
    int     80h

    cmp     eax, 0
    jz      json

    jmo:
        mov     eax, mo
        call    _printfnl

        call    _exit

    json:
        mov     eax, son
        call    _printfnl

        call    _exit