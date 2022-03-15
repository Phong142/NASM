
section .data
    snum1   db "Num1 = ", 0h 
    snum2   db "Num2 = ", 0h 
    ssum    db "Sum = ", 0h 

section .bss
    num1    resb 100
    num2    resb 100
    sum     resb 101

section .text
global _start

_start:
    mov     rbp, rsp

    ;num1
    mov     rdx, 7
    mov     rdi, 1
    mov     rsi, snum1
    mov     rax, 1
    syscall
    mov     rdx, 100
    mov     rdi, 0          ;handle in
    mov     rsi, num1
    mov     rax, 0
    syscall

    ;num2
    mov     rdx, 7
    mov     rdi, 1
    mov     rsi, snum2
    mov     rax, 1
    syscall
    mov     rdx, 100
    mov     rdi, 0
    mov     rsi, num2
    mov     rax, 0
    syscall

    ;calc
    mov     rsi, num1
    mov     rdi, num2
    mov     rdx, sum
    call    bignum

    ;print
    mov     rdx, 6
    mov     rdi, 1
    mov     rsi, ssum
    mov     rax, 1
    syscall
    mov     rsi, sum
    mov     rdx, r15
    call    printf

    mov     rdi, 0
    mov     rax, 60
    syscall

bignum:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 18h
    push    rax
    push    rbx
    push    rcx
    mov     [rbp-08h], rsi      ;num1
    mov     [rbp-10h], rdi      ;num2
    mov     [rbp-18h], rdx      ;sum

    call    reverse             ;num1
    mov     rax, rdi
    mov     rsi, [rbp-10h]
    call    reverse
    mov     rbx, rdi
    cmp     rax, rbx
    jl      .mlen2               ;len2>len1
    jg      .mlen1               ;len2<len1

    .mlen1:
        mov     rsi, [rbp-10h]          ;num2
        push    rbx                     ;len2
        push    rax                     ;len1
        call    insertzero
        jmp     .format

    .mlen2:
        mov     rsi, [rbp-08h]          ;num1
        push    rax                     ;len1
        push    rbx                     ;len2
        call    insertzero
        jmp     .format

    .format:
        xor     rbx, rbx
        mov     rsi, [rbp-08h]          ;num1
        mov     rdi, [rbp-10h]          ;num2
        mov     rdx, [rbp-18h]          ;sum
        mov     r12, 0                  ;mem

    .calc:
        xor     rax, rax
        mov     al, byte [rsi+rbx]
        mov     ah, byte [rdi+rbx]
        cmp     al, 0Ah
        jz      .done
        sub     al, 30h
        sub     ah, 30h
        add     al, ah
        xor     ah, ah
        add     rax, r12            ;add mem
        mov     r12, 0
        cmp     al, 10
        jnc     .high

    .next:
        add     al, 30h
        mov     byte [rdx+rbx], al
        inc     rbx
        jmp     .calc

    .high:
        mov     r12, 1
        sub     al, 10
        jmp     .next

    .done:
        mov     byte [rdx+rbx], 0Ah
        mov     r15, rbx                ;len str
        pop     rcx
        pop     rbx
        pop     rax
        mov     rsi, [rbp-18h]          ;rsi=&sum
        call    reverse
        mov     rsp, rbp
        pop     rbp
        ret

insertzero:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 08h
    push    rax
    push    rcx
    push    rdx
    mov     [rbp-08h], rsi          ;string
    mov     rcx, [rbp+10h]          ;len max
    mov     rdx, [rbp+18h]          ;len min

    .insert:
        cmp     rcx, rdx
        jz      .break
        mov     byte [rsi+rdx], 30h
        inc     rdx
        jmp     .insert

    .break:
        mov     byte [rsi+rdx], 0Ah
        pop     rdx
        pop     rcx
        pop     rax
        mov     rsp, rbp
        pop     rbp
        ret

reverse:
    push    rbp
    mov     rbp, rsp
    push    rax
    push    rcx
    push    rdx
    mov     rdi, rsi        ;address string
    mov     rdx, rsi
    xor     rax, rax
    xor     rcx, rcx

    .mull:
        lodsb               ;al = [rsi++]
        cmp     al, 0Ah
        jz      .popl
        push    rax
        inc     rcx
        jmp     .mull

    .popl:
        cmp     rcx, 0
        jz      .break
        pop     rax
        stosb               ;al = [rdi++]
        dec     rcx
        jmp     .popl

    .break:
        sub     rdi, rdx    ;len str
        pop     rdx
        pop     rcx
        pop     rax
        mov     rsp, rbp
        pop     rbp
        ret

printf:
    mov     al, 0Ah
    mov     [rsi+rdx], al
    inc     rdx
    mov     rdi, 1
    mov     rax, 1
    syscall
    ret