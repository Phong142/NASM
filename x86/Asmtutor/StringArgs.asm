%include 'Functions.asm'

section .data

section .bss

section .text
global _start

_start:
    pop     ecx

    nextArg:
        cmp     ecx, 0h
        jz      noMoreArgs
        pop     eax
        call    _printfnl
        dec     ecx
        jmp     nextArg
    
    noMoreArgs:
        call    _exit