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

printcx:
	pop ax
	add al, '0'
	mov ah, 0x0E
.loop:
	int 0x10
	loop .loop
	ret


hexbytecx:
	mov bx, xlat_hex

.loop:
	mov al, [si]
	mov ah, al

	shr al, 4
	xlat
	mov [di], al
	inc di

	mov al, ah
	and al, 0Fh
	xlat
	mov [di], al
	inc di

	inc si
	loop .loop

	mov byte [di], 0
	ret