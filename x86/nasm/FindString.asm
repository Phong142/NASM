%include 'Functions.asm'

section .data
    nl      db 0Ah, 0Dh, 0h
section .bss
    sss     resb 100
    css     resb 10
    index   resb 10
    cntt    resb 10
    result  resb 100
    cnt     resd 1
    count   resd 1
section .text
global _start

_start:
    push    100
    push    sss
    call    read

    push    10
    push    css
    call    read

    push    css
    call    strlen
    mov     ecx, eax            ;ecx=len css

    push    sss
    push    css
    call    findStr

    mov     ebx, [count]
    push    ebx
    push    cntt
    call    itoa

    push    10
    push    cntt
    call    write

    push    2
    push    nl
    call    write

    push    100
    push    result
    call    write

    push    2
    push    nl
    call    write

    call    exit

findStr:
    push    ebp
    mov     ebp, esp
    push    eax
    push    ebx
    mov     eax, [ebp+0Ch]      ;ss
    mov     ebx, [ebp+08h]      ;cs
    xor     esi, esi
    
    .find:
        xor     edx, edx
        xor     edi, edi
        mov     dl, byte [eax+esi]
        mov     dh, byte [ebx+0h]
        cmp     dl, 0Ah
        jz      .done
        cmp     dl, dh
        jz      .cmpinc
        inc     esi
        jmp     .find

    .cmpinc:
        xor     edx, edx
        mov     dl, byte [ebx+edi]
        cmp     dl, 0Ah
        jz      .popvt
        mov     dh, [eax+esi]
        cmp     dh, dl
        jnz     .find
        inc     esi
        inc     edi
        jmp     .cmpinc

    .popvt:
        sub     esi, ecx
        push    ecx
        push    esi
        push    index
        call    itoa
        pop     ecx
        add     esi, ecx
        push    index
        push    result
        call    printf
        jmp     .find

    .done:
        pop     ebx
        pop     eax
        mov     esp, ebp
        pop     ebp
        ret     8

printf:
    push    ebp
    mov     ebp, esp
    push    esi
    push    ecx
    push    eax
    push    ebx
    mov     eax, [ebp+0Ch]
    mov     ebx, [ebp+08h]
    xor     edi, edi
    mov     esi, [cnt]
    mov     ecx, [count]

    .print:
        xor     edx, edx
        mov     dl, byte [eax+edi]
        cmp     dl, 0h 
        jz      .done
        mov     byte [ebx+esi], dl
        inc     esi
        inc     edi
        jmp     .print

    .done:
        mov     byte [ebx+esi], 20h
        inc     esi
        inc     ecx
        ; mov     byte [ebx+esi], 0h 
        mov     [cnt], esi
        mov     [count], ecx
        xor     edi, edi
        pop     ebx
        pop     eax
        pop     ecx
        pop     esi
        mov     esp, ebp
        pop     ebp
        ret     8

