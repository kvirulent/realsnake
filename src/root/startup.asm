; startup.asm
; Bootsector will search for, load from disk, and execute this program
; Print "Hello, World!"

bits 16

org 0x100
    mov si, msghi
    call printsi
.1:
    call kbpopascii
    push ax
    mov si, sp
    call printsi
    pop ax
    jmp .1

halt:
    hlt
    jmp halt

msghi db "Hello, World!", 13, 10, 0
msghalt db "Program halted!", 13, 10, 0
x db "x", 0
break db 13, 10, 0

%include "src/print.asm"
%include "src/data.asm"
%include "src/keyprocess.asm"