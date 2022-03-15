
; section .data
;     msg     db "Hello Bugssssss!", 0Ah

; section .bss
; section .text
; global _start

; _start:
;     mov     ebx, msg
;     mov     eax, ebx

;     nextchar:
;         cmp     byte [eax], 0
;         jz      finish
;         inc     eax
;         jmp     nextchar

;     finish:
;         sub     eax, ebx
    
;     mov     edx, eax
;     mov     ecx, msg
;     mov     ebx, 1
;     mov     eax, 4
;     int     80h

;     mov     ebx, 0
;     mov     eax, 1
;     int     80h


section .data
    msg     db "Hello Bugssssssss!", 0Ah

section .bss
section .text
global _start

_start:
    mov     eax, msg
    call    _Strlen

    mov     edx, eax
    mov     ecx, msg
    mov     ebx, 1
    mov     eax, 4
    int     80h

    mov     ebx, 0
    mov     eax, 1
    int     80h

_Strlen:
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