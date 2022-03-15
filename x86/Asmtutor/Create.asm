%include 'Functions.asm'

section .data
    fname   db "readme.txt", 0h 
    cont    db "Hello Bugssss", 0h 

section .bss
    fcont   resb 255
section .text
global _start

_start:
    mov     ecx, 0777o
    mov     ebx, fname
    mov     eax, 8
    int     80h

    ; mov     eax, cont
    ; call    _printfnl

    mov     edx, 12
    mov     ecx, cont
    mov     ebx, eax
    mov     eax, 4
    int     80h

    mov     ecx, 0
    mov     ebx, fname
    mov     eax, 5
    int     80h
    
    mov     edx, 12
    mov     ecx, fcont
    mov     ebx, eax
    mov     eax, 3
    int     80h

    mov     eax, fcont
    call    _printfnl

    mov     ebx, ebx
    mov     eax, 6
    int     80h
    call    _exit