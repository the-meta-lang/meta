; Tests whether the input string at the current index contains a number
test_for_number:
		call input_blanks
		mov esi, input_string
		add esi, [input_string_offset]

		; Store the length of the match
		mov ecx, 0

		; Manual string comparison loop
		xor eax, eax            ; Clear EAX (result)

	.test_digit:
			cmp byte [esi], ' '       ; Check for space
			je  .end_of_string       ; If space is reached, end the loop
			cmp byte [esi], 0
			je .end_of_string
			cmp byte [esi], '0'
			jl .not_matching
			cmp byte [esi], '9'
			jg .not_matching

			; Move the char into last_match at index +ecx
			mov eax, last_match
			add eax, ecx
			mov bl, byte [esi]
			mov byte [eax], bl
			add ecx, 1 ; Increment the length of the match
			; Match the next chars
			add esi, 1 ; increment esi
			jmp .test_digit

	.not_matching:
			cmp ecx, 0
			jg .end_of_string
			; Strings are not equal
			mov byte [eswitch], 1 ; Set zero flag to 1 to indicate inequality
			jmp .end

	.end_of_string:
			add [input_string_offset], ecx
			mov eax, last_match
			add eax, ecx
			mov byte [eax], 0x00 ; add null terminator in last_match
			mov byte [eswitch], 0

	.end:
			ret