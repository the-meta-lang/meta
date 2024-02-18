; Macro for testing against input string
; Expects to be given a string to compare the input against
%macro test_input_string 1
section .data
		%%_str db %1, 0x00
		%%_str_length equ $ - %%_str - 1 ; Adjust for null terminator
section .text
		input_blanks
    mov edi, input_string
		add edi, [input_string_offset]
    mov esi, %%_str
		mov ebx, %%_str 

    ; Input:
    ;   edi = address of the first string
    ;   esi = address of the second string
    ; Output:
    ;   Zero flag (ZF) set if strings are equal, cleared otherwise

    ; Manual string comparison loop
    xor eax, eax            ; Clear EAX (result)

%%_compare_loop:
    lodsb                   ; Load the next byte from [esi] into AL, incrementing esi
		test al, al             ; Check if we've reached the null terminator
    jz %%_strings_equal     ; If null terminator is reached, strings are equal
		cmp al, [edi]           ; Compare the byte with [edi]
    jne %%_strings_not_equal ; Jump if not equal
    inc edi                 ; Move to the next byte in the first string
    jmp %%_compare_loop     ; Repeat the loop

%%_strings_equal:
    ; Strings are equal
		mov esi, %%_str ; Source
		mov edi, last_match ; Destination
		mov ecx, %%_str_length
		rep movsb ; Copy the string into last_match
		mov eax, %%_str_length
		add [input_string_offset], eax
		set_true ; Set zero flag to 0 to indicate equality
		jmp %%_end

%%_strings_not_equal:
    ; Strings are not equal
		set_false		; Set the zero flag to false

%%_end:
		cmp eax, 1
%endmacro