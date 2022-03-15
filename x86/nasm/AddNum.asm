%include 'Functions.asm'

section .data
    nl      db 0Ah, 0Dh, 0h 
section .bss
    num1    resb 30
    num2    resb 30
    sum     resb 31

section .text
global _start

_start:
    push    30
    push    num1
    call    read

    push    30
    push    num2
    call    read

    push    num1
    call    atoi
    mov     ebx, eax

    push    num2
    call    atoi
    add     eax, ebx

    push    eax
    push    sum
    call    itoa

    push    eax
    push    sum
    call    write

    push    2
    push    nl
    call    write

    call    exit