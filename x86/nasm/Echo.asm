
section .data
    inp      db "input: ", 0h 
    outp     db "ouput: ", 0h
section .bss
    input:  resb 100

section .text
global _start

_start:
    mov     edx, 7
    mov     ecx, inp
    mov     ebx, 1
    mov     eax, 4
    int     80h

    mov     edx, 100
    mov     ecx, input
    mov     ebx, 0
    mov     eax, 3
    int     80h

    mov     edx, 7
    mov     ecx, outp
    mov     ebx, 1
    mov     eax, 4
    int     80h

    mov     edx, 100
    mov     ecx, input
    mov     ebx, 1
    mov     eax, 4
    int     80h

    mov     ebx, 0
    mov     eax, 1
    int     80h