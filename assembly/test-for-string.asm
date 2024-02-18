%macro test_for_string 0
		input_blanks
    mov esi, input_string
		add esi, [input_string_offset]

		jmp %%_test_quote
		jz %%_not_matching
    ; Manual string comparison loop
    xor eax, eax            ; Clear EAX (result)

%%_test_quote:
		cmp byte [esi], '"'
    je  %%_test_rest_chars_loop
		jmp %%_not_matching

%%_test_rest_chars_loop:
    lodsb                   ; Load the next byte from [esi] into AL, incrementing esi
		cmp byte [esi], '"'       ; Check for space
    je  %%_end_of_string       ; If space is reached, end the loop
		cmp byte [esi], 0
		je %%_end_of_string

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
    jmp %%_test_rest_chars_loop

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
    test_for_string

		mov eax, 4
		mov ebx, 1
		mov ecx, last_match
		mov edx, 8
		int 0x80

    ; Exit
		mov ebx, eax
		mov eax, 0x01
    int 0x80

section .data
    input_string db '"string"', 0x00
		input_string_offset db 0

section .bss
	last_match resb 50
