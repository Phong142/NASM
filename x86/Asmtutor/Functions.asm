_atoi:
    push    ebx
    push    ecx
    push    edx
    push    esi
    mov     esi, eax
    xor     eax, eax
    xor     ecx, ecx

    mulloop:
        xor     ebx, ebx
        mov     bl, [esi+ecx]
        cmp     bl, 48
        jl      mov0
        cmp     bl, 57
        jg      mov0
        sub     bl, 48
        add     eax, ebx
        mov     ebx, 10
        mul     ebx
        inc     ecx
        jmp     mulloop

    mov0:
        cmp     ecx, 0
        je      restore
        mov     ebx, 10
        div     ebx

    restore:
        pop     esi
        pop     edx
        pop     ecx
        pop     ebx
        ret
        
_iprintf:
    push    eax
    push    ecx
    push    edx
    push    esi
    xor     ecx, ecx

    divloop:
        inc     ecx
        xor     edx, edx
        mov     esi, 10
        div     esi
        add     edx, 30h
        push    edx
        cmp     eax, 0
        jnz     divloop

    printloop:
        dec     ecx
        mov     eax, esp
        call    _printf
        pop     eax
        cmp     ecx, 0
        jnz     printloop

        pop     esi
        pop     edx
        pop     ecx
        pop     eax
        ret

_iprintfnl:
    call    _iprintf
    push    eax
    mov     eax, 0Ah
    push    eax
    mov     eax, esp
    call    _printf
    pop     eax
    pop     eax
    ret

_strlen:
    push    ebx
    mov     ebx, eax

    nextchar:
        cmp     byte [eax], 0
        jz      finish
        inc     eax
        jmp     nextchar
    
    finish:
        sub     eax, ebx
        pop     ebx
        ret

_printf:
    push    edx
    push    ecx
    push    ebx
    push    eax
    call    _strlen

    mov     edx, eax
    pop     eax

    mov     ecx, eax
    mov     ebx, 1
    mov     eax, 4
    int     80h

    pop     ebx
    pop     ecx
    pop     edx
    ret

_printfnl:
    call    _printf

    push    eax
    mov     eax, 0Ah
    push    eax
    mov     eax, esp
    call    _printf
    pop     eax
    pop     eax
    ret

_exit:
    mov     ebx, 0
    mov     eax, 1
    int     80h
    ret