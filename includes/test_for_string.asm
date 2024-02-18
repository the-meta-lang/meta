%macro test_for_string 0
		input_blanks
    mov esi, input_string
		add esi, [input_string_offset]
		mov ecx, 0

		cmp byte [esi], '"'
    je  %%_test_rest_chars_loop
		jmp %%_not_matching
		jz %%_not_matching
    ; Manual string comparison loop

%%_test_rest_chars_loop:
    lodsb                   ; Load the next byte from [esi] into AL, incrementing esi
		cmp byte [esi], '"'       ; Check for space
    je  %%_end_of_string       ; If space is reached, end the loop
		cmp byte [esi], 0
		je %%_end_of_string ; TODO: Maybe terminate?

		; Move the char into last_match at the current index
		mov eax, last_match
		add eax, ecx
		mov byte [eax], al
		; Add a null terminator
		add eax, 1
		mov byte [eax], 0x00
		inc ecx

		; Otherwise match the next chars
    jmp %%_test_rest_chars_loop

%%_not_matching:
    ; Strings are not equal
		set_false
		jmp %%_end

%%_end_of_string:
		; Add the length of the match and 2 characters for the quotes
		add ecx, 2
		add [input_string_offset], ecx
		set_true

%%_end:
		cmp eax, 1
%endmacro