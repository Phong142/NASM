
section .data

section .bss
    string      resb 100

section .text
global _start

_start:
    mov     rbp, rsp

    mov     rdx, 100
    mov     rdi, 0          ;handle file in
    mov     rsi, string
    mov     rax, 0          ;sys_read
    syscall

    mov     rbx, string
    .nextchar:
        xor     rdx, rdx
        mov     dl, byte [rbx]
        push    rdx
        cmp     dl, 'a'
        jl      .printf
        cmp     dl, 'z'
        jg      .printf
        pop     rdx
        sub     dl, 20h         ;dl=dl-32
        push    rdx

    .printf:
        mov     rdx, 1
        mov     rdi, 1
        mov     rsi, rsp
        mov     rax, 1
        syscall

        inc     rbx
        cmp     byte [rbx], 0h
        jne     .nextchar

    mov     rdi, 0
    mov     rax, 60
    syscall



