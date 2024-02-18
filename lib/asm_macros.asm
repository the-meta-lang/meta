%macro save_machine_state 0
		pushfd ; Save the flags register
		push ebp ; Save the base pointer
%endmacro

%macro restore_machine_state 0
		pop ebp ; Restore the base pointer
		popfd ; Restore the flags register
%endmacro

%macro print_input 0
		save_machine_state ; Save the flags register
		print "------------------------"
		print 0x0a
		mov eax, 4          ; syscall: sys_write
		mov ebx, 1          ; file descriptor: STDOUT
		mov ecx, input_string  ; string to write
		add ecx, [input_string_offset]
		mov edx, 0          ; length will be determined dynamically
%%_calculate_length:
		cmp byte [ecx + edx], 0  ; check for null terminator
		je  %%_end_calculate_length
		inc edx
		jmp %%_calculate_length
%%_end_calculate_length:
		int 0x80            ; invoke syscall
		print 0x0a
		print "------------------------"
		restore_machine_state ; Restore the flags register
%endmacro

%macro print_int 1
		save_machine_state ; Save the flags register
		mov eax, %1 ; Move the number into eax
		mov edi, 0 ; Clear the counter
%%_divide_loop:
		cmp eax, 0
		je  %%_print_loop
		mov edx, 0
		mov ebx, 10
		div ebx
		add edx, 0x30
		push edx
		inc edi ; Increment the counter for every new digit we add
		jmp %%_divide_loop
%%_print_loop:
		cmp edi, 0
		je  %%_end_print_loop
		dec edi ; Decrement the counter

		mov eax, 4 ; syscall number for sys_write
		mov ebx, 1 ; file descriptor 1 is stdout
		mov ecx, esp ; Move the address of the next digit to ecx
		mov edx, 1 ; we are going to write one byte
		int 0x80            ; invoke syscall
		pop ecx ; Pop the next digit off the stack
		jmp %%_print_loop
%%_end_print_loop:
		restore_machine_state ; Restore the flags register
%endmacro

; Macro for printing to stdout
; Expects 1 argument (string) and automatically calculates it's length and outputs it
%macro print 1
section .data
		%%_str db %1, 0x00
section .text
		save_machine_state ; Save the flags register
		mov eax, 4          ; syscall: sys_write
		mov ebx, 1          ; file descriptor: STDOUT
		mov ecx, %%_str  ; string to write
		mov edx, 0          ; length will be determined dynamically
%%_calculate_length:
		cmp byte [ecx + edx], 0  ; check for null terminator
		je  %%_end_calculate_length
		inc edx
		jmp %%_calculate_length
%%_end_calculate_length:
		int 0x80            ; invoke syscall
		restore_machine_state ; Restore the flags register
%endmacro

; Macro for printing to stdout including a newline at the end
; Expects 1 argument (string) and automatically calculates it's length and outputs it
%macro print_with_newline 1
		print %1
		newline
%endmacro

%macro label_with_newline 1
		label
		print %1
		newline
%endmacro

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

%macro test_for_string 0
		input_blanks
		mov esi, input_string
		add esi, [input_string_offset]
		mov ecx, 0

		cmp byte [esi], '"'
		je  %%_test_rest_chars_loop
		jmp %%_not_matching
		; Manual string comparison loop

%%_test_rest_chars_loop:
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
		je  %%_end_of_string       ; If space is reached, end the loop
		cmp byte [esi], 0
		je %%_end_of_string ; TODO: Maybe terminate?

		; Otherwise match the next chars
		jmp %%_test_rest_chars_loop

%%_not_matching:
		; Strings are not equal
		set_false
		jmp %%_end

%%_end_of_string:
		; Add the length of the match and 2 characters for the quotes
		add ecx, 1
		add [input_string_offset], ecx
		set_true

%%_end:
		cmp eax, 1
%endmacro

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
		cmp al, '_'
		je  %%_test_rest_chars_loop
		cmp al, 'a'
		jl  %%_not_matching
		cmp al, 'z'
		jle %%_test_rest_chars_loop
		jg %%_not_matching

