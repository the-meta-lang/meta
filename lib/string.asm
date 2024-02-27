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

