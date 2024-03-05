section .data
	pflag db 0
	tflag db 0
	; Error Flag, indicates a parsing error which may be recovered from
	; by backtracking 
	eflag db 0
	; Error switch, indicates a parsing error that is not recoverable
	eswitch db 0

section .bss
		input_string resb MAX_INPUT_LENGTH
		input_string_offset resb 2
		input_pointer resb 4
		lfbuffer resb 1
		FILE resb 256
		str_vector_8192 resb 8192
		last_match resb 512
section .text
global _start

_read_file:
		; Open and read the file specified in
		; the FILE constant to enable easier debugging.
		mov eax, 5 ; syscall for 'open'
		mov ebx, FILE ; File to open
		mov ecx, 0 ; O_RDONLY
		int 0x80

		mov ebx, eax ; Save the file descriptor
		mov eax, 3 ; syscall for 'read'
		mov ecx, input_string ; Read Text input into `input_string`
		mov edx, MAX_INPUT_LENGTH ; Let's read the maximum number of bytes
		int 0x80

		mov eax, 6 ; syscall for 'close'
		int 0x80

		ret

section .text


%macro save_machine_state 0
		pushfd ; Save the flags register
		push ebp ; Save the base pointer
		push eax
		push ebx
		push ecx
		push edx
		push edi
%endmacro

%macro restore_machine_state 0
		pop edi
		pop edx
		pop ecx
		pop ebx
		pop eax
		pop ebp ; Restore the base pointer
		popfd ; Restore the flags register
%endmacro

; Macro for printing to stdout
; Expects 1 argument (string) and automatically calculates it's length and outputs it
%macro print 1
section .data
		%%_str db %1, 0x00
section .text
		print_ref %%_str
%endmacro

%macro print_ref 1
		save_machine_state
		mov eax, 4          ; syscall: sys_write
		mov ebx, 1          ; file descriptor: STDOUT
		mov ecx, %1  ; string to write
		mov edx, 0          ; length will be determined dynamically
%%_calculate_length:
		cmp byte [ecx + edx], 0  ; check for null terminator
		je  %%_end_calculate_length
		inc edx
		jmp %%_calculate_length
%%_end_calculate_length:
		int 0x80            ; invoke syscall
		restore_machine_state
%endmacro

; Match everything that is not the given character
%macro match_not 1
		save_machine_state
		mov esi, input_string
		add esi, [input_string_offset]
		mov ecx, 0
%%_match_not_loop:
		cmp byte [esi], %1
		je  %%_end_match_not_loop
		cmp byte [esi], 0
		je  %%_end_match_not_loop
		inc esi
		inc ecx
		jmp %%_match_not_loop
%%_end_match_not_loop:
		add [input_string_offset], ecx
		restore_machine_state
%endmacro

newline:
		save_machine_state ; Save the flags register
		call label
		print "    "
		restore_machine_state ; Restore the flags register
		ret

; Prints a newline character
; Without indenting the new line
label:
		save_machine_state ; Save the flags register
		mov byte [lfbuffer], 0x0A
		mov eax, 0x04
		mov ebx, 0x01
		mov ecx, lfbuffer
		mov edx, 1
		int 0x80
		restore_machine_state ; Restore the flags register
		ret

; Macro for printing to stdout including a newline at the end
; Expects 1 argument (string) and automatically calculates it's length and outputs it
%macro print_with_newline 1
		print %1
		call newline
%endmacro

%macro label_with_newline 1
		call label
		print %1
		call newline
%endmacro



%macro print_input_string 0
		save_machine_state ; Save the flags register
		print "------------------------"
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
		restore_machine_state ; Restore the flags register
%endmacro

input_blanks:
		; Find the first non-whitespace character in the input string
		mov esi, input_string
		add esi, [input_string_offset]
ib_find_non_whitespace:
		cmp byte [esi], ' '     ; Compare the current character with a space
		je  ib_skip_whitespace     ; Jump if it's a newline
		cmp byte [esi], 0x0A ; Skip newlines
		je  ib_skip_whitespace     ; Jump if it's a tab
		cmp byte [esi], 0x09 ; Skip Tabs
		je ib_skip_whitespace
		jmp  ib_end_of_string       ; We've hit the end of initial spaces, let's end it here

ib_skip_whitespace:
		inc esi                 ; Move to the next character
		jmp ib_find_non_whitespace ; Continue searching for non-whitespace

ib_end_of_string:
	; Copy the remaining part of the string (without leading whitespace) to the beginning
	mov eax, input_string ; Get the address of the start of the string
	sub esi, eax ; Subtract the offset of the end of the string from the beginning
	mov [input_string_offset], esi
	ret




