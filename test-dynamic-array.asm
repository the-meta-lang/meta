section .bss
	; Define a vector
	; Structure:
	;   - 0: length (mm32)
	;   - 4 - 256: data (mm32)
	vector resb 256

section .text
	global _start

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
	section .data
		%strlen string_len %2
		%%string db string_len, %2, 0

	section .text
		vector_push_string_mm32 %1, %%string
%endmacro

%macro vector_push_string_mm32 2
	save_machine_state
	xor ecx, ecx
	mov cl, byte [%2] ; Get the string length
	add cl, 1 ; Add 1 byte for the initial length attribute
	mov eax, %1
	; Get the length of the vector
	mov ebx, [eax]
	; Add the length to the pointer to set the value
	add eax, ebx
	add eax, 4
	
	; loop through the string and push each character
	mov edx, 0
	%%_loop:

		cmp edx, ecx
		je %%_end
		; Set the value
		mov ebx, %2
		add ebx, edx

		mov bl, byte [ebx]

		mov byte [eax], bl
		add eax, 1

		inc edx
		jmp %%_loop
	%%_end:
	; Increment the length
	mov ebx, [%1]
	add ebx, ecx
	add ebx, 1

	mov eax, %1
	mov [eax], ebx
	restore_machine_state
%endmacro

%macro vector_push_string_mm32_no_length 2
	save_machine_state
	mov eax, %2
	mov ecx, 0
%%_loop_length:
	cmp byte [eax + ecx], 0
	je %%_end_length
	inc ecx
	jmp %%_loop_length
%%_end_length:
	add ecx, 1 ; Add 1 byte for the initial length attribute
	mov eax, %1
	; Get the length of the vector
	mov ebx, [eax]
	; Add the length to the pointer to set the value
	add eax, ebx
	add eax, 4
	mov byte [eax], cl
	
	; loop through the string and push each character
	mov edx, 0
	%%_loop:

		cmp edx, ecx
		je %%_end
		; Set the value
		mov ebx, %2
		add ebx, edx

		mov bl, byte [ebx]

		mov byte [eax], bl
		add eax, 1

		inc edx
		jmp %%_loop
	%%_end:
	; Increment the length
	mov ebx, [%1]
	add ebx, ecx
	add ebx, 1

	mov eax, %1
	mov [eax], ebx
	restore_machine_state
%endmacro

; Pop a string from a vector
; Usage: vector_pop_string vector
; %1: vector (mm32)
; @return eax (mm32)
%macro vector_pop_string 1
	section .bss
		%%string resb 256
	section .text
		mov eax, %1
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
		mov ecx, 2 ; Skip the initial null terminator
		%%_loop:
			; Set the value
			mov ebx, eax
			sub ebx, ecx
			cmp ebx, %1 + 3
			je %%end ; Pre-terminate if we've reached the beginning of the array

			mov bl, byte [ebx] ; Get the value
			cmp bl, 0 ; Check if the value is the null terminator
			je %%end

			mov edx, %%string + 256 ; Copy the value into the output string
			sub edx, ecx
			mov byte [edx], bl

			mov ebx, eax
			sub ebx, ecx
			mov byte [ebx], 0 ; Clear the value
			inc ecx
			jmp %%_loop
		%%end:
		; Set the length to the length of the string
		mov eax, %1
		sub dword [eax], ecx
		add dword [eax], 1
		; Return the string
		mov eax, %%string
		add eax, 256
		sub eax, ecx
		add eax, 1
%endmacro


_start:
		mov eax, 1
    ; Test input against string
		vector_push_string vector, "Hi"
		mov eax, 4
		vector_pop_string vector


    ; Exit
		mov eax, 0x01
		mov ebx, 0x00
    int 0x80