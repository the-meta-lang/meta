; Tests whether the current char in `input_string` is greater or equal to `edi`
; Inputs
;		edi - the character to compare to
; Output:
;	 	eax - 1 if the current char is greater or equal to `edi`, 0 otherwise
test_char_greater_equal:
		call input_blanks
		push edx
		mov edx, input_string
		add edx, [input_string_offset]

		xor eax, eax
		mov al, byte [edx]

		cmp eax, edi
		jge .greater_equal

		; if the current char is less than `edi`, return 0
		mov byte [eswitch], 1
		mov byte [pflag], 0
		jmp .done
	.greater_equal:
		; if the current char is greater or equal to `edi`, return 1
		mov byte [eswitch], 0
		mov byte [pflag], 1
	.done:
		pop edx
		ret

; Tests whether the current char in `input_string` is less or equal to `edi`
; Inputs
;		edi - the character to compare to
; Output:
;	 	eax - 1 if the current char is less or equal to `edi`, 0 otherwise
test_char_less_equal:
		call input_blanks
		push edx
		mov edx, input_string
		add edx, [input_string_offset]

		xor eax, eax
		mov al, byte [edx]

		cmp eax, edi
		jle .less_equal

		; if the current char is greater than `edi`, return 0
		mov byte [eswitch], 1
		mov byte [pflag], 0
		jmp .done
	.less_equal:
		; if the current char is less or equal to `edi`, return 1
		mov byte [eswitch], 0
		mov byte [pflag], 1
	.done:
		pop edx
		ret

; If the parse flag is set to 1 it will scan the input character
; If the token flag is set to 1 it will add the character to the token
; Inputs:
;		edi - the character to compare to
; Outputs:
;		- none
scan_or_parse:
		call input_blanks
		; If the parse flag is not set we encountered an error during parsing.
		; we're done here...
		cmp byte [pflag], 1
		jne .done
		cmp byte [tflag], 1
		jne .done_error

		; if the token flag is set, add the character to the token
		push edx
		mov edx, input_string
		add edx, [input_string_offset]

		xor eax, eax
		mov al, byte [edx]

		mov edx, last_match
	.loop:
		cmp byte [edx], 0
		je .done_loop
		inc edx
		jmp .loop
	.done_loop:
		mov byte [edx], al
		; null terminate the token
		mov byte [edx+1], 0x00
		add word [input_string_offset], 1
		pop edx
		mov byte [eswitch], 0
	.done:
		ret
	.done_error:
		mov byte [eswitch], 1
		ret