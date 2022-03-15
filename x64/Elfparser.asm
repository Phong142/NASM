
section .data
    isELF32             db 0
    isLittle            db 0
    sError              db "Error occured!", 0
    sFilename           db "Link to ELF file: ", 0
    ;file header
    sELF                db "ELF Header: ", 0xa, 0
    sMagic              db 9, "Magic: ", 0
    sClass              db 9, "Class: ", 0
        sELF32          db "ELF32", 0
        sELF64          db "ELF64", 0
    sData               db 9, "Data: ", 0
    sLittelEdian        db "Little Edian", 0
    sBigEdian           db "Big Edian", 0
    sVersion            db 9, "Version: ", 0
    sOSABI              db 9, "OS/ABI: ", 0
    sABIversion         db 9, "ABI version: ", 0
    sType               db 9, "Type: ", 0
    sMachine            db 9, "Machine: ", 0
    sEntryPoint         db 9, "Entry Point Address: ", 0
    sPhoff              db 9, "Start Program Header: ", 0
    sShoff              db 9, "Start Section Header: ", 0
    sFlags              db 9, "Flags: ", 0
    sEhsize             db 9, "Size Header: ", 0
    sPhentsize          db 9, "Size Program Header: ", 0
    sPhnum              db 9, "Number Program Header: ", 0
    sShentsize          db 9, "Size Section: ", 0
    sShnum              db 9, "Number Section: ", 0
    sShstrndx           db 9, "Section Header String Table Index: ", 0

    ;program header
    sProgramHeader      db "Program Header:", 0xa, 0
    sProgramHeaderTable db "Type", 9, "Flags", 9, "Offset", 9, "VirAdd", 9, "PhysAdd", 9, "Filesz", 9, "Memsz", 9, "Align", 0xa, 0

    ;section header
    sSectionHeader      db "Section Header:", 0xa, 0
    sSectionHeaderTable db "Name", 9, 9, "Type", 9, "Flags", 9, "VirAdd", 9, "Offset", 9, "Size", 9, "Link", 9, "Info", 9, "Align", 9, "EntSize", 0xa, 0
section .bss
    filename    resb 512
    filesize    resq 1
    filedata    resq 1
    fd          resd 1         
    fd_stat_sz  resb 144            
    hexString   resb 17

section .text
global _start

