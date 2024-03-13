; Tests whether the current char in `input_string` is greater or equal to `edi`
; Inputs
;		edi - the character to compare to
; Output:
;	 	eax - 1 if the current char is greater or equal to `edi`, 0 otherwise
test_char_greater_equal:
		push edx
		mov edx, input_string
		add edx, [cursor]

		xor eax, eax
		mov al, byte [edx]

		cmp eax, edi
		jge .greater_equal

		; if the current char is less than `edi`, return 0
		mov byte [eswitch], 1
		jmp .done
	.greater_equal:
		; if the current char is greater or equal to `edi`, return 1
		mov byte [eswitch], 0
	.done:
		pop edx
		ret

; Tests whether the current char in `input_string` is less or equal to `edi`
; Inputs
;		edi - the character to compare to
; Output:
;	 	eax - 1 if the current char is less or equal to `edi`, 0 otherwise
test_char_less_equal:
		push edx
		mov edx, input_string
		add edx, [cursor]

		xor eax, eax
		mov al, byte [edx]

		cmp eax, edi
		jle .less_equal

		; if the current char is greater than `edi`, return 0
		mov byte [eswitch], 1
		jmp .done
	.less_equal:
		; if the current char is less or equal to `edi`, return 1
		mov byte [eswitch], 0
	.done:
		pop edx
		ret

; Tests whether the current char in `input_string` is equal to `edi`
; Inputs
;		edi - the character to compare to
; Output:
;	 	eax - 1 if the current char is less or equal to `edi`, 0 otherwise
test_char_equal:
		push edx
		mov edx, input_string
		add edx, [cursor]

		xor eax, eax
		mov al, byte [edx]

		cmp eax, edi
		je .equal

		; if the current char is greater than `edi`, return 0
		mov byte [eswitch], 1
		jmp .done
	.equal:
		; if the current char is less or equal to `edi`, return 1
		mov byte [eswitch], 0
	.done:
		pop edx
		ret


; If the parse flag is set to 1 it will scan the input character
; If the token flag is set to 1 it will add the character to the token
; Inputs:
;		edi - the character to compare to
; Outputs:
;		- none
; Implements following method:
; if (flag) {
; 	// if taking token, add to token 
; 	if (tokenflag) token = token + inbuf.charAt(inp) ;
; 	// scan the character 
; 	inp++ ;
; };
scan_or_parse:
		; If the parse flag is not set we encountered an error during parsing.
		; we're done here...
		cmp byte [eswitch], 1
		je .done_error
		cmp byte [tflag], 1
		jne .done

		; if the token flag is set, add the character to the token
		push edx
		mov edx, input_string
		add edx, [cursor]

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
		add dword [cursor], 1
		pop edx
		mov byte [eswitch], 0
		ret
	.done:
		add dword [cursor], 1
		ret
	.done_error:
		ret

; Clears the last_match variable to all zeros
clear_token:
		push edx
		mov edx, last_match
	.loop:
		cmp byte [edx], 0
		je .done
		mov byte [edx], 0
		inc edx
		jmp .loop
	.done:
		pop edx
		ret