%%_test_rest_chars_loop:
		; Move the char into last_match at the current index
		mov ebx, last_match
		add ebx, ecx
		mov byte [ebx], al
		; Add a null terminator
		add ebx, 1
		mov byte [ebx], 0x00
		; Increment ecx
		inc ecx
		lodsb                   ; Load the next byte from [esi] into AL, incrementing esi
		test al, al       ; Check for the null terminator
		je  %%_matching       ; If null terminator is reached, end the loop
		cmp al, ' '
		je  %%_matching       ; If space is reached, end the loop
		cmp al, 0x0A
		je  %%_matching       ; If newline is reached, end the loop
		cmp al, ';'
		je  %%_matching       ; If line terminator is reached, end the loop
		; Compare the first byte against 'a' to 'z', 'A' to 'Z', '_', and '0' to '9'
		cmp al, '0' ; Check for digits - Has to be first because 0x31 is 1 but 0x41 is A
		jl  %%_not_matching
		cmp al, '9'
		jle %%_test_rest_chars_loop
		cmp al, 'A'
		jl  %%_not_matching
		cmp al, 'Z'
		jle %%_test_rest_chars_loop
		cmp al, '_'
		je  %%_test_rest_chars_loop
		cmp al, 'a'
		jl  %%_not_matching
		cmp al, 'z'
		jle %%_test_rest_chars_loop
		jg %%_not_matching

%%_matching:
		; Strings are equal
		add [input_string_offset], ecx
		set_true      ; Set EAX to 1 to indicate equality
		jmp %%_end

%%_not_matching:
		; If the size of the match is bigger than 1 then it's a match
		cmp ecx, 0
		jg %%_matching

		; Strings are not equal
		set_false    ; Set EAX to 0 to indicate inequality
		jmp %%_end

%%_end:
		cmp eax, 1
%endmacro

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

%macro test_for_number 0
		input_blanks
		mov esi, input_string
		add esi, [input_string_offset]

		; Manual string comparison loop
		xor eax, eax            ; Clear EAX (result)

%%_test_digit:
		cmp byte [esi], ' '       ; Check for space
		je  %%_end_of_string       ; If space is reached, end the loop
		cmp byte [esi], 0x00
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
		add byte [input_string_offset], 1

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

%macro copy_last_match 0
		save_machine_state ; Save the flags register
		mov eax, 4          ; syscall: sys_write
		mov ebx, 1          ; file descriptor: STDOUT
		mov ecx, last_match  ; string to write
		mov edx, 0          ; length will be determined dynamically
%%_calculate_length:
		cmp byte [ecx + edx], 0  ; check for null terminator
		je  %%_end_calculate_length
		inc edx
		jmp %%_calculate_length
%%_end_calculate_length:
		int 0x80            ; invoke syscall
		restore_machine_state ; Restore the flags register
%endmacro

%macro gn1 0
		save_machine_state ; Save the flags register
		mov al, byte [vstack_1]; Get gn1
		cmp al, 0
		; TODO: `je`? i'm not sure...
		je %%_generate_new_number

%%_print_label:
		print "LB"
		print_int [gn1_number]

		mov al, [gn1_number]
		mov byte [vstack_1], al

		jmp %%_end

%%_generate_new_number:
		add byte [gn1_number], 0x01
		jmp %%_print_label

%%_end:
		restore_machine_state ; Restore the flags register
%endmacro

%macro set_false 0
		; How to set the zero flag to false:
		; https://stackoverflow.com/questions/54499327/setting-and-clearing-the-zero-flag-in-x86
		test esp, esp
		mov eax, 0
%endmacro

%macro set_true 0
		; How to set the zero flag to true:
		; https://stackoverflow.com/questions/54499327/setting-and-clearing-the-zero-flag-in-x86
		; This will destroy any data in eax!
		xor eax, eax
		mov eax, 1
%endmacro

%macro newline 0
		save_machine_state ; Save the flags register
		label
		print "    "
		restore_machine_state ; Restore the flags register
%endmacro

; Prints a newline character
; Without indenting the new line
%macro label 0
		save_machine_state ; Save the flags register
		mov byte [lfbuffer], 0x0A
		mov eax, 0x04
		mov ebx, 0x01
		mov ecx, lfbuffer
		mov edx, 1
		int 0x80
		restore_machine_state ; Restore the flags register
%endmacro

%macro reset_vstack 0
		mov byte [vstack_1], 0x00
%endmacro

terminate_program:
		; Write error message to stdout
		print_with_newline "BRANCH ERROR Executed - Something is Wrong!"

		; Exit the program
		mov eax, 1            ; System call number for sys_exit
		mov ebx, 1          ; Exit code 1
		int 0x80              ; Invoke the kernel to exit the program