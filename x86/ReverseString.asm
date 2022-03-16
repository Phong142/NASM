%include 'Functions.asm'

section .data

section .bss
    inp     resb 30
section .text
global _start

_start:
    push    30
    push    inp
    call    read

    push    inp
    call    reverse

    push    eax
    push    inp
    call    write

    call    exit

; section .bss
;     input   resb    100
; section .text
;     global _start
; _start:
;     push	100
; 	push	input
; 	call	readConsole

;     push    eax

;     push    input
;     call    re_str

;     push    input   
;     call    writeConsole

;     call    exitProcess