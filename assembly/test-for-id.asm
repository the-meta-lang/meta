%macro test_for_id 0
		input_blanks
    mov esi, input_string
		add esi, [input_string_offset]

		jmp %%_test_first_char
		jz %%_not_matching
    ; Manual string comparison loop
    xor eax, eax            ; Clear EAX (result)

%%_test_first_char:
		cmp byte [esi], 'a'
    jl  %%_not_matching
    cmp byte [esi], 'z'
    jle %%_matching_first_char
    cmp byte [esi], 'A'
    jl  %%_not_matching
    cmp byte [esi], 'Z'
    jle %%_matching_first_char
    cmp byte [esi], '_'
    je  %%_matching_first_char

%%_matching_first_char:
		jmp %%_test_rest_chars_loop

%%_test_rest_chars_loop:
    lodsb                   ; Load the next byte from [esi] into AL, incrementing esi
		cmp byte [esi], ' '       ; Check for space
    je  %%_end_of_string       ; If space is reached, end the loop
		cmp byte [esi], 0
		je %%_end_of_string

    ; Compare the first byte against 'a' to 'z', 'A' to 'Z', '_', and '0' to '9'
    cmp byte [esi], 'a'
    jl  %%_not_matching
    cmp byte [esi], 'z'
    jle %%_test_rest_chars_loop
    cmp byte [esi], 'A'
    jl  %%_not_matching
    cmp byte [esi], 'Z'
    jle %%_test_rest_chars_loop
    cmp byte [esi], '_'
    je  %%_test_rest_chars_loop
    cmp byte [esi], '0'
    jl  %%_not_matching
    cmp byte [esi], '9'
    jle %%_test_rest_chars_loop

%%_matching:
    ; Strings are equal
    mov eax, 1      ; Set EAX to 1 to indicate equality
    jmp %%_end

%%_not_matching:
    ; Strings are not equal
    xor eax, eax    ; Set EAX to 0 to indicate inequality
		jmp %%_end

%%_end_of_string:
		mov eax, 1

%%_end:
%endmacro

%macro input_blanks 0
		; Find the first non-whitespace character in the input string
    mov esi, input_string
%%_find_non_whitespace:
    cmp byte [esi], ' '     ; Compare the current character with a space
    je  %%_skip_whitespace     ; Jump if it's a space
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

section .text

_start:
    ; Test input against string
    test_for_id

    ; Exit
		mov ebx, eax
		mov eax, 0x01
    int 0x80

section .data
    input_string db "  hello", 0x00
		input_string_offset db 0
