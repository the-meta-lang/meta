section .bss
	vector1 resb 32
	vector2 resb 32
section .text

global _start

; Push a string into a vector
; Usage: call vector_push_string_mm32
; input:
; edi - vector (mm32)
; esi - string (mm32)
vector_push_string_mm32:
		push ecx
		push ebx
		push edx
		mov eax, esi
		xor ecx, ecx
	.loop_length:
		cmp byte [eax + ecx], 0
		je .end_length
		inc ecx
		jmp .loop_length
	.end_length:
		mov eax, edi
		; Get the length of the vector
		mov ebx, [eax]
		; Add the length to the pointer to set the value
		add eax, ebx
		add eax, 4
		
		; loop through the string and push each character
		mov edx, 0
	.loop:
		cmp edx, ecx
		je .end
		; Set the value
		mov ebx, esi
		add ebx, edx

		mov bl, byte [ebx]

		mov byte [eax], bl
		add eax, 1

		inc edx
		jmp .loop
	.end:
		; Increment the length
		mov ebx, [edi]
		add ebx, ecx
		add ebx, 1

		mov eax, edi
		mov [eax], ebx
		pop edx
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
		mov ebx, [eax]
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
	string1 db "Hey", 0x00
	string2 db "there", 0x00
	string3 db "!", 0x00

section .text
_start:
	mov edi, vector1
	mov esi, string1
	call vector_push_string_mm32

	mov esi, string2
	call vector_push_string_mm32

	mov esi, string3
	call vector_push_string_mm32

	mov edi, vector1
	mov esi, 2
	call vector_reverse_n_string

	mov esi, vector1
	call vector_pop_string