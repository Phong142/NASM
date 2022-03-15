%include 'Functions.asm'

section .data
    
section .bss
    num1    resb 100
    num2    resb 100
    result  resb 101
    len1    resd 1
    len2    resd 1
    mem     resd 1

section .text
global _starts

_start:
    push    100
    push    num1
    call    read
    push    num1
    call    strlen
    mov     [len1], eax             ;len1

    push    100
    push    num2
    call    read
    push    num2    
    call    strlen
    mov     [len2], eax             ;len2   

    push    num1
    call    reverse
    push    num2
    call    reverse

    mov     eax, [len1]
    mov     ebx, [len2]
    cmp     eax, ebx
    jl      .jmpstr2            ;len1<len2
    cmp     eax, ebx
    jg      .jmpstr1            ;len1>len2

    .jmpadd:                    ;len1=len2
        push    num1
        push    num2
        push    result
        call    sum
        jmp     .index

    .jmpstr2:
        mov     eax, [len2]         ;lendai
        mov     ebx, [len1]         ;lenngan
        push    eax
        push    ebx
        push    num1
        call    fixzero
        jmp     .jmpadd

    .jmpstr1:
        mov     eax, [len1]         ;lendai
        mov     ebx, [len2]         ;lenngan
        push    eax
        push    ebx
        push    num2
        call    fixzero
        jmp     .jmpadd

    .index:
        push    result              ;re kq
        call    reverse
        push    101
        push    result
        call    write

    call    exit

sum:
    push    ebp
    mov     ebp, esp
    push    eax
    push    ebx
    push    ecx
    mov     eax, [ebp+10h]          ;num1
    mov     ebx, [ebp+0Ch]          ;num2
    mov     ecx, [ebp+08h]          ;result
    xor     esi, esi
    xor     edi, edi
    .addd:
        xor     edx, edx
        mov     dl, byte [eax+esi]
        mov     dh, byte [ebx+esi]
        cmp     dl, 0Ah
        jz      .addmem
        cmp     dh, 0Ah
        jz      .addmem
        sub     dl, 30h
        sub     dh, 30h
        add     dl, dh
        xor     dh, dh
        add     edx, [mem]
        mov     edi, 0
        mov     [mem], edi
        cmp     dl, 10
        jnc     .high

    .next:                          
        add     dl, 30h
        mov     byte [ecx+esi], dl
        inc     esi
        jmp     .addd

    .high:                          ;sum>=10
        mov     edi, 1
        mov     [mem], edi
        sub     dl, 10
        jmp     .next

    .addmem:                        
        xor     edx, edx
        mov     edx, [mem]
        cmp     dl, 0
        je      .break
        add     dl, 30h
        mov     byte [ecx+esi], dl
        inc     esi

    .break:
        mov     byte [ecx+esi], 0Ah
        inc     esi
        mov     byte [ecx+esi], 0h
        pop     ecx
        pop     ebx
        pop     eax
        mov     esp, ebp
        pop     ebp
        ret     12

fixzero:
    push    ebp
    mov     ebp, esp
    push    eax
    push    ebx
    push    ecx
    mov     eax, [ebp+10h]          ;lendai
    mov     ebx, [ebp+0Ch]          ;lenngan
    mov     ecx, [ebp+08h]          ;strngan

    .insert:
        cmp     eax, ebx
        jz      .break
        mov     byte [ecx+ebx], 30h
        inc     ebx
        jmp     .insert

    .break:
        mov     byte [ecx+ebx], 0h
        pop     ecx
        pop     ebx
        pop     eax
        mov     esp, ebp
        pop     ebp
        ret     12
