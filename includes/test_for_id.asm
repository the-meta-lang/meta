%macro test_for_id 0
		input_blanks
    mov esi, input_string
		add esi, [input_string_offset]
		mov ecx, 0 ; Initialize the length of the match to 0

		jmp %%_test_first_char
		jz %%_not_matching
    ; Manual string comparison loop

%%_test_first_char:
		lodsb                   ; Load the next byte from [esi] into AL, incrementing esi
		cmp al, 'A'
    jl  %%_not_matching
    cmp al, 'Z'
    jle %%_test_rest_chars_loop
		cmp al, 'a'
    jl  %%_not_matching
    cmp al, 'z'
    jle %%_test_rest_chars_loop
    cmp al, '_'
    je  %%_test_rest_chars_loop

%%_test_rest_chars_loop:
		; Move the char into last_match at the current index
		mov eax, last_match
		add eax, ecx
		mov byte [eax], al
		; Add a null terminator
		add eax, 1
		mov byte [eax], 0x00
		; Increment ecx
		inc ecx
    lodsb                   ; Load the next byte from [esi] into AL, incrementing esi
		test al, al       ; Check for the null terminator
    je  %%_matching       ; If null terminator is reached, end the loop
    cmp al, ' '
		je  %%_matching       ; If space is reached, end the loop
		cmp al, 0x0A
		je  %%_matching       ; If newline is reached, end the loop
		; Compare the first byte against 'a' to 'z', 'A' to 'Z', '_', and '0' to '9'
    cmp al, 'A'
    jl  %%_not_matching
    cmp al, 'Z'
    jle %%_test_rest_chars_loop
		cmp al, 'a'
    jl  %%_not_matching
    cmp al, 'z'
    jle %%_test_rest_chars_loop
    cmp al, '_'
    je  %%_test_rest_chars_loop
    cmp al, '0'
    jl  %%_not_matching
    cmp al, '9'
    jle %%_test_rest_chars_loop

%%_matching:
    ; Strings are equal
		add [input_string_offset], ecx
		set_true      ; Set EAX to 1 to indicate equality
		jmp %%_end

%%_not_matching:
    ; Strings are not equal
    set_false    ; Set EAX to 0 to indicate inequality
		jmp %%_end

%%_end:
		cmp eax, 1
%endmacro