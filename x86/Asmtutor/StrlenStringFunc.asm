%include 'Functions.asm'

section .data
    msg1    db "Hello Bugssssssssss!", 0
    msg2    db "Hello Money", 0

section .bss

section .text
global _start

_start:
    mov     eax, msg1
    call    _printfnl

    mov     eax, msg2
    call    _printfnl

    call    _exit