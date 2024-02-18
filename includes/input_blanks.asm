%macro input_blanks 0
		; Find the first non-whitespace character in the input string
    mov esi, input_string
		add esi, [input_string_offset]
%%_find_non_whitespace:
    cmp byte [esi], ' '     ; Compare the current character with a space
    je  %%_skip_whitespace     ; Jump if it's a space
		cmp byte [esi], 0x0A ; Skip newlines
		je %%_skip_whitespace
    jmp  %%_end_of_string       ; We've hit the end of initial spaces, let's end it here

%%_skip_whitespace:
    inc esi                 ; Move to the next character
    jmp %%_find_non_whitespace ; Continue searching for non-whitespace

%%_end_of_string:
	; Copy the remaining part of the string (without leading whitespace) to the beginning
	mov eax, input_string ; Get the address of the start of the string
	sub esi, eax ; Subtract the offset of the end of the string from the beginning
	mov [input_string_offset], esi

%endmacro