; startup.asm
; Bootsector will search for, load from disk, and execute this program
; Print "Hello, World!"

bits 16

org 0x100
    mov si, msghi
    call printsi

    mov ax, 0B800h
    mov es, ax
    xor di, di
    mov ax, 0720h
    mov cx, 2000
    rep stosw

    mov ax, 40h
    mov es, ax
    
    mov dl, [es:84h]
    push dx

    mov dl, [es:4Ah]
    push dx

    mov cx, 1
    call printcx
    mov si, x
    call printsi
    mov cx, 1
    call printcx

    jmp halt

halt:
    hlt
    jmp halt

msghi db "Hello, World!", 13, 10, 0
msghalt db "Program halted!", 13, 10, 0
x db "x", 0
break db 13, 10, 0

%include "src/print.asm"
%include "src/data.asm"