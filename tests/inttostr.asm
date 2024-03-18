section .data
		number dd -10

section .bss
		dest resb 10

section .text
global _start

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
		xor ecx, ecx ; Clear the counter
		xor esi, esi ; Clear the length
		test eax, eax
		js .negative
		jmp .divide_loop
	.negative:
		; We need to print a negative sign
		mov byte [edi], 0x2D
		inc edi
		inc ecx
		inc esi
		; Then we need to print the number as negative
		neg eax
	.divide_loop:
		cmp eax, 0
		je .copy_loop
		mov edx, 0
		mov ebx, 10
		div ebx
		add edx, 0x30
		push edx
		inc ecx ; Increment the counter for every new digit we add
		inc esi ; Increment the length as well
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
		add edi, esi ; Move the destination pointer to the end of the string
		mov byte [edi], 0 ; Null terminate the string
		mov eax, esi ; Return the length
		mov esp, ebp
		pop ebp
		ret

_start:
		mov esi, dword [number]
		mov edi, dest
		call inttostr

		mov eax, 1
		mov ebx, 0
		int 0x80