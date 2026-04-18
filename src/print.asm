; printsi
; Print bytes from the source index to the teletype output until a null terminator is encountered.
; Expects:	SI	Pointer to a null-terminated series of bytes/characters to print
;
; Returns: 	DF	Not Preserved
;			AX	Not Preserved
;			BX	Not Preserved

printsi:
	cld
	mov ah, 0x0E
	mov bx, 7

.next:
	lodsb
	test al, al
	jz .done
	int 0x10
	jmp .next

.done:
	ret

; printcx
; Print cx number of bytes from the source index to the teletype output
; Expects:	CX	The amount of bytes to print
;			SI 	Pointer to a series of bytes/characters to print
;
; Returns:	CX	Not Preserved
;			AX	Not Preserved

printcx:
	add al, '0'
	mov ah, 0x0E
.loop:
	int 0x10
	loop .loop
	ret