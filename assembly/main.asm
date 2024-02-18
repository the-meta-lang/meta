
section .data
	; input_string db ".SYNTAX AEXP", 0x22, "AEXP = AS $AS;", 0x22, "AS = .ID ->(", 0x22, "address ", 0x22, " *) ", 0x22, ":=", 0x22, " EX1 ->(", 0x22, "store", 0x22, ") ", 0x22, ";", 0x22, ";", 0x22, "EX1 = ", 0x22, "EX2", 0x22, " $(", 0x22, "+", 0x22, " ", 0x22, "EX2", 0x22, " ->(", 0x22, "add", 0x22, ") |", 0x22, "            ", 0x22, "-", 0x22, " ", 0x22, "EX2", 0x22, " ->(", 0x22, "sub", 0x22, ") );", 0x22, ".END", 0x00
	label_prefix db "LB", 0x00
	gn2_number db 0x00
section .bss
			last_match resb 100
			output_string resb 500
			input_string resb 12000
			input_string_offset resb 2
			input_pointer resb 4
			lfbuffer resb 1
			gn1_number resb 1 ; The current number for gn1
section .text
global _start
_start:
			mov eax, 3 ; syscall for 'read'
			mov ebx, 0 ; stdin file descriptor
			mov ecx, input_string ; Read Text input into `input_string`
			mov edx, 12000 ; We can read up to 12000 bytes
			int 0x80

			jmp PROGRAM

; Macro for printing to stdout
; Expects 1 argument (string) and automatically calculates it's length and outputs it
%macro print 1
section .data
		%%_str db %1, 0x00
section .text
		pushfd ; Save the flags register
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
		popfd ; Restore the flags register
%endmacro

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
		cmp al, 'a'
    jl  %%_not_matching
    cmp al, 'z'
    jle %%_test_rest_chars_loop
    cmp al, '_'
    je  %%_test_rest_chars_loop

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

section .data
    error_message db "BRANCH ERROR Executed - Something is Wrong!", 0x0A, 0  ; Null-terminate the message
    error_message_length equ $ - error_message

section .text
		terminate_program:
			; Write error message to stdout
			mov eax, 4            ; System call number for sys_write
			mov ebx, 1            ; File descriptor for standard output (stdout)
			mov ecx, error_message ; Pointer to the error message
			mov edx, error_message_length ; Length of the error message
			int 0x80              ; Invoke the kernel to write the message to stdout

			; Exit the program
			mov eax, 1            ; System call number for sys_exit
			mov ebx, 1          ; Exit code 1
			int 0x80              ; Invoke the kernel to exit the program

%macro copy_last_match 0
		pushfd ; Save the flags register
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
		popfd ; Restore the flags register
%endmacro

%macro gn1 0
		mov eax, [gn1_number]; Get gn1
		cmp eax, 0
		; TODO: `je`? i'm not sure...
		jmp %%_generate_new_number

%%_print_label:
		mov ebx, [gn1_number]
		add ebx, 0x30
		push ebx ; Push the number onto the stack to make it printable using a pointer onto the stack

		mov eax, 0x04
		mov ebx, 0x01
		mov ecx, label_prefix
		mov edx, 2
		int 0x80
		mov eax, 0x04
		mov ebx, 0x01
		mov ecx, esp ; The address of the number in the stack pointer
		mov edx, 1
		int 0x80

		add esp, 4 ; Restore the stack pointer

		jmp %%_end

%%_generate_new_number:
		add byte [gn1_number], 0x01
		jmp %%_print_label

%%_end:
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

newline:
			call label
			print "       "
			ret

; Prints a newline character
; Without indenting the new line
label:
			pushfd ; Save the flags register
			mov byte [lfbuffer], 0x0A
			mov eax, 0x04
			mov ebx, 0x01
			mov ecx, lfbuffer
			mov edx, 1
			int 0x80
			popfd ; Restore the flags register
			ret

PROGRAM:
A0:
			test_input_string ".DATA"
			jne A1
			call label
			print ".data"
			call newline
A2:
			call DATA_DEFINITION
			jne A3
A3:	
			je A4
			call COMMENT
			jne A5
A5:
A4:
			je A2
			test esp, esp
			jne terminate_program
A1:
A6:
			jne A7
A7:
			je A8
			test_input_string ".SYNTAX"
			jne A9
			test_for_id
			jne terminate_program
			label_with_newline "section .text"
			print_with_newline "global _start"
			label_with_newline "_start:"
A10:
			call VARIABLE_ASSIGNMENT
			jne A11
A11:
			je A12
			call DEFINITION
			jne A13
A13:
			je A12
			call COMMENT
			jne A14
A14:
A12:
			je A10
			test_input_string ".END"
			jne terminate_program
			print_with_newline "mov eax, 1"
			print_with_newline "mov ebx, 0"
			print_with_newline "int 0x80"
			jmp A18
A9:
A8:
			je A0
			test esp, esp
			jne A17
A17:
A18:
			; Exit the program
			mov eax, 1            ; System call number for sys_exit
			mov ebx, 0          ; Exit code 0
			int 0x80              ; Invoke the kernel to exit the program
