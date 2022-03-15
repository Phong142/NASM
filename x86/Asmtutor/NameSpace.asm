%include 'Functions.asm'

section .data
    msg1    db 'Jumping to finished label.', 0h 
    msg2    db 'Inside subroutine number: ', 0h
    msg3    db 'Inside subroutine "finished".', 0h

section .bss

section .text
global _start

_start:
    One:
        mov     eax, msg1
        call    _printfnl
        jmp     .finished

        .finished:
            mov     eax, msg2
            call    _printf
            mov     eax, 1
            call    _iprintfnl

    Two:
        mov     eax, msg1
        call    _printfnl
        jmp     .finished

        .finished:
            mov     eax, msg2
            call    _printf
            mov     eax, 2
            call    _iprintfnl

    finished:
        mov     eax, msg3
        call    _printfnl

        call    _exit        