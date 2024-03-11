
; Copies the value of a pointer to a buffer specified in edi
; to the buffer specified in esi
; Input
;   edi - pointer to source buffer
;   esi - pointer to destination buffer
buffc:
		push ebp
		mov ebp, esp
	.loop:
		mov al, byte [edi]
		mov byte [esi], al
		cmp al, 0
		je .done
		inc edi
		inc esi
		jmp .loop
	.done:
		mov esp, ebp
		pop ebp
		ret

; Copies the value of a pointer to a buffer specified in edi
; to the buffer specified in esi. Will first move to the end of the destination buffer.
; Input
;   edi - pointer to source buffer
;   esi - pointer to destination buffer
buffcend:
		push ebp
		mov ebp, esp
	.loop:
		mov al, byte [edi]
		cmp al, 0
		je .done
		inc edi
		jmp .loop
	.done:
		call buffc
		mov esp, ebp
		pop ebp
		ret

; Converts an integer to a string
; Input
;   esi - integer to convert
;   edi - pointer to destination buffer
inttostr:
		push ebp
		mov ebp, esp

		xor ecx, ecx ; Clear the counter
		xor eax, eax ; Clear the length
	.divide_loop:
		cmp esi, 0
		je .copy_loop
		mov edx, 0
		mov ebx, 10
		div ebx
		add edx, 0x30
		push edx
		inc ecx ; Increment the counter for every new digit we add
		inc eax
		jmp .divide_loop
	.copy_loop:
		cmp ecx, 0
		je .done
		dec ecx ; Decrement the counter
		pop al ; Pop the next digit off the stack

		mov ebx, edi ; Move the destination buffer to ebx
		add ebx, eax ; Move to the end of the buffer
		sub ebx, ecx ; Move back to the current position
		mov byte [ebx], al ; Move the digit to the buffer
		jmp .copy_loop
	.done:
		mov byte [edi + eax], 0 ; Null terminate the string
		mov esp, ebp
		pop ebp
		ret