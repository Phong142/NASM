
read:
    push    ebp
    mov     ebp, esp
    push    edx
    push    ecx
    push    ebx

    mov     edx, [ebp+0Ch]          ;num
    mov     ecx, [ebp+08h]          ;str
    mov     ebx, 0
    mov     eax, 3
    int     80h

    pop     ebx
    pop     ecx
    pop     edx
    mov     esp, ebp
    pop     ebp
    ret     8

write:
    push    ebp
    mov     ebp, esp
    push    edx
    push    ecx
    push    ebx
    push    eax

    mov     edx, [ebp+0Ch]          ;num
    mov     ecx, [ebp+08h]          ;str
    mov     ebx, 1
    mov     eax, 4
    int     80h

    pop     eax
    pop     ebx
    pop     ecx
    pop     edx
    mov     esp, ebp
    pop     ebp
    ret     8

exit:
    mov     ebx, 0
    mov     eax, 1
    int     80h

atoi:
    push    ebp
    mov     ebp, esp
    push    ebx
    mov     ebx, [ebp+08h]          ;str
    xor     eax, eax
    mov     ecx, 10

    .multi:
        xor     edx, edx
        mov     dl, [ebx]
        cmp     dl, 0Ah
        jz      .break
        sub     dl, 30h
        add     eax, edx
        mul     ecx
        inc     ebx
        jmp     .multi
    
    .break:
        xor     edx, edx
        div     ecx
        pop     ebx
        mov     esp, ebp
        pop     ebp
        ret     4

itoa:
    push    ebp
    mov     ebp, esp
    push    eax
    push    ebx
    mov     eax, [ebp+0Ch]      ;num
    mov     ebx, [ebp+08h]      ;str
    mov     ecx, 10
    push    69h

    .divid:
        xor     edx, edx
        div     ecx
        add     dl, 30h
        push    edx
        cmp     eax, 0
        jz      .popstr
        jmp     .divid
    
    .popstr:
        xor     edx, edx
        pop     edx
        cmp     dl, 69h
        jz      .break
        mov     [ebx], dl
        inc     ebx
        jmp     .popstr

    .break:
        mov     byte [ebx], 0h
        pop     ebx
        pop     eax
        mov     esp, ebp
        pop     ebp
        ret     8

strlen:
    push    ebp
    mov     ebp, esp
    push    ebx
    mov     ebx, [ebp+08h]
    xor     eax, eax
    xor     edi, edi

    .nextchar: 
        cmp     byte [ebx+edi], 0Ah
        jz      .finish
        inc     edi
        jmp     .nextchar
    
    .finish:
        mov     eax, edi
        pop     ebx
        mov     esp, ebp
        pop     ebp
        ret     4

reverse:
    push    ebp
    mov     ebp, esp
    push    ebx
    mov     ebx, [ebp+08h]          ;str
    xor     esi, esi

    .re:
        xor     edx, edx
        mov     dl, [ebx+esi]
        cmp     dl, 0Ah 
        jz      .popstr
        push    edx
        inc     esi
        jmp     .re

    .popstr:
        xor     edx, edx
        pop     edx
        mov     [ebx], dl
        inc     ebx
        dec     esi
        cmp     esi, 0h
        jz      .break
        jmp     .popstr

    .break:
        pop     ebx
        pop     ebp
        ret     4


