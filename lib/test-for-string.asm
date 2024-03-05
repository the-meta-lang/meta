test_for_string:
		call input_blanks
		mov esi, input_string
		add esi, [input_string_offset]
		mov ecx, 0

		cmp byte [esi], '"'
		je  .test_rest_chars_loop
		jmp .not_matching
		; Manual string comparison loop

	.test_rest_chars_loop:
			; Load the next byte from [esi] into AL, incrementing esi
			lodsb
			; Move the char into last_match at the current index
			mov ebx, last_match
			add ebx, ecx
			mov byte [ebx], al
			; Add a null terminator
			add ebx, 1
			mov byte [ebx], '"'
			add ebx, 1
			mov byte [ebx], 0x00
			inc ecx

			cmp byte [esi], '"'       ; Check for space
			je  .end_of_string       ; If space is reached, end the loop
			cmp byte [esi], 0
			je .end_of_string ; TODO: Maybe terminate?

			; Otherwise match the next chars
			jmp .test_rest_chars_loop

	.not_matching:
			; Strings are not equal
			mov byte [eswitch], 1
			jmp .end

	.end_of_string:
			; Add the length of the match and 2 characters for the quotes
			add ecx, 1
			add [input_string_offset], ecx
			mov byte [eswitch], 0

	.end:
			ret

; Tests the input string for a string ("[...]")
; but unlike test_for_string, it doesn't copy the quotation marks 
; into the last_match
test_for_string_raw:
		call input_blanks
		xor eax, eax
		mov esi, input_string
		add esi, [input_string_offset]
		mov ecx, 0

		cmp byte [esi], '"'
		je  .test_rest_chars_loop
		jmp .not_matching
		; Manual string comparison loop

	.test_rest_chars_loop:
			add esi, 1
			; Load the next byte from [esi] into AL, incrementing esi
			mov al, byte [esi]
			cmp al, 0
			je .end_of_string 
			cmp al, '"'       ; Check for quote
			je  .end_of_string       ; If we hit a quote, end the loop

			; Move the char into last_match at the current index
			mov ebx, last_match
			add ebx, ecx
			mov byte [ebx], al
			inc ecx

			; Otherwise match the next chars
			jmp .test_rest_chars_loop

	.not_matching:
			; Strings are not equal
			mov byte [eswitch], 1
			jmp .end

	.end_of_string:
			; Add the length of the match and 2 characters for the quotes
			; add ecx, 1
			; Add a null terminator to last_match
			mov ebx, last_match
			add ebx, ecx
			mov byte [ebx], 0x00
			add ecx, 2
			add [input_string_offset], ecx
			mov byte [eswitch], 0

	.end:
			ret