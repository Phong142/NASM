%include 'Functions.asm'

section .data
    cmd3    db '/bin/ls', 0h       
    arg3    db '-l', 0h
    cmd2    db '/bin/ls', 0h      
    arg2    db '-l', 0h
    cmd     db "/bin/echo", 0h 
    arg1    db "Hello Bugs!", 0h 
    argu    dd cmd3
            dd arg3
            dd 0h 
    envir   dd 0h 

section .bss

section .text
global _start

_start:
    mov     edx, envir
    mov     ecx, argu
    mov     ebx, cmd3
    mov     eax, 11
    int     80h

    call    _exit