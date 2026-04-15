; kbpeekkey
; Check if a key is in the BIOS keyboard buffer.
; Returns:	AX	Not preserved
;			ZF	ZR = no keys
;				NZ = key available in buffer
;			AH	(if NZ) key scan code
;			AL 	(if NZ) key ascii code

kbpeekkey:
	mov ah, 01h
	int 16h
	ret

; kbpopkey
; Pop a key from the BIOS keyboard buffer, if one is available.
; Returns:	AX	Not Preserved
;			ZF	Not Preserved
;			AH 	key scan code, if a key was returned
;			AL 	key ascii code, if a key was returned

kbpopkey:
	call kbpeekkey
	jnz .key
	mov ax, 0
	ret
.key
	mov ah, 00h
	int 16h
	ret

; kbpopascii
; Pop a key from the BIOS keyboard buffer, if one is available, and return only the ASCII code.
; Returns:	AX	Not Preserved
;			ZF	Not Preserved
;			AL  key ascii code, if a key was returned

kbpopascii:
	call kbpopkey
	mov ah, 0
	ret