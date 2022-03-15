
section .data
    wsizearr    db "Nhap vao kich thuoc mang: ", 0h
    sarr        db "Nhap vao tung phan tu cua mang: ", 0h 
    sodd        db "Tong cac so le: ", 0h 
    seven       db "Tong cac so chan: ", 0h 

section .bss
    n           resb 5
    narr        resb 100
    arr         resb 100
    sizearr     resd 1
    oddsum      resq 1
    evensum     resq 1

section .text
global _start

_start:
    mov     rbp, rsp

    ;n = so phan tu
    mov     rdi, 1
    mov     rsi, wsizearr
    mov     rdx, 26
    mov     rax, 1
    syscall
    mov     rdi, 0          ;handle in
    mov     rsi, n          ;address
    mov     rdx, 5          ;nbyte
    mov     rax, 0          ;sys_read
    syscall
    mov     rsi, n 
    call    atoi
    mov     [sizearr], eax      ;so phan tu arr

    ;arr: so phan tu
    mov     rdi, 1
    mov     rsi, sarr 
    mov     rdx, 32
    mov     rax, 1
    syscall

    xor     rbx, rbx
    .input:
        mov     rdi, 0
        mov     rsi, narr
        mov     rdx, 100
        mov     rax, 0
        syscall
        mov     rsi, narr
        mov     r12, arr

    .xlstr:
        push    rsi
        call    atoi
        mov     dword [r12+rbx*4], eax
        inc     ebx             ;inc ebx = cmp [sizearr]
        mov     r13d, [sizearr]     ;r13d=size
        cmp     r13d, ebx
        jz      .done
        pop     rsi

    .looparr:
        cmp     byte [rsi], 0Ah
        jz      .input
        inc     rsi
        cmp     byte [rsi-1], 20h
        jz      .xlstr
        jmp     .looparr

    .done:
        mov     rdi, arr
        mov     esi, [sizearr]
        call    calc

    ;oddsum
    mov     rdi, 1
    mov     rsi, sodd
    mov     rdx, 16
    mov     rax, 1
    syscall
    mov     rsi, [oddsum]
    call    itoa
    mov     rdx, rax
    call    printf

    ;evensum
    mov     rdi, 1
    mov     rsi, seven
    mov     rdx, 18
    mov     rax, 1
    syscall
    mov     rsi, [evensum]
    call    itoa
    mov     rdx, rax
    call    printf

    mov     rdi, 0
    mov     rax, 60
    syscall

calc:
    push    rbp
    mov     rbp, rsp
    push    rax
    push    rbx
    push    rdx
    xor     rax, rax
    xor     rbx, rbx
    xor     rdx, rdx
    ;rdi = arr
    ;esi = sizearr
    .ceven:
        mov     edx, dword [rdi]
        test    edx, 1
        jnz     .calcodd
        add     rbx, rdx            ;even
        jmp     .check

    .calcodd:
        add     rax, rdx            ;odd

    .check:
        add     rdi, 4
        dec     esi
        cmp     esi, 0
        jz      .break
        jmp     .ceven

    .break:
        mov     [oddsum], rax
        mov     [evensum], rbx
        pop     rdx
        pop     rbx
        pop     rax
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
        add     eax, edx
        mul     ebx
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
    ;ret: rax = len,    rsi=&n
    xor     rdi, rdi        ;brk(0)
    mov     rax, 12
    syscall
    mov     rdi, rax        ;handle brk
    add     rdi, 20         ;*str+20
    mov     rax, 12
    syscall     
    dec     rax
    mov     rsi, rax        ;rsi = *str+20
    mov     rax, rbx        ;number
    mov     rdi, rsi        ;*str+20
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
        sub     rsi, rdi        ;lenstr
        mov     rax, rsi        ;lenstr
        mov     rsi, rdi
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