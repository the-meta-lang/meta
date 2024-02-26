; Structure of a string
; - 0 - 4 bytes: Length of the string
; - 4 - n bytes: Characters of the string

; Retrieve the length of a string
; Input:
; - [ebp - 4] (edi): Pointer to the string (mm32)
; Output:
; - al: Length of the string (imm8)
get_string_length:
		; Get the length of the string
		xor eax, eax
		mov al, [edi]
		ret

; Get a pointer to the data portion of a string
; Input:
; - [ebp - 4] (edi): Pointer to the string (mm32)
; Output:
; - eax: Pointer to the data portion of the string (mm32)
get_string_pointer:
		; Get the length of the string
		mov eax, edi
		add eax, 1
		ret