_start:
    mov     rbp, rsp
    sub     rbp, 40h
    ;file name
    mov     rdi, 1
    mov     rsi, sFilename
    mov     rdx, 18
    mov     rax, 1
    syscall
    mov     rdi, 0
    mov     rsi, filename
    mov     rdx, 512
    mov     rax, 0
    syscall
    mov     rsi, hexString
    mov     rdx, 0
    call    println

    ;openfile
    mov     rdi, filename
    call    strlen
    mov     byte [filename+rax], 0      ;null-terminated
    mov     rdi, filename
    mov     rsi, 0                      ;read_only flag
    mov     rdx, 0
    mov     rax, 2                      ;sys_open
    syscall                             ;open(filename, O_RDONLY: read)
    cmp     eax, -1
    jz      .erExit
    mov     [fd], eax
    ;file size
    mov     rdi, [fd]                   ;open file return (fd)
    mov     rsi, fd_stat_sz             ;144?       
    mov     rax, 5                      ;sys_fstat
    syscall
    mov     rsi, fd_stat_sz
    mov     rsi, qword [rsi+48]          ;size
    mov     [filesize], rsi
    ;allocate mem
    xor     rdi, rdi
    mov     rax, 12
    syscall
    mov     rdi, rax
    mov     [filedata], rdi             ;0
    add     rdi, [filesize]
    mov     rax, 12
    syscall
    ;read file 
    mov     edi, [fd]
    mov     rsi, [filedata]
    mov     rdx, [filesize]
    mov     rax, 0
    syscall

    ;parser file
    mov     rbx, [filedata]
    ;ELF Header (7f 45 4c 46)
    mov     edi, dword [rbx]            
    cmp     edi, 0x464c457f             ;little
    jne     .erExit
    mov     rdi, 1
    mov     rsi, sELF
    mov     rdx, 13
    mov     rax, 1
    syscall

    ;magic
    mov     rdi, 1
    mov     rsi, sMagic
    mov     rdx, 8
    mov     rax, 1
    syscall 
    mov     r12, 0                      ;count
    .printfMagic:
        mov     dil, byte [rbx+r12]
        mov     rsi, hexString
        call    lltoh
        mov     rsi, hexString
        mov     byte [rsi+rax], 20h
        inc     rax
        mov     rdi, 1
        mov     rdx, rax
        mov     rax, 1
        syscall
        inc     r12
        cmp     r12, 10h
        jne     .printfMagic
        mov     rdi, 1
        mov     rsi, hexString
        mov     rax, 0
        call    println

    ;class
    mov     rdi, 1
    mov     rsi, sClass
    mov     rdx, 8
    mov     rax, 1
    syscall
    mov     dil, [rbx+4]
    cmp     dil, 1
    jz      .elf32 
    mov     rsi, sELF64
    mov     rdx, 5
    call    println
    jmp     .endClass
    .elf32:
        mov     byte [isELF32], 1
        mov     rsi, sELF32
        mov     rdx, 5
        call    println
    .endClass

    ;data
    mov     rdi, 1
    mov     rsi, sData
    mov     rdx, 7
    mov     rax, 1
    syscall
    mov     dil, [rbx+5]
    cmp     dil, 1
    jz      .little
    mov     rsi, sBigEdian
    mov     rdx, 9
    call    println
    jmp     .endData
    .little:
        mov     byte [isLittle], 1
        mov     rsi, sLittelEdian
        mov     rdx, 13
        call    println
    .endData

    ;version
    mov     rdi, 1
    mov     rsi, sVersion
    mov     rdx, 10
    mov     rax, 1
    syscall
    mov     dil, [rbx+6]
    mov     rsi, hexString
    call    lltoh
    mov     rsi, hexString
    mov     byte [rsi+rax], 0Ah 
    inc     rax
    mov     rdi, 1
    mov     rdx, rax
    mov     rax, 1
    syscall

    ;OS/ABI
    mov     rdi, 1
    mov     rsi, sOSABI
    mov     rdx, 9
    mov     rax, 1
    syscall
    mov     dil, [rbx+7]
    mov     rsi, hexString
    call    lltoh
    mov     rsi, hexString
    mov     byte [rsi+rax], 0Ah
    inc     rax
    mov     rdi, 1
    mov     rdx, rax
    mov     rax, 1
    syscall

    ;ABIversion
    mov     rdi, 1
    mov     rsi, sABIversion
    mov     rdx, 14
    mov     rax, 1
    syscall
    mov     dil, byte [rbx+8]
    mov     rsi, hexString
    call    lltoh
    mov     rsi, hexString
    mov     byte [rsi+rax], 0Ah
    inc     rax
    mov     rdi, 1
    mov     rdx, rax
    mov     rax, 1
    syscall

    ;Type
    mov     rdi, 1
    mov     rsi, sType
    mov     rdx, 7
    mov     rax, 1
    syscall
    mov     di, [rbx+0x10]
    mov     rsi, hexString
    call    lltoh
    mov     rsi, hexString
    mov     word [rsi+rax], 0Ah
    inc     rax
    mov     rdi, 1
    mov     rdx, rax
    mov     rax, 1
    syscall

    ;Machine
    mov     rdi, 1
    mov     rsi, sMachine
    mov     rdx, 10
    mov     rax, 1
    syscall
    mov     di, [rbx+0x12]
    mov     rsi, hexString
    call    lltoh
    mov     rsi, hexString
    mov     word [rsi+rax], 0Ah
    inc     rax
    mov     rdi, 1
    mov     rdx, rax
    mov     rax, 1
    syscall

    ;e_version
    mov     rdi, 1
    mov     rsi, sVersion
    mov     rdx, 10
    mov     rax, 1
    syscall
    mov     edi, [rbx+0x14]
    mov     rsi, hexString
    call    lltoh
    mov     rsi, hexString
    mov     dword [rsi+rax], 0Ah
    inc     rax
    mov     rdi, 1
    mov     rdx, rax
    mov     rax, 1
    syscall

    ;e_entry
    mov     rdi, 1
    mov     rsi, sEntryPoint
    mov     rdx, 22
    mov     rax, 1
    syscall
    cmp     byte [isELF32], 1
    jz      .file32
    jmp     .file64
    .file32:
        mov     edi, dword [rbx+0x18]
        jmp     .endTry

    .file64:
        mov     rdi, qword [rbx+0x18]
    
    .endTry:
        mov     rsi, hexString
        call    lltoh
        mov     rsi, hexString
        mov     byte [rsi+rax], 0Ah
        inc     rax
        mov     rdi, 1
        mov     rdx, rax
        mov     rax, 1
        syscall
    
    ;e_phoff
    mov     rdi, 1
    mov     rsi, sPhoff
    mov     rdx, 23
    mov     rax, 1
    syscall
    cmp     byte [isELF32], 1
    jz      .phoff32
    jmp     .phoff64
    .phoff32:
        mov     edi, dword [rbx+1Ch]
        mov     [rbp-08h], edi                  ;e_Phoff
        jmp     .endPhoff

    .phoff64:
        mov     rdi, qword [rbx+20h]
        mov     [rbp-08h], rdi                  ;e_Phoff

    .endPhoff:
        mov     rsi, hexString
        call    lltoh
        mov     rsi, hexString
        mov     byte [rsi+rax], 0Ah
        inc     rax
        mov     rdi, 1
        mov     rdx, rax
        mov     rax, 1
        syscall

    ;e_Shoff
    mov     rdi, 1
    mov     rsi, sShoff
    mov     rdx, 23
    mov     rax, 1
    syscall
    cmp     byte [isELF32], 1
    jz      .shoff32
    jmp     .shoff64
    .shoff32:
        mov     edi, dword [rbx+20h]
        mov     [rbp-10h], edi                  ;e_shoff
        jmp     .endShoff

    .shoff64:
        mov     rdi, qword [rbx+28h]
        mov     [rbp-10h], rdi                  ;e_shoff

    .endShoff:
        mov     rsi, hexString
        call    lltoh
        mov     rsi, hexString
        mov     byte [rsi+rax], 0Ah
        inc     rax
        mov     rdi, 1
        mov     rdx, rax
        mov     rax, 1
        syscall

    mov     r12, 24h                            ;e_flags
    ;e_flags
    mov     rdi, 1
    mov     rsi, sFlags
    mov     rdx, 8
    mov     rax, 1
    syscall
    cmp     byte [isELF32], 1
    jz      .flags32
    jmp     .flags64
    .flags32:
        mov     edi, dword [rbx+r12]
        jmp     .endFlags

    .flags64:
        add     r12, 0Ch                        ;24h-30h(flags64)
        mov     edi, dword [rbx+r12]
    
    .endFlags:
        mov     rsi, hexString
        call    lltoh
        mov     rsi, hexString
        mov     byte [rsi+rax], 0Ah
        inc     rax
        mov     rdi, 1
        mov     rdx, rax
        mov     rax, 1
        syscall
        add     r12, 4

    ;e_ehsize: 52byte(32), 64byte(64)
    mov     rdi, 1
    mov     rsi, sEhsize
    mov     rdx, 14
    mov     rax, 1
    syscall
    mov     di, word [rbx+r12]
    mov     [rbp-12h], di                    ;e_ehsize
    mov     rsi, hexString
    call    lltoh
    mov     rsi, hexString
    mov     byte [rsi+rax], 0Ah
    inc     rax
    mov     rdi, 1
    mov     rdx, rax
    mov     rax, 1
    syscall
    add     r12, 2

    ;e_phentsize: size program header
    mov     rdi, 1
    mov     rsi, sPhentsize
    mov     rdx, 22
    mov     rax, 1
    syscall
    mov     di, word[rbx+r12]
    mov     [rbp-14h], di                    ;e_phentsize
    mov     rsi, hexString
    call    lltoh
    mov     rsi, hexString
    mov     byte [rsi+rax], 0Ah
    inc     rax
    mov     rdi, 1
    mov     rdx, rax
    mov     rax, 1
    syscall
    add     r12, 2


    ;e_phnum: number program header
    mov     rdi, 1
    mov     rsi, sPhnum
    mov     rdx, 24
    mov     rax, 1
    syscall
    mov     di, word [rbx+r12]
    mov     [rbp-16h], di                   ;e_phnum
    mov     rsi, hexString
    call    lltoh
    mov     rsi, hexString
    mov     byte [rsi+rax], 0Ah
    inc     rax
    mov     rdi, 1
    mov     rdx, rax
    mov     rax, 1
    syscall
    add     r12, 2

    ;e_shentsize: size section header
    mov     rdi, 1
    mov     rsi, sShentsize
    mov     rdx, 15
    mov     rax, 1
    syscall
    mov     di, word [rbx+r12]
    mov     [rbp-18h], di                   ;e_shentsize
    mov     rsi, hexString
    call    lltoh
    mov     rsi, hexString
    mov     byte [rsi+rax], 0Ah
    inc     rax
    mov     rdi, 1
    mov     rdx, rax
    mov     rax, 1
    syscall
    add     r12, 2

    ;e_shnum: number section
    mov     rdi, 1
    mov     rsi, sShnum
    mov     rdx, 17
    mov     rax, 1
    syscall
    mov     di, word [rbx+r12]
    mov     [rbp-1Ah], di                       ;e_shnum
    mov     rsi, hexString
    call    lltoh
    mov     rsi, hexString
    mov     byte [rsi+rax], 0Ah
    inc     rax
    mov     rdi, 1
    mov     rdx, rax
    mov     rax, 1
    syscall
    add     r12, 2

    ;e_shstrndx
    mov     rdi, 1
    mov     rsi, sShstrndx
    mov     rdx, 36
    mov     rax, 1
    syscall
    mov     di, word [rbx+r12]
    mov     [rbp-1Ch], di                       ;e_shstrndx
    mov     rsi, hexString
    call    lltoh
    mov     rsi, hexString
    mov     byte [rsi+rax], 0Ah
    inc     rax
    mov     rdi, 1
    mov     rdx, rax
    mov     rax, 1
    syscall
    mov     rsi, hexString
    mov     rdx, 0
    call    println

    ; dq -8 	e_phoff
    ; dq -10    e_shoff
    ; dw -12	e_ehsize
    ; dw -14	e_phentsize
    ; dw -16	e_phnum
    ; dw -18	e_shentsize
    ; dw -1A	e_shnum
    ; dw -1C	e_shstrndx

    ;section header
    mov     rdi, 1
    mov     rsi, sSectionHeader
    mov     rdx, 16
    mov     rax, 1
    syscall
    mov     rdi, 1
    mov     rsi, sSectionHeaderTable
    mov     rdx, 3Dh
    mov     rax, 1
    syscall  

    ;sh_name
    mov     r12w, 0
    add     bx, [rbp-10h]              ;e_shoff
    mov     ax, [rbp-18h]               ;e_shentsize
    mov     r13w, [rbp-1Ch]             ;e_shstrndx
    mul     r13w
    mov     r13, rax
    add     r13, rbx                    ;r13 = &section contain name section
    .nextSection:
        cmp     r12w, [rbp-1Ah]         ;e_shnum
        jz      .endSectionHeader
        mov     edi, dword [rbx]        ;e_shoff
        cmp     byte [isELF32], 1
        jnz     .shname64
        .shname32:
            add     edi, [r13+10h]      ;sh_offset
            add     rdi, [filedata]     ;rdi=&sectioname
            jmp     .endEshoff

        .shname64:
            add     rdi, [r13+18h]
            add     rdi, [filedata]
        
        .endEshoff:
            mov     rsi, rdi
            mov     rdi, rsi
            call    strlen
            mov     rdi, 1
            mov     rdx, rax
            mov     r15, rax           ;r15=len
            mov     rax, 1
            syscall
    ;tab tab tab
    mov     rdi, 1
    mov     rsi, hexString
    mov     byte [rsi], 9
    mov     rax, 1
    mov     rdx, 1
    cmp     r15, 8
    jl      .moretab
    jmp     .printtab
    .moretab:
        mov     byte [rsi+rdx], 9
        inc     rdx
    .printtab:
        mov     rsi, hexString
        syscall    

    ;sh_type
    mov     edi, dword [rbx+4]
    mov     rsi, hexString
    call    lltoh
    mov     rsi, hexString
    mov     byte [rsi+rax], 9
    inc     rax
    mov     rdi, 1
    mov     rdx, rax
    mov     rax, 1
    syscall

    mov     r9, 08h
    ;sh_flags
    cmp     byte [isELF32], 1
    jnz     .shflags64
    .shflags32:
        mov     edi, dword [rbx+r9]
        jmp     .endshflag
    .shflags64:
        mov     rdi, qword [rbx+r9]
        add     r9, 4
    .endshflag:
        mov     rsi, hexString
        call    lltoh
        mov     rsi, hexString
        mov     byte [rsi+rax], 9
        inc     rax
        mov     rdi, 1
        mov     rdx, rax
        mov     rax, 1
        syscall
        add     r9, 4

    ;sh_addr
    cmp     byte [isELF32], 1
    jnz     .shaddr64
    .shaddr32:
        mov     edi, dword [rbx+r9]
        jmp     .endshaddr
    .shaddr64:
        mov     rdi, qword [rbx+r9]
        add     r9, 4
    .endshaddr:
        mov     rsi, hexString
        call    lltoh
        mov     rsi, hexString
        mov     byte [rsi+rax], 9
        inc     rax
        mov     rdi, 1
        mov     rdx, rax
        mov     rax, 1
        syscall
        add     r9, 4

    ;sh_offset
    cmp     byte [isELF32], 1
    jnz     .shoffset64
    .shoffset32:
        mov     edi, dword [rbx+r9]
        jmp     .endshoffset
    .shoffset64:
        mov     rdi, qword [rbx+r9]
        add     r9, 4
    .endshoffset:
        mov     rsi, hexString
        call    lltoh
        mov     rsi, hexString
        mov     byte [rsi+rax], 9
        inc     rax
        mov     rdi, 1
        mov     rdx, rax
        mov     rax, 1
        syscall
        add     r9, 4

    ;sh_size
    cmp     byte [isELF32], 1
    jnz     .shsize64
    .shsize32:
        mov     edi, dword [rbx+r9]
        jmp     .endshsize
    .shsize64:
        mov     rdi, qword [rbx+r9]
        add     r9, 4
    .endshsize:
        mov     rsi, hexString
        call    lltoh
        mov     rsi, hexString
        mov     byte [rsi+rax], 9
        inc     rax
        mov     rdi, 1
        mov     rdx, rax
        mov     rax, 1
        syscall
        add     r9, 4

    ;sh_link
    mov     edi, dword [rbx+r9]
    mov     rsi, hexString
    call    lltoh
    mov     rsi, hexString
    mov     byte [rsi+rax], 9
    inc     rax
    mov     rdi, 1
    mov     rdx, rax
    mov     rax, 1
    syscall
    add     r9, 4

    ;sh_info
    mov     edi, dword [rbx+r9]
    mov     rsi, hexString
    call    lltoh
    mov     rsi, hexString
    mov     byte [rsi+rax], 9
    inc     rax
    mov     rdi, 1
    mov     rdx, rax
    mov     rax, 1
    syscall
    add     r9, 4

    ;sh_addalign
    cmp     byte [isELF32], 1
    jnz     .shaddalign64
    .shaddalign32:
        mov     edi, dword [rbx+r9]
        jmp     .endshaddalign
    .shaddalign64:
        mov     rdi, qword [rbx+r9]
        add     r9, 4
    .endshaddalign:
        mov     rsi, hexString
        call    lltoh
        mov     rsi, hexString
        mov     byte [rsi+rax], 9
        inc     rax
        mov     rdi, 1
        mov     rdx, rax
        mov     rax, 1
        syscall
        add     r9, 4

    ;sh_entsize
    cmp     byte [isELF32], 1
    jnz     .shentsize64
    .shentsize32:
        mov     edi, dword [rbx+r9]
        jmp     .endshentsize
    .shentsize64:
        mov     rdi, qword [rbx+r9]
        add     r9, 4
    .endshentsize:
        mov     rsi, hexString
        call    lltoh
        mov     rsi, hexString
        mov     byte [rsi+rax], 0Ah
        inc     rax
        mov     rdi, 1
        mov     rdx, rax
        mov     rax, 1
        syscall
        add     r9, 4
        
    inc     r12w
    mov     di, [rbp-18h]               ;e_shentsize
    add     rbx, rdi
    jmp     .nextSection
    .endSectionHeader:
        mov     rsi, hexString
        mov     rdx, 0
        call    println

    ;program header
    mov     rdi, 1
    mov     rsi, sProgramHeader
    mov     rdx, 16
    mov     rax, 1
    syscall
    mov     rdi, 1
    mov     rsi, sProgramHeaderTable
    mov     rdx, 35h
    mov     rax, 1
    syscall

    mov     rbx, [filedata]
    add     rbx, [rbp-08h]              ;+e_phoff => program header
    mov     r12, 0

    .nextEntry:
        cmp     r12w, [rbp-16h]         ;e_phnum
        jz      .endProgramHeader

    ;p_type
    mov     edi, dword [rbx+0]
    mov     rsi, hexString
    call    lltoh
    mov     rsi, hexString
    mov     byte [rsi+rax], 9
    inc     rax
    mov     rdi, 1
    mov     rdx, rax
    mov     rax, 1
    syscall

    ;p_flags
    cmp     byte [isELF32], 1
    jnz     .pflag64
    .pflag32:
        mov     edi, dword [rbx+18h]
        jmp     .endpflag
    .pflag64:
        mov     edi, dword [rbx+04h]
    .endpflag:
        mov     rsi, hexString
        call    lltoh
        mov     rsi, hexString
        mov     byte [rsi+rax], 9
        inc     rax
        mov     rdi, 1
        mov     rdx, rax
        mov     rax, 1
        syscall

    ;p_offset
    cmp     byte [isELF32], 1
    jnz     .poffset64
    .poffset32:
        mov     edi, dword [rbx+04h]
        jmp     .endpoffset
    .poffset64:
        mov     rdi, qword [rbx+08h]
    .endpoffset:
        mov     rsi, hexString
        call    lltoh
        mov     rsi, hexString
        mov     byte [rsi+rax], 9
        inc     rax
        mov     rdi, 1
        mov     rdx, rax
        mov     rax, 1
        syscall

    ;p_vaddr
    cmp     byte [isELF32], 1
    jnz     .pvaddr64
    .pvaddr32:
        mov     edi, dword [rbx+08h]
        jmp     .endpvaddr
    .pvaddr64:
        mov     rdi, qword [rbx+10h]
    .endpvaddr:
        mov     rsi, hexString
        call    lltoh
        mov     rsi, hexString
        mov     byte [rsi+rax], 9
        inc     rax
        mov     rdi, 1
        mov     rdx, rax
        mov     rax, 1
        syscall

    ;p_paddr
    cmp     byte [isELF32], 1
    jnz     .ppaddr64
    .ppaddr32:
        mov     edi, dword [rbx+0Ch]
        jmp     .endppaddr
    .ppaddr64:
        mov     rdi, qword [rbx+18h]
    .endppaddr:
        mov     rsi, hexString
        call    lltoh
        mov     rsi, hexString
        mov     byte [rsi+rax], 9
        inc     rax
        mov     rdi, 1
        mov     rdx, rax
        mov     rax, 1
        syscall

    ;p_filesz
    cmp     byte [isELF32], 1
    jnz     .pfilesz64
    .pfilesz32:
        mov     edi, dword [rbx+10h]
        jmp     .endpfilesz
    .pfilesz64:
        mov     rdi, qword [rbx+20h]
    .endpfilesz:
        mov     rsi, hexString
        call    lltoh
        mov     rsi, hexString
        mov     byte [rsi+rax], 9
        inc     rax
        mov     rdi, 1
        mov     rdx, rax
        mov     rax, 1
        syscall

    ;p_memsz
    cmp     byte [isELF32], 1
    jnz     .pmemsz64
    .pmemsz32:
        mov     edi, dword [rbx+14h]
        jmp     .endpmemsz
    .pmemsz64:
        mov     rdi, qword [rbx+28h]
    .endpmemsz:
        mov     rsi, hexString
        call    lltoh
        mov     rsi, hexString
        mov     byte [rsi+rax], 9
        inc     rax
        mov     rdi, 1
        mov     rdx, rax
        mov     rax, 1
        syscall

    ;p_align
    cmp     byte [isELF32], 1
    jnz     .palign64
    .palign32:
        mov     edi, dword [rbx+18h]
        jmp     .endalign
    .palign64:
        mov     rdi, qword [rbx+30h]
    .endalign:
        mov     rsi, hexString
        call    lltoh
        mov     rsi, hexString
        mov     byte [rsi+rax], 0Ah
        inc     rax
        mov     rdi, 1
        mov     rdx, rax
        mov     rax, 1
        syscall

    inc     r12w
    mov     di, [rbp-14h]         ;e_phentsize
    add     rbx, rdi
    jmp     .nextEntry
    .endProgramHeader:              ;done parser
    
    .finish:
        ;free mem
        mov     rdi, [filedata]
        mov     rax, 12
        syscall
        ;close file
        mov     rdi, [fd]
        mov     rax, 3
        syscall
        mov     rdi, 0
        mov     rax, 60
        syscall 

    .erExit:
        mov     rdi, 1
        mov     rsi, sError
        mov     rdx, 14
        mov     rax, 1
        syscall
        mov     rdi, -1
        mov     rax, 60
        syscall 

