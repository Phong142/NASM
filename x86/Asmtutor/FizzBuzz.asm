%include 'Functions.asm'

section .data
    fizz    db "Fizz", 0h 
    buzz    db "Buzz", 0h 

section .bss

section .text
global _start

_start:
    xor     esi, esi
    xor     edi, edi
    xor     ecx, ecx

    nextNum:
        inc     ecx

        .checkfizz:
            xor     edx, edx
            mov     eax, ecx
            mov     ebx, 3
            div     ebx
            mov     edi, edx
            cmp     edi, 0
            jne     .checkbuzz
            mov     eax, fizz
            call    _printf
        
        .checkbuzz:
            xor     edx, edx
            mov     eax, ecx
            mov     ebx, 5
            div     ebx
            mov     esi, edx
            cmp     esi, 0
            jne     .checkint
            mov     eax, buzz
            call    _printf

        .checkint:
            cmp     edi, 0
            je      .continue
            cmp     esi, 0
            je      .continue
            mov     eax, ecx
            call    _iprintf

        .continue:
            mov     eax, 0Ah
            push    eax
            mov     eax, esp
            call    _printf
            pop     eax
            cmp     ecx, 100
            jne     nextNum

            call    _exit