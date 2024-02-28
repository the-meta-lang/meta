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
; @return edi
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

	mov edi, ecx
	ret

; Push a string into a vector
; Usage: vector_push_string vector, value
; %1: vector (mm32)
; %2: value (string)
%macro vector_push_string 2
		create_string %2
		mov esi, eax
		mov edi, %1
		call vector_push_string_mm32
%endmacro

; Push a string into a vector
; Usage: call vector_push_string_mm32
; input:
; edi - vector (mm32)
; esi - string (mm32)
vector_push_string_mm32:
	save_machine_state
	mov eax, esi
	mov ecx, 0
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
		restore_machine_state
		ret


; Pop a string from a vector
; Usage: call vector_pop_string
; edi: vector (mm32)
; @return edi (mm32)
vector_pop_string:
	section .bss
		.string resb 256
	section .text
		pushfd
		push eax
		push ebx
		push edx
		push ecx
		mov eax, edi
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
			mov edx, edi
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
		mov eax, edi
		sub dword [eax], ecx
		add dword [eax], 1
		; Return the string
		mov edi, .string
		add edi, 256
		sub edi, ecx
		add edi, 1
		; Restore altered registers
		pop ecx
		pop edx
		pop ebx
		pop eax
		popfd
		ret