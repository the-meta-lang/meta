
; Copies the value of a pointer to a buffer specified in edi
; to the buffer specified in esi
; Input
;   edi - pointer to source buffer
;   esi - pointer to destination buffer
; Output
;   eax - length of the string
buffc:
		push ebp
		mov ebp, esp
		xor ecx, ecx ; Keep track of the length so we can return it
	.loop:
		mov al, byte [edi]
		mov byte [esi], al
		cmp al, 0
		je .done
		inc edi
		inc esi
		inc ecx
		jmp .loop
	.done:
		mov eax, ecx
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
; Output
;   eax - length of the string
inttostr:
		push ebp
		mov ebp, esp

		mov eax, esi
		cmp eax, 0
		je .zero
		xor ecx, ecx ; Clear the counter
		xor esi, esi ; Clear the length
		jmp .divide_loop
	.zero:
		mov ecx, 1
		mov esi, 1
		push 0x30
		jmp .copy_loop
	.divide_loop:
		cmp eax, 0
		je .copy_loop
		mov edx, 0
		mov ebx, 10
		div ebx
		add edx, 0x30
		push edx
		inc ecx ; Increment the counter for every new digit we add
		inc esi
		jmp .divide_loop
	.copy_loop:
		cmp ecx, 0
		je .done
		pop eax ; Pop the next digit off the stack

		mov ebx, edi ; Move the destination buffer to ebx
		add ebx, esi ; Move to the end of the buffer
		sub ebx, ecx ; Move back to the current position
		mov byte [ebx], al ; Move the digit to the buffer
		dec ecx ; Decrement the counter
		jmp .copy_loop
	.done:
		add edi, esi
		mov byte [edi], 0 ; Null terminate the string
		mov eax, esi ; Return the length of the string
		mov esp, ebp
		pop ebp
		ret

; Get the length of a null terminated string
; Input
;   esi - pointer to the string
; Output
;   eax - length of the string
length:
		push ebp
		mov ebp, esp
		xor eax, eax
	.loop:
		mov al, byte [esi]
		cmp al, 0
		je .done
		inc esi
		inc eax
		jmp .loop
	.done:
		mov esp, ebp
		pop ebp
		ret