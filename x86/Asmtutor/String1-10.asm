%include 'Functions.asm'

section .data

section .bss

section .text
global _start

_start:
    mov     ecx, 0

    nextNum:
        inc     ecx
        mov     eax, ecx
        call    _iprintfnl
        cmp     ecx, 10
        jne     nextNum

        call    _exit