lltoh:
    push    rbp
    mov     rbp, rsp
    mov     rax, rdi            ;number dec
    mov     rdi, rsi            ;hexString
    mov     r14, rdi            ;save rdi
    mov     r10, 16
    push    0h 

    .calc:
        xor     rdx, rdx
        div     r10
        cmp     rdx, 0ah
        jl      .addnumber
        add     edx, 37h        ;if a(10)-f(15) --> 'a'-'f'
        jmp     .save

    .addnumber:                 ;0-9 --> '0'-'9'
        add     edx, 30h

    .save:
        push    dx
        cmp     rax, 0
        jz      .popcalc
        jmp     .calc
    
    .popcalc:
        pop     ax
        cmp     ax, 0h 
        jz      .break
        stosb                   ;al=[edi++]
        jmp     .popcalc

    .break:
        sub     rdi, r14
        mov     rax, rdi        ;len 
        mov     rsp, rbp
        pop     rbp
        ret

strlen:             
    push    rbp
    mov     rbp, rsp
    xor     rax, rax

    ;rdi = &str
    ;ret: rax = len
    .nextchar:
        cmp     byte [rdi], 0ah
        jz      .break
        cmp     byte [rdi], 0
        jz      .break
        inc     rdi
        inc     rax
        jmp     .nextchar

    .break:
        mov     rsp, rbp
        pop     rbp
        ret

println:
    mov     al, 0ah
    mov     [rsi+rdx], al
    inc     rdx
    mov     rdi, 1
    mov     rax, 1
    syscall
    ret