test_for_id:
		call input_blanks
		mov esi, input_string
		add esi, [input_string_offset]
		mov ecx, 0 ; Initialize the length of the match to 0

		jmp .test_first_char
		jz .not_matching
		; Manual string comparison loop

	.test_first_char:
			lodsb                   ; Load the next byte from [esi] into AL, incrementing esi
			cmp al, 'A'
			jl  .not_matching
			cmp al, 'Z'
			jle .test_rest_chars_loop
			cmp al, '_'
			je  .test_rest_chars_loop
			cmp al, 'a'
			jl  .not_matching
			cmp al, 'z'
			jle .test_rest_chars_loop
			jg .not_matching

	.test_rest_chars_loop:
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
			je  .matching       ; If null terminator is reached, end the loop
			cmp al, ' '
			je  .matching       ; If space is reached, end the loop
			cmp al, 0x0A
			je  .matching       ; If newline is reached, end the loop
			cmp al, ';'
			je  .matching       ; If line terminator is reached, end the loop
			; Compare the first byte against 'a' to 'z', 'A' to 'Z', '_', and '0' to '9'
			cmp al, '0' ; Check for digits - Has to be first because 0x31 is 1 but 0x41 is A
			jl  .not_matching
			cmp al, '9'
			jle .test_rest_chars_loop
			cmp al, 'A'
			jl  .not_matching
			cmp al, 'Z'
			jle .test_rest_chars_loop
			cmp al, '_'
			je  .test_rest_chars_loop
			cmp al, 'a'
			jl  .not_matching
			cmp al, 'z'
			jle .test_rest_chars_loop
			jg .not_matching

	.matching:
			; Strings are equal
			add [input_string_offset], ecx
			mov byte [eswitch], 0      ; Set EAX to 1 to indicate equality
			jmp .end

	.not_matching:
			; If the size of the match is bigger than 1 then it's a match
			cmp ecx, 0
			jg .matching

			; Strings are not equal
			mov byte [eswitch], 1    ; Set EAX to 0 to indicate inequality
			jmp .end

	.end:
			ret

; Macro for testing against input string
; Expects to be given a string to compare the input against
%macro test_input_string 1
section .data
		%%_str db %1, 0x00
		%%_str_length equ $ - %%_str - 1 ; Adjust for null terminator
section .text
		call input_blanks
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
		; TODO: Don't move result into last_match, never necessary and really infuriating...
		; mov esi, %%_str ; Source
		; mov edi, last_match ; Destination
		; mov ecx, %%_str_length
		; rep movsb ; Copy the string into last_match
		mov eax, %%_str_length
		add [input_string_offset], eax
		mov byte [eswitch], 0 ; Set zero flag to 0 to indicate equality
		jmp %%_end

%%_strings_not_equal:
		; Strings are not equal
		mov byte [eswitch], 1		; Set the zero flag to false

%%_end:
%endmacro


copy_last_match:
		save_machine_state ; Save the flags register
		mov eax, 4          ; syscall: sys_write
		mov ebx, 1          ; file descriptor: STDOUT
		mov ecx, last_match  ; string to write
		mov edx, 0          ; length will be determined dynamically
.calculate_length:
		cmp byte [ecx + edx], 0  ; check for null terminator
		je  .end_calculate_length
		inc edx
		jmp .calculate_length
.end_calculate_length:
		int 0x80            ; invoke syscall
		restore_machine_state ; Restore the flags register
		ret

set_false:
		; How to set the zero flag to false:
		; https://stackoverflow.com/questions/54499327/setting-and-clearing-the-zero-flag-in-x86
		test esp, esp
		mov eax, 0
		ret

set_true:
		; How to set the zero flag to true:
		; https://stackoverflow.com/questions/54499327/setting-and-clearing-the-zero-flag-in-x86
		; This will destroy any data in eax!
		xor eax, eax
		mov eax, 1
		ret




_read_file_argument:
		mov ecx, 0 ; The write offset

_read_file_argument_loop:
		mov ebx, FILE ; Get the address of the FILE constant
		add ebx, ecx ; Add the offset to the FILE constant
		mov edx, [esp + 12] ; The first command line argument
		add edx, ecx
		mov al, byte [edx]
		mov byte [ebx], al
		mov edx, [esp + 12] ; The first command line argument
		add edx, ecx
		cmp byte [edx], 0x00 ; Check for the null terminator
		je _read_file_argument_end ; If null terminator is reached, end the loop
		inc ecx ; Increment the offset
		jmp _read_file_argument_loop ; Repeat the loop

_read_file_argument_end:
		ret

%include "./lib/vectors.asm"
%include "./lib/string.asm"
%include "./lib/print.asm"
%include "./lib/import.asm"
%include "./lib/test-for-number.asm"
%include "./lib/terminate-program.asm"
%include "./lib/vstack.asm"
%include "./lib/hash-map.asm"
%include "./lib/test-for-string.asm"
%include "./lib/string-to-int.asm"
%include "./lib/malloc.asm"
%include "./lib/char-test.asm"