
section .data
    mode    db "Chon mot trong cac mode duoi day:", 0Ah, "1. Cong", 0Ah, "2. Tru", 0Ah, "3. Nhan", 0Ah, "4. Chia", 0Ah, "5. Thoat", 0Ah, 0h
    len	    equ	$ - mode                                    ;lenght mode
    scmode  db "Nhap so tuong ung de chon mode: ", 0h 
    snum1   db "Num1 = ", 0h 
    snum2   db "Num2 = ", 0h 
    kq      db "Result = ", 0h 

section .bss
    nmode   resb 1
    n       resq 1
    num1    resb 100
    num2    resb 100
    res     resq 1
    remain  resq 1
    negt    resq 1

section .text
global _start

_start:
    mov     rbp, rsp

    ;input mode
    mov     rdi, 1
    mov     rsi, mode
    mov     rdx, len   ;74
    mov     rax, 1
    syscall
    ;cin >> mode
    .modejmp:
        mov     rdi, 1
        mov     rsi, scmode
        mov     rdx, 32
        mov     rax, 1
        syscall
        mov     rdi, 0
        mov     rsi, nmode 
        mov     rdx, 2
        mov     rax, 0
        syscall

    mov     dl, byte [nmode]
    cmp     dl, '5'
    jz      .exit

    ;cin >> num1
    mov     rdi, 1
    mov     rsi, snum1
    mov     rdx, 7
    mov     rax, 1
    syscall
    mov     rdi, 0
    mov     rsi, num1
    mov     rdx, 100
    mov     rax, 0
    syscall

    ;cin >> num2
    mov     rdi, 1
    mov     rsi, snum2
    mov     rdx, 7
    mov     rax, 1
    syscall
    mov     rdi, 0
    mov     rsi, num2
    mov     rdx, 100
    mov     rax, 0
    syscall

    mov     rsi, num1
    call    atoi
    mov     r12, rax            ;r12 = num1
    mov     rsi, num2
    call    atoi
    mov     r13, rax            ;r13 = num2

    mov     dl, byte [nmode]
    cmp     dl, '1'
    je      .Cong
    cmp     dl, '2'
    je      .Tru
    cmp     dl, '3'
    je      .Nhan
    cmp     dl, '4'
    je      .Chia

    .Cong:
        mov     dword [n], ' + '
        add     r12, r13
        mov     [res], r12
        jmp     .printres

    .Tru:
        mov     dword [n], ' - '
        cmp     r12, r13
        jl      .jmpneg
        sub     r12, r13
        mov     [res], r12
        jmp     .printres
    
    .Nhan:
        mov     dword [n], ' x '
        mov     rax, r12
        mul     r13
        mov     [res], rax
        jmp     .printres
    
    .Chia:
        xor     rdx, rdx
        mov     dword [n], ' / '
        mov     rax, r12
        div     r13
        mov     [res], rax
        mov     [remain], rdx
        jmp     .printres

    .jmpneg:
        mov     r15, 1
        mov     [negt], r15
        sub     r13, r12
        mov     [res], r13
        jmp     .printres

    .printres:
        ;print snum1
        mov     rdi, 1
        mov     rsi, num1
        call    rmnewline
        mov     rdx, rax
        mov     rax, 1
        syscall
        ;print phep tinh
        mov     rdi, 1
        mov     rsi, n
        mov     rdx, 3
        mov     rax, 1
        syscall
        ;print snum2
        mov     rdi, 1
        mov     rsi, num2
        call    rmnewline
        mov     rdx, rax
        mov     rax, 1
        syscall
        ; n: ' = '
        mov     dword [n], ' = '
        mov     rdi, 1
        mov     rsi, n
        mov     rdx, 3
        mov     rax, 1
        syscall
        ;print res
        mov     rsi, [res]
        call    itoa
        mov     r15, [negt]
        cmp     r15, 1          ;r12 > r13     
        jz      .fixneg
        mov     rdx, rax
        call    printf
        mov     r15, [remain]
        cmp     r15, 0
        jnz     .printremain
        jmp     .modejmp

    .fixneg:
        dec     rsi
        mov     byte [rsi], '-'
        inc     rax             ;len str
        mov     rdx, rax
        call    printf
        mov     r15, 0
        mov     [negt], r15
        jmp     .modejmp

    .printremain:
        mov     rsi, [remain]
        call    itoa
        mov     rdx, rax
        call    printf 
        mov     r15, 0
        mov     [remain], r15
        jmp     .modejmp

    .exit:
        mov     rdi, 0
        mov     rax, 60
        syscall

rmnewline:          ;rsi = address str
    push    rbp
    mov     rbp, rsp
    push    rbx
    push    rdi
    mov     rdi, rsi       ;rdi = address str
    xor     rax, rax

    .nextchar:
        xor     rbx, rbx
        mov     bl, byte [rdi]
        cmp     bl, 0Ah
        jz      .break
        inc     rdi
        jmp     .nextchar

    .break:
        sub     rdi, rsi
        mov     rax, rdi        ;rax = len str
        pop     rdi
        pop     rbx
        mov     rsp, rbp
        pop     rbp
        ret

atoi:
    push    rbp
    mov     rbp, rsp
    push    rbx
    push    rdx
    xor     rax, rax
    mov     rbx, 10
    ;rsi = &string
    ;eax = number
    .mull:
        xor     rdx, rdx
        mov     dl, byte [rsi]
        cmp     dl, 30h
        jl      .break
        cmp     dl, 39h
        jg      .break
        sub     dl, 30h
        add     rax, rdx
        mul     rbx
        inc     rsi
        jmp     .mull

    .break:
        xor     rdx, rdx
        div     rbx
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
    ;ret: rax = len,    rsi = &n
    xor     rdi, rdi        ;brk(0)
    mov     rax, 12
    syscall
    mov     rdi, rax        ;handle brk
    add     rdi, 20
    mov     rax, 12
    syscall
    dec     rax
    mov     rsi, rax        ;*str+20
    mov     rax, rbx        ;number
    mov     rdi, rsi
    mov     rbx, 10

    .divl:
        xor     rdx, rdx
        div     rbx
        add     dl, 30h
        mov     byte [rdi], dl
        dec     rdi
        cmp     eax, 0
        jz      .break
        jmp     .divl

    .break:
        sub     rsi, rdi        ;rsi = len str
        mov     rax, rsi        ;rax = len str
        mov     rsi, rdi        ;rsi = &n
        inc     rsi
        pop     rdx
        pop     rbx
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