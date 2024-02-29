
; Converts a string to an integer
; Input: esi = address of string
; Output: eax = integer
string_to_int:
		pushfd
		push ecx
		push edi
		push edx
		; We need to get the length of the string first and then iterate through it backwards
		; Otherwise the number would be reversed
		; We will store the length in ecx
		xor ecx, ecx
	.length_loop:
		mov al, [esi + ecx] ; Get the current character
		cmp al, 0 ; Check for null terminator
		je .done_length
		inc ecx
		jmp .length_loop
	.done_length:
		mov edi, esi ; Get the current character
		add edi, ecx ; Move edi to the end of the string
		; We will store the result in edx
		xor edx, edx
		xor ecx, ecx
	.loop:
		xor eax, eax
		dec edi ; Move edi backwards
		cmp edi, esi ; Check if we have reached the end of the reversed string (aka beginning)
		jl .done
		mov al, [edi]
		; Check if the character is a digit
		cmp al, "0" ; Check if below zero
		jl .skip
		cmp al, "9" ; Check if above nine
		jg .skip

		sub al, "0" ; Convert from ASCII to integer
		; Multiply al by 10 * counter except if the counter is 0, then multiply by 1
		cmp ecx, 0
		je .done_mul
		mov ebx, eax
		mov eax, 10
		; exponent is already in ecx
		call pow
		imul ebx, eax
		mov eax, ebx
		jmp .done_mul
	.done_mul:
		; Add al to eax
		add edx, eax
		inc ecx
		
		jmp .loop
	.skip:
		jmp .loop
	.done:
		; And move the result into eax in the end
		mov eax, edx
		pop edx
		pop edi
		pop ecx
		popfd
		ret

; Calculates the power of two integers
; Input: eax = base, ecx = exponent
pow:
		push ebx
		push edx
		mov edx, eax
		; If the exponent is 0, the result is 1
		cmp ecx, 0
		je .done
		; If the exponent is 1, the result is the base
		cmp ecx, 1
		je .done
		; Otherwise we will calculate the result
		; We will store the result in edx
		xor edx, edx
		; We will use ebx as a counter
		xor ebx, ebx
		; We will use ecx as a counter
		mov edx, eax
		inc ebx
	.loop:
		cmp ebx, ecx
		je .done
		imul edx, eax
		inc ebx
		jmp .loop
	.done:
		mov eax, edx
		pop edx
		pop ebx
		ret