%include 'Functions.asm'

section .data
    msg     db " remainder "
section .bss

section .text
global _start

_start:
    mov     eax, 90
    mov     ebx, 9
    add     eax, ebx
    call    _iprintfnl
    
    mov     eax, 90
    mov     ebx, 9
    sub     eax, ebx
    call    _iprintfnl

    mov     eax, 90
    mov     ebx, 9
    mul     ebx
    call    _iprintfnl

    mov     eax, 90
    mov     ebx, 9
    div     ebx
    call    _iprintf
    mov     eax, msg
    call    _printf
    mov     eax, edx
    call    _iprintfnl

    call    _exit