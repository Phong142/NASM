
section .data
    inp     db "input: ", 0h 
    outp    db "ouput: ", 0h 
    nl      db 0Ah, 0Dh, 0h

section .bss
    input   resb 100

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

    mov     esi, input
    nextchar:
        xor     edx, edx
        mov     dl, byte [esi]
        push    edx
        cmp     dl, 'a'
        jl      printf
        cmp     dl, 'z'
        jg      printf
        pop     ebx
        sub     dl, 32
        push    edx

    printf:
        mov     edx, 1
        mov     ecx, esp
        mov     ebx, 1
        mov     eax, 4
        int     80h

        pop     edx
        inc     esi
        cmp     byte [esi], 0
        jne     nextchar

    ; mov     edx, 2
    ; mov     ecx, nl
    ; mov     ebx, 1
    ; mov     eax, 4
    ; int     80h

    mov     ebx, 0
    mov     eax, 1
    int     80h