DATA_DEFINITION:
			test_for_id
			jne A19
			call label
			print "    "
			copy_last_match
			print_with_newline ":"
			test_input_string "="
			jne terminate_program
			call DATA_TYPE
			jne terminate_program
			test_input_string ";"
			jne terminate_program
A19:
A20:
			ret
DATA_TYPE:
			test_for_string
			jne A21
			print "string "
			copy_last_match
			call newline
A21:
A22:
			jne A23
A23:
			je A24
			test_for_number
			jne A25
			print "number "
			copy_last_match
			call newline
A25:
A26:
			jne A27
A27:
A24:
			ret
VARIABLE_ASSIGNMENT:
			test_input_string "["
			jne A28
			test_for_id
			jne terminate_program
			print "mov ["
			copy_last_match
			print "], "
			test_input_string "]"
			jne terminate_program
			test_input_string "="
			jne terminate_program
			test_for_string
			jne A29
			print "dword "
			copy_last_match
			call newline
A29:
			je A30
			test_for_number
			jne A31
			copy_last_match
			call newline
A31:
A30:
			jne terminate_program
			test_input_string ";"
			jne terminate_program
			print "ret"
			call newline
A28:
			ret
OUT1:
			test_input_string "*1"
			jne A33
			print "gn1"
			call newline
A33:
			je A34
			test_input_string "*2"
			jne A35
			print "GN2"
			call newline
A35:
			je A34
			test_input_string "*"
			jne A36
			print "copy_last_match"
			call newline
A36:
			je A34
			test_for_string
			jne A37
			print "print "
			copy_last_match
			call newline
A37:
			je A34
			test_input_string "["
			jne A38
			test_for_id
			jne terminate_program
			print "mov eax, ["
			copy_last_match
			print "]"
			call newline
			test_input_string "]"
			jne terminate_program
A38:
A34:
			ret
OUTPUT:
			test_input_string "->"
			jne A39
			test_input_string "("
			jne terminate_program
A40:
			call OUT1
			je A40
			test_input_string ")"
			jne terminate_program
A39:
			je A42
			test_input_string ".LABEL"
			jne A42
			print "call label"
			call newline
			test_input_string "("
			jne terminate_program
A43:
			call OUT1
			je A42
			test_input_string ")"
			jne terminate_program
A42:
			jne A44
			print "call newline"
			call newline
A44:
			je A45
			test_input_string ".OUT"
			jne A45
			test_input_string "("
			jne terminate_program
A47:
			call OUT1
			je A47
			test_input_string ")"
			jne terminate_program
A45:
			ret
EX3:
			test_for_id
			jne A48
			print "call "
			copy_last_match
			call newline
A48:
			je A49
			test_for_string
			jne A50
			print "test_input_string "
			copy_last_match
			call newline
A50:
			je A49
			test_input_string ".ID"
			jne A51
			print "test_for_id"
			call newline
A51:
			je A49
			test_input_string ".RET"
			jne A52
			print "ret"
			call newline
A52:
			je A49
			test_input_string ".NOT"
			jne A53
			test_for_string
			jne terminate_program
			print "NOT "
			copy_last_match
			call newline
A53:
			je A49
			test_input_string ".NUMBER"
			jne A54
			print "test_for_number"
			call newline
A54:
			je A49
			test_input_string ".STRING"
			jne A55
			print "test_for_string"
			call newline
A55:
			je A49
			test_input_string "("
			jne A56
			call EX1
			; jne terminate_program
			test_input_string ")"
			jne terminate_program
A56:
			je A49
			test_input_string ".EMPTY"
			jne A57
			print "test esp, esp"
			call newline
A57:
			je A49
			test_input_string "$"
			jne A49
			call label
			gn1
			print ":"
			call newline
			call EX3
			jne terminate_program
			print "je "
			gn1
			call newline
			print "test esp, esp"
			call newline
A49:
			ret
EX2:
			call EX3
			jne A59
			print "jne "
			gn1
			call newline
A59:
			je A60
			call OUTPUT
A60:
			jne A62
A63:
			call EX3
			jne B64
			print "jne terminate_program"
			call newline
B64:
			je A65
			call OUTPUT
A65:
			je A63
			call label
			gn1
			print ":"
			call newline
A62:
			ret
EX1:
			call EX2
			jne A68
A69:
			test_input_string "|"
			jne A70
			print "je "
			gn1
			call newline
			call EX2
			jne terminate_program
A70:
			je A71
			call COMMENT
A71:
			je A69
			call label
			gn1
			print ":"
			call newline
A68:
			ret
DEFINITION:
			test_for_id
			jne A74 ; TODO: Check
			call label
			copy_last_match
			print_with_newline ":"
			test_input_string "="
			jne terminate_program
			call EX1
			jne terminate_program
			test_input_string ";"
			jne terminate_program
			print_with_newline "ret"
A74:
			ret
COMMENT:
			test_input_string "/*"
			jne A76
			; TODO: Implement
			; NOT "*/"
			jne terminate_program
			test_input_string "*/"
			jne terminate_program
A76:
			ret
			mov eax, 0x01
			mov ebx, 0x01
			int 0x80