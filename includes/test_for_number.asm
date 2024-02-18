%macro test_for_number 0
		input_blanks
    mov esi, input_string
		add esi, [input_string_offset]

    ; Manual string comparison loop
    xor eax, eax            ; Clear EAX (result)

%%_test_digit:
		cmp byte [esi], ' '       ; Check for space
    je  %%_end_of_string       ; If space is reached, end the loop
		cmp byte [esi], 0
		je %%_end_of_string
		cmp byte [esi], '0'
		jl %%_not_matching
		cmp byte [esi], '9'
		jg %%_not_matching

		; Move the char into last_match at index esi - (start) esi
		mov eax, input_string
		add eax, [input_string_offset]
		mov ebx, esi
		sub ebx, eax
		mov eax, last_match
		add eax, ebx
		mov ebx, [esi]
		mov [eax], ebx
		add eax, 1
		mov byte [eax], 0x00

		; Otherwise match the next chars
		lodsb                   ; Load the next byte from [esi] into AL, incrementing esi
    jmp %%_test_digit

%%_not_matching:
    ; Strings are not equal
		set_false ; Set zero flag to 1 to indicate inequality
		jmp %%_end

%%_end_of_string:
		set_true
		; TODO: Add the length of the match

%%_end:
		cmp eax, 1
%endmacro