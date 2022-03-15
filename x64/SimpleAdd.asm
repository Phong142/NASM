
section .data

section .bss
    num1    resb 100
    num2    resb 100

section .text
global _start

_start:
    mov     rbp, rsp

    mov     rdx, 100
    mov     rdi, 0
    mov     rsi, num1
    mov     rax, 0
    syscall

    mov     rdx, 100
    mov     rdi, 0
    mov     rsi, num2
    mov     rax, 0
    syscall

    mov     rsi, num1           
    call    atoi
    mov     ebx, eax

    mov     rsi, num2
    call    atoi
    add     ebx, eax

    mov     rsi, rbx
    call    itoa
    mov     rdx, rax        ;nbyte
    call    printf

    mov     rdi, 0
    mov     rax, 60
    syscall

printf:
    mov     al, 0Ah
    mov     [rsi+rdx], al
    inc     rdx
    mov     rdi, 1
    mov     rax, 1
    syscall
    ret

atoi:
    push    rbp
    mov     rbp, rsp
    push    rbx
    push    rdx
    xor     rax, rax
    mov     rbx, 10
    ;rsi = add string       
    ;eax = number
    .mull:
        xor     rdx, rdx
        mov     dl, byte [rsi]
        cmp     dl, 30h
        jl      .break
        cmp     dl, 39h
        jg      .break
        sub     dl, 30h
        add     eax, edx
        mul     ebx
        inc     rsi
        jmp     .mull
    
    .break:
        xor     rdx, rdx
        div     ebx
        pop     rdx
        pop     rbx
        mov     rsp, rbp
        pop     rbp
        ret

itoa:
    push    rbp
    mov     rbp, rsp
    push    rbx
    push    rdx
    mov     rbx, rsi
    ;rsi = number 
    ;ret: rax = len str,    rsi=&n
    xor     rdi, rdi
    mov     rax, 12         ;sys_brk(0)
    syscall
    mov     rdi, rax        ;handle brk
    add     rdi, 20
    mov     rax, 12
    syscall
    dec     rax
    mov     rsi, rax        ;rsi=*str+20
    mov     rax, rbx
    mov     rdi, rsi
    mov     rbx, 10

    .divl:
        xor     rdx, rdx
        div     rbx
        add     dl, 30h
        mov     byte [rdi], dl
        dec     di
        cmp     eax, 0
        jz      .break
        jmp     .divl
    
    .break:
        sub     rsi, rdi       ;len
        mov     rax, rsi        ;len
        mov     rsi, rdi
        inc     rsi
        pop     rbx
        pop     rdx
        mov     rsp, rbp
        pop     rbp
        ret
