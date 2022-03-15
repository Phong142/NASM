%include 'Functions.asm'

section .data

section .bss

section .text
global _start

_start:
    pop     ecx
    pop     edx
    sub     ecx, 1
    xor     edx, edx

    nextArg:
        cmp     ecx, 0h 
        jz      noArgs
        pop     eax
        call    _atoi
        add     edx, eax
        dec     ecx
        jmp     nextArg
    
    noArgs:
        mov     eax, edx
        call    _iprintfnl
        call    _exit