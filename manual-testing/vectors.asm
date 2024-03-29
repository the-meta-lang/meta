section .bss
	vector resb 32
section .text
global _start

; Push into a vector
; Usage: vector_push vector, value
; edi: vector (mm32)
; esi: value (imm32)
vector_push:
	mov eax, edi
	; Get the length of the vector
	mov ebx, [eax]
	; Add the length to the pointer to set the value
	add eax, ebx
	add eax, 4
	; Set the value
	mov dword [eax], esi
	; Increment the length
	add ebx, 4
	mov eax, edi
	mov [eax], ebx
	ret

; Pop from a vector
; Usage: vector_pop vector
; esi: vector (mm32)
; @return eax (imm32) - The number that was popped
vector_pop:
	mov eax, esi
	; Get the length of the vector
	mov ebx, [eax]
	; Get the old value
	mov ecx, [eax + ebx]
	; Subtract the length to the pointer to get the value
	; Set the value to 0
	add eax, ebx
	mov dword [eax], 0
	; Decrement the length
	sub ebx, 4
	mov eax, esi
	mov [eax], ebx

	mov eax, ecx
	ret

; Push a string into a vector
; Usage: call vector_push_string_mm32
; input:
; edi - vector (mm32)
; esi - string (mm32)
vector_push_string_mm32:
		push ecx
		push ebx
		; Get the length of the vector and get our entrypoint where we're going to push to
		mov eax, edi
		mov ebx, dword [eax]
		add eax, ebx
		; Add 4 byte to skip the length indicator
		add eax, 4
		; Initialize our loop counter
		xor ecx, ecx
	.loop:
		; Get the current character in the string
		mov bl, byte [esi + ecx]
		; Set the value
		mov byte [eax], bl
		; Increment the pointer
		inc eax
		; Increment the loop counter
		inc ecx
		; We can move the null terminator comparison to the end
		; That way we can write the null terminator immediately instead of having to do it after the loop
		cmp bl, 0
		je .end
		jmp .loop
	.end:
		; Add the length of the string to the length of the vector
		mov eax, edi
		add dword [eax], ecx
		; Restore altered registers
		pop ebx
		pop ecx
		ret


; Pop a string from a vector
; Usage: call vector_pop_string
; esi: vector (mm32)
; @return eax (*string) - The popped string
vector_pop_string:
	section .bss
		.string resb 256
	section .text
		push ebx
		push edx
		push ecx
		mov eax, esi
		; Get the length of the vector
		mov ebx, dword [eax]
		; Add the length to the pointer to set the value
		add eax, ebx
		add eax, 4 ; Add the offset for the first 4 bytes that indicate the length

		; We're now at the end of the vector
		; Since the string itself is null-terminated, we will find two consecutive null terminators.
		; One for the string, and one for the vector itself.
		; We need to skip both

		; Read in reverse order to find the null terminator
		; Write the initial null terminator into the result string already so we don't accidentally read more than we should if the following memory has content
		mov byte [.string + 255], 0x00
		mov ecx, 2 ; Skip the initial null terminator
		.loop:
			; Set the value
			mov ebx, eax
			sub ebx, ecx
			mov edx, esi
			add edx, 3
			cmp ebx, edx
			je .end ; Pre-terminate if we've reached the beginning of the array

			mov bl, byte [ebx] ; Get the value
			cmp bl, 0 ; Check if the value is the null terminator
			je .end

			mov edx, .string + 256 ; Copy the value into the output string
			sub edx, ecx
			mov byte [edx], bl

			mov ebx, eax
			sub ebx, ecx
			mov byte [ebx], 0 ; Clear the value
			inc ecx
			jmp .loop
		.end:
		; Set the length to the length of the string
		mov eax, esi
		sub dword [eax], ecx
		add dword [eax], 1
		; Return the string
		mov eax, .string
		add eax, 256
		sub eax, ecx
		add eax, 1
		; Restore altered registers
		pop ecx
		pop edx
		pop ebx
		ret

; Reverses the last n elements of a vector
; Input
; edi: vector (mm32)
; esi: n (imm32)
vector_reverse_n_string:
	section .bss
		.tmpvector resb 32
		.tmpstring resb 32
	section .text
		push edi
		; We're going to pop n elements from the array and write them into a temporary array
		; Then we're going to push them back into the original array in reverse order

		; Pop n elements from the array
		mov ebx, esi ; store n in ebx
		xor ecx, ecx ; reset the counter
	.loop_out:
		cmp ecx, ebx ; cmp counter with n
		je .loop_out_end ; if counter == n, end the loop
		push edi
		mov esi, edi
		call vector_pop_string
		; Write into the tmpvector
		mov esi, eax
		mov edi, .tmpvector
		call vector_push_string_mm32
		inc ecx ; increment the counter
		pop edi
		jmp .loop_out
	.loop_out_end:
		; The size of the elements doesn't change when we pop them out
		; the old array, so we can just copy the data from .tmpvector
		; into the vector in edi and add the 2 lengths together after the fact.
		mov edx, dword [.tmpvector] ; get the length from our tmpdata
		xor ecx, ecx ; clear the counter
		; vector still in edi
		add edi, dword [edi] ; move to the end of the array
		add edi, 4 ; add 4 byte to skip the length (dword)
		mov esi, .tmpvector
		add esi, 4 ; add 4 byte to skip the length (dword)
		xor eax, eax
	.copy:
		cmp edx, ecx
		je .end_copy
		mov al, byte [esi+ecx]
		mov byte [edi+ecx], al
		inc ecx
		jmp .copy
	.end_copy:
		pop edi
		; add the length to the original vector
		mov eax, edi
		add dword [eax], edx
		ret

section .data
	string db "Hello", 0x00

section .text
	_start:
		mov edi, vector
		mov esi, string
		call vector_push_string_mm32
		mov edi, vector
		mov esi, string
		call vector_push_string_mm32
		mov edi, vector
		mov esi, string
		call vector_push_string_mm32

		mov esi, vector
		call vector_pop_string
		mov esi, vector
		call vector_pop_string
		mov esi, vector
		call vector_pop_string

		mov edi, vector
		mov esi, string
		call vector_push_string_mm32
		mov eax, 1
		mov ebx, 0
		int 0x80