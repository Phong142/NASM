%include 'Functions.asm'

section .data
    fname   db 'readme.txt', 0h 
    cont    db '-updated-', 0h 

section .bss

section .text
global _start

_start:
    mov     ecx, 1
    mov     ebx, fname
    mov     eax, 5
    int     80h

    mov     edx, 2
    mov     ecx, 0
    mov     ebx, eax
    mov     eax, 19
    int     80h

    mov     edx, 9
    mov     ecx, cont
    mov     ebx, ebx
    mov     eax, 4
    int     80h

    call    _exit