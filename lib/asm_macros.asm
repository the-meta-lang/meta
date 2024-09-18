section .data
	tflag db 0
	; Parse Flag, indicates a parsing error which may be recovered from
	; by backtracking 
	pflag db 0
	; Error switch, indicates a parsing error that is not recoverable
	eswitch db 0
	outbuff_offset dd 0
	backtrack_switch db 0

	cursor dd 0


section .bss
		input_string resb MAX_INPUT_LENGTH
		input_pointer resb 4
		lfbuffer resb 1
		FILE resb 256
		str_vector_8192 resb 8192
		last_match resb 512

		err_inbuff_offset resb 512
		err_fn_names resb 8192

		; TODO: This is a temporary solution, we should use a dynamic buffer
		outbuff resb 5242880 ; 5MB for the output buffer
		

		; Space for the backtracking output buffer (int[])
		bk_outbuff_offset resb 512
		; Space for the backtracking input buffer (int[])
		bk_inbuff_offset resb 512
		; Space for the backtracking token buffer (string[])
		bk_token resb 8192
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
		push esi
%endmacro

%macro restore_machine_state 0
		pop esi
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
		push esi
		push edi
		mov esi, %%_str
		mov edi, outbuff
		add edi, [outbuff_offset]
		call strcpy
		add dword [outbuff_offset], eax
		pop edi
		pop esi
%endmacro

; %macro print_ref 1
; 		save_machine_state
; 		mov eax, 4          ; syscall: sys_write
; 		mov ebx, 1          ; file descriptor: STDOUT
; 		mov ecx, %1  ; string to write
; 		mov edx, 0          ; length will be determined dynamically
; %%_calculate_length:
; 		cmp byte [ecx + edx], 0  ; check for null terminator
; 		je  %%_end_calculate_length
; 		inc edx
; 		jmp %%_calculate_length
; %%_end_calculate_length:
; 		int 0x80            ; invoke syscall
; 		restore_machine_state
; %endmacro

; Match everything that is not the given character
%macro match_not 1
		save_machine_state
		mov esi, input_string
		add esi, [cursor]
		mov ecx, 0
%%_match_not_loop:
		cmp byte [esi], %1
		je  %%_end_match_not_loop
		cmp byte [esi], 0
		je  %%_end_match_not_loop
		mov eax, last_match
		add eax, ecx
		mov bl, byte [esi]
		mov byte [eax], bl
		inc esi
		inc ecx
		jmp %%_match_not_loop
%%_end_match_not_loop:
		mov eax, last_match
		add eax, ecx
		mov byte [eax], 0x00
		add [cursor], ecx
		restore_machine_state
%endmacro

newline:
		print 0x0A
		ret

; Prints a newline character
; Without indenting the new line
label:
		print 0x0A
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



; %macro print_input_string 0
; 		save_machine_state ; Save the flags register
; 		print "------------------------"
; 		mov eax, 4          ; syscall: sys_write
; 		mov ebx, 1          ; file descriptor: STDOUT
; 		mov ecx, input_string  ; string to write
; 		add ecx, [cursor]
; 		mov edx, 0          ; length will be determined dynamically
; %%_calculate_length:
; 		cmp byte [ecx + edx], 0  ; check for null terminator
; 		je  %%_end_calculate_length
; 		inc edx
; 		jmp %%_calculate_length
; %%_end_calculate_length:
; 		int 0x80            ; invoke syscall
; 		restore_machine_state ; Restore the flags register
; %endmacro

input_blanks:
		; Find the first non-whitespace character in the input string
		mov esi, input_string
		add esi, [cursor]
	.find_non_whitespace:
		cmp byte [esi], ' '     ; Compare the current character with a space
		je  .skip_whitespace     ; Jump if it's a newline
		cmp byte [esi], 0x0A ; Skip newlines
		je  .skip_whitespace     ; Jump if it's a tab
		cmp byte [esi], 0x09 ; Skip Tabs
		je .skip_whitespace
		jmp  .end_of_string       ; We've hit the end of initial spaces, let's end it here

	.skip_whitespace:
		inc esi                 ; Move to the next character
		jmp .find_non_whitespace ; Continue searching for non-whitespace

	.end_of_string:
	; Copy the remaining part of the string (without leading whitespace) to the beginning
	mov eax, input_string ; Get the address of the start of the string
	sub esi, eax ; Subtract the offset of the end of the string from the beginning
	mov [cursor], esi
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
		add edi, [cursor]
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
		add [cursor], eax
		mov byte [eswitch], 0 ; Set zero flag to 0 to indicate equality
		jmp %%_end

%%_strings_not_equal:
		; Strings are not equal
		mov byte [eswitch], 1		; Set the zero flag to false

%%_end:
%endmacro

; Macro for testing against input string
; Expects to be given a string to compare the input against
%macro test_input_string_no_cursor_advance 1
section .data
		%%_str db %1, 0x00
		%%_str_length equ $ - %%_str - 1 ; Adjust for null terminator
section .text
		call input_blanks
		mov edi, input_string
		add edi, [cursor]
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
		mov byte [eswitch], 0 ; Set zero flag to 0 to indicate equality
		jmp %%_end

%%_strings_not_equal:
		; Strings are not equal
		mov byte [eswitch], 1		; Set the zero flag to false

%%_end:
%endmacro


copy_last_match:
		mov esi, last_match
		mov edi, outbuff
		add edi, [outbuff_offset]
		call strcpy
		add dword [outbuff_offset], eax
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

%include "./lib/strcat.asm"
%include "./lib/vectors.asm"
%include "./lib/string.asm"
%include "./lib/print.asm"
%include "./lib/import.asm"
%include "./lib/terminate-program.asm"
%include "./lib/vstack.asm"
%include "./lib/hash-map.asm"
%include "./lib/string-to-int.asm"
%include "./lib/malloc.asm"
%include "./lib/char-test.asm"
%include "./lib/output-buffer.asm"
%include "./lib/backtracking.asm"
%include "./lib/error-reporting.asm"