%include 'Functions.asm'

section .data
    SumO    db "Tong le = ", 0h 
    SumE    db "Tong chan = ", 0h 
    nl      db 0Ah, 0Dh, 0h 
    
section .bss
    num     resb 10
    odd     resd 1
    even    resd 1
    
section .text
global _start

_start:
    push    10
    push    num
    call    read

    push    num
    call    atoi
    mov     esi, eax            ;so phan tu

    .find:
        cmp     esi, 0
        jz      .break
        push    10
        push    num
        call    read
        dec     esi
        push    num
        call    atoi
        mov     ebx, eax
        mov     ecx, 2
        xor     edx, edx
        div     ecx
        cmp     dl, 1           ;eax%ecx==1
        jz      .odd            ;jmp tong le
    
    .even:
        mov     edi, [even]
        add     edi, ebx
        mov     [even], edi
        jmp     .find

    .odd:
        mov     edi, [odd]
        add     edi, ebx
        mov     [odd], edi
        jmp     .find

    .break:
        push    11
        push    SumO
        call    write
        xor     edx, edx
        mov     edx, [odd]
        push    edx
        push    num
        call    itoa
        push    10
        push    num
        call    write

        push    2
        push    nl
        call    write

        push    13
        push    SumE
        call    write
        xor     edx, edx
        mov     edx, [even]
        push    edx
        push    num
        call    itoa
        push    10
        push    num
        call    write

        push    2
        push    nl
        call    write
    
    call    exit