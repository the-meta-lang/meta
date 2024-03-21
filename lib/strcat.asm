; Get the length of a string
; Input:
;	esi - pointer to the string
; Output:
;	eax - length of the string
; Modified:
;	ecx
strlen:
	xor ecx, ecx
	.loop:
		mov al, [esi + ecx]
		test al, al
		jz .loop_end
		inc ecx
		jmp .loop
	.loop_end:
	mov eax, ecx
	ret

; Concatenate two strings
; Input:
;	esi - pointer to the first string
;	edi - pointer to the second string
; Output:
;	eax - pointer to the concatenated string
strcat:
	; Sum up the length of both strings and malloc enough space for the newly generated string.
	; The length of the first string is stored in ecx, the length of the second string is stored in edx.
	; The length of the concatenated string is stored in ecx.
	push edi
	push esi
	call strlen
	mov ebx, eax
	mov esi, edi
	call strlen
	mov edx, eax
	add ebx, edx
	inc ebx
	; Allocate memory for the concatenated string
	mov esi, ebx
	call malloc
	; Copy the first string to the beginning of the newly allocated memory
	xor ecx, ecx
	mov edi, eax
	pop esi ; Get string1
	.loop1:
		mov al, [esi]
		test al, al
		jz .loop1_end
		mov [edi+ecx], al
		inc ecx
		inc esi
		jmp .loop1
	.loop1_end:
	; Copy the second string to the end of the first string
	pop esi ; Get string2
	.loop2:
		mov al, [esi]
		test al, al
		jz .loop2_end
		mov [edi+ecx], al
		inc ecx
		inc esi
		jmp .loop2
	.loop2_end:
	; Null-terminate the concatenated string
	mov byte [edi+ecx], 0x00
	; Return the pointer to the concatenated string
	mov eax, edi
	ret
