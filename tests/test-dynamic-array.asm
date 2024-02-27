section .bss
	; Define a vector
	; Structure:
	;   - 0: length (mm32)
	;   - 4 - 256: data (mm32)
	vector resb 256

section .text
	global _start

%macro save_machine_state 0
		pushfd ; Save the flags register
		push ebp ; Save the base pointer
		push eax
		push ebx
		push ecx
		push edx
		push edi
%endmacro

%macro restore_machine_state 0
		pop edi
		pop edx
		pop ecx
		pop ebx
		pop eax
		pop ebp ; Restore the base pointer
		popfd ; Restore the flags register
%endmacro

; Push into a vector
; Usage: vector_push vector, value
; %1: vector (mm32)
; %2: value (imm32)
%macro vector_push 2
	mov eax, %1
	; Get the length of the vector
	mov ebx, [eax]
	; Add the length to the pointer to set the value
	add eax, ebx
	add eax, 4
	; Set the value
	mov dword [eax], %2
	; Increment the length
	add ebx, 4
	mov eax, %1
	mov [eax], ebx
%endmacro

; Pop from a vector
; Usage: vector_pop vector
; %1: vector (mm32)
; @return eax
%macro vector_pop 1
	mov eax, %1
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
	mov eax, %1
	mov [eax], ebx

	mov eax, ecx
%endmacro

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
; @return eax (mm32)
vector_pop_string:
	section .bss
		.string resb 256
	section .text
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
		mov eax, .string
		add eax, 256
		sub eax, ecx
		add eax, 1
		pop ecx
		pop edx
		pop ebx
		ret

; Structure of a string
; - 0 - 4 bytes: Length of the string
; - 4 - n bytes: Characters of the string

; Retrieve the length of a string
; Input:
; - [ebp - 4] (edi): Pointer to the string (mm32)
; Output:
; - eax: Length of the string (imm32)
get_string_length:
	; Get the length of the string
	mov eax, 0
	.loop:
		mov al, byte [edi + eax]
		test al, al
		jz .end
		inc eax
		jmp .loop
	.end:
	ret

%macro create_string 1
	section .data
		%%string db %1, 0x00
	section .text
		mov eax, %%string
%endmacro

_start:
		mov eax, 1
    ; Test input against string
		vector_push_string vector, "Hi"
		vector_push_string vector, "AWD"
		mov eax, 4
		mov edi, vector
		call vector_pop_string
		call vector_pop_string


    ; Exit
		mov eax, 0x01
		mov ebx, 0x00
    int 0x80