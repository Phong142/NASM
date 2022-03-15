%include 'Functions.asm'
section .data
    msg1    db "input: ", 0h 
    msg2    db "Hello, ", 0h 

section .bss
    input:  resb 100

section .text
global _start

_start:
    mov     eax, msg1
    call    _printf

    mov     edx, 100
    mov     ecx, input
    mov     ebx, 0
    mov     eax, 3
    int     80h

    mov     eax, msg2
    call    _printf

    mov     eax, input
    call    _printf

    call    _exit