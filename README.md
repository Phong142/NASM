Nasm linux x84 and x64  
Code vẫn còn thiếu nhiều phần, ai phát hiện ra bug thì báo giúp mình với nhé =)))
- nasm64:   
    nasm -f elf64 <filename>.asm   
    ld -m elf_x86_64 -s -o <name> <name>.o    
    ./<name>   
- nasm32:
    nasm -f elf <filename>.asm ---   
    ld -m elf_i386 <name>.o -o <name>    
    ./<name>   
