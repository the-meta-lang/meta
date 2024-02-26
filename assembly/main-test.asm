%define MAX_INPUT_LENGTH 65536

section .data
		gn1_number dd 0x00

section .bss
		last_match resb 512
		input_string resb MAX_INPUT_LENGTH
		input_string_offset resb 2
		input_pointer resb 4
		lfbuffer resb 1
		FILE resb 256
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


section .data
		vstack_pointer dd 0x00
section .bss
		vstack resb 256 ; 256 bytes of virtual stack

section .text

%macro print_vstack 0
	save_machine_state
	print 0x0a
	print "--"
	; Print out the vstack
	mov edi, 0
%%_loop:
		cmp edi, 4
		je %%_end_loop
		mov ebx, vstack
		mov eax, 4
		mul edi
		add ebx, eax
		print " "
		print_int [ebx]
		inc edi
		jmp %%_loop

%%_end_loop:
	mov eax, [vstack_pointer]
	print " "
	print_int eax
	print " -- "
	restore_machine_state
%endmacro

%macro vstack_push 1
		save_machine_state
		mov eax, vstack
		add eax, [vstack_pointer]
		mov word [eax], %1
		mov ax, word [vstack_pointer]
		add ax, 2 ; increment the pointer
		mov word [vstack_pointer], ax
		restore_machine_state
%endmacro

vstack_pop:
		pushfd
		push ebp ; Save the base pointer
		push ebx
		push ecx
		push edx
		push edi
		mov ax, word [vstack_pointer] ; Get the current pointer
		cmp ax, 0 ; Check if the pointer is 0
		je  vp_pre_terminate ; If it is, we can't pop anything, we need to return 0 to prevent writing into the memory before the vstack

		sub ax, 2	; Decrement the pointer
		mov word [vstack_pointer], ax ; Store the new pointer
		
		mov eax, vstack
		add eax, [vstack_pointer]
		mov eax, [eax] ; store the result in eax

		mov ebx, vstack 
		add ebx, [vstack_pointer] 
		mov word [ebx], 0x00 ; reset the value in the array to 0
		jmp vp_end
	vp_pre_terminate:
		mov eax, 0x00
	vp_end:
		; print "POP"
		; print_vstack
		pop edi
		pop edx
		pop ecx
		pop ebx
		pop ebp ; Restore the base pointer
		popfd
		ret

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
%macro print_int 1
		save_machine_state
		mov eax, %1 ; Move the number into eax
		cmp eax, 0x00 ; Check if the number is zero, if it is, we need to print 0 directly since the checks will not work
		je	%%_print_zero
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
%%_print_zero:
		push 0x30 ; Push the ASCII value of 0 to the stack
		mov eax, 4 ; syscall number for sys_write
		mov ebx, 1 ; file descriptor 1 is stdout
		mov ecx, esp
		mov edx, 1 ; we are going to write one byte
		int 0x80            ; invoke syscall
		pop ecx ; Pop the next digit off the stack
%%_end_print_loop:
		restore_machine_state
%endmacro

; Macro for printing to stdout
; Expects 1 argument (string) and automatically calculates it's length and outputs it
%macro print 1
section .data
		%%_str db %1, 0x00
section .text
		pushfd ; Save the flags register
		push eax
		push ebx
		push ecx
		push edx
		push edi
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
		pop edi
		pop edx
		pop ecx
		pop ebx
		pop eax
		popfd ; Restore the flags register
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

test_for_string:
		call input_blanks
		mov esi, input_string
		add esi, [input_string_offset]
		mov ecx, 0

		cmp byte [esi], '"'
		je  tfs_test_rest_chars_loop
		jmp tfs_not_matching
		; Manual string comparison loop

tfs_test_rest_chars_loop:
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
		je  tfs_end_of_string       ; If space is reached, end the loop
		cmp byte [esi], 0
		je tfs_end_of_string ; TODO: Maybe terminate?

		; Otherwise match the next chars
		jmp tfs_test_rest_chars_loop

tfs_not_matching:
		; Strings are not equal
		call set_false
		jmp tfs_end

tfs_end_of_string:
		; Add the length of the match and 2 characters for the quotes
		add ecx, 1
		add [input_string_offset], ecx
		call set_true

tfs_end:
		cmp eax, 1
		ret

test_for_id:
		call input_blanks
		mov esi, input_string
		add esi, [input_string_offset]
		mov ecx, 0 ; Initialize the length of the match to 0

		jmp tfi_test_first_char
		jz tfi_not_matching
		; Manual string comparison loop

tfi_test_first_char:
		lodsb                   ; Load the next byte from [esi] into AL, incrementing esi
		cmp al, 'A'
		jl  tfi_not_matching
		cmp al, 'Z'
		jle tfi_test_rest_chars_loop
		cmp al, '_'
		je  tfi_test_rest_chars_loop
		cmp al, 'a'
		jl  tfi_not_matching
		cmp al, 'z'
		jle tfi_test_rest_chars_loop
		jg tfi_not_matching

tfi_test_rest_chars_loop:
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
		je  tfi_matching       ; If null terminator is reached, end the loop
		cmp al, ' '
		je  tfi_matching       ; If space is reached, end the loop
		cmp al, 0x0A
		je  tfi_matching       ; If newline is reached, end the loop
		cmp al, ';'
		je  tfi_matching       ; If line terminator is reached, end the loop
		; Compare the first byte against 'a' to 'z', 'A' to 'Z', '_', and '0' to '9'
		cmp al, '0' ; Check for digits - Has to be first because 0x31 is 1 but 0x41 is A
		jl  tfi_not_matching
		cmp al, '9'
		jle tfi_test_rest_chars_loop
		cmp al, 'A'
		jl  tfi_not_matching
		cmp al, 'Z'
		jle tfi_test_rest_chars_loop
		cmp al, '_'
		je  tfi_test_rest_chars_loop
		cmp al, 'a'
		jl  tfi_not_matching
		cmp al, 'z'
		jle tfi_test_rest_chars_loop
		jg tfi_not_matching

tfi_matching:
		; Strings are equal
		add [input_string_offset], ecx
		call set_true      ; Set EAX to 1 to indicate equality
		jmp tfi_end

tfi_not_matching:
		; If the size of the match is bigger than 1 then it's a match
		cmp ecx, 0
		jg tfi_matching

		; Strings are not equal
		call set_false    ; Set EAX to 0 to indicate inequality
		jmp tfi_end

tfi_end:
		cmp eax, 1
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
		mov esi, %%_str ; Source
		mov edi, last_match ; Destination
		mov ecx, %%_str_length
		rep movsb ; Copy the string into last_match
		mov eax, %%_str_length
		add [input_string_offset], eax
		call set_true ; Set zero flag to 0 to indicate equality
		jmp %%_end

%%_strings_not_equal:
		; Strings are not equal
		call set_false		; Set the zero flag to false

%%_end:
		cmp eax, 1
%endmacro

test_for_number:
		call input_blanks
		mov esi, input_string
		add esi, [input_string_offset]

		; Store the length of the match
		mov cl, 0

		; Manual string comparison loop
		xor eax, eax            ; Clear EAX (result)

tfn_test_digit:
		cmp byte [esi], ' '       ; Check for space
		je  tfn_end_of_string       ; If space is reached, end the loop
		cmp byte [esi], 0
		je tfn_end_of_string
		cmp byte [esi], '0'
		jl tfn_not_matching
		cmp byte [esi], '9'
		jg tfn_not_matching

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
		inc cl ; Increment the length of the match
		mov byte [eax], 0x00

		; Otherwise match the next chars
		lodsb                   ; Load the next byte from [esi] into AL, incrementing esi
		jmp tfn_test_digit

tfn_not_matching:
		cmp cl, 0
		add byte [input_string_offset], cl
		jg tfn_end_of_string
		; Strings are not equal
		call set_false ; Set zero flag to 1 to indicate inequality
		jmp tfn_end

tfn_end_of_string:
		call set_true

tfn_end:
		cmp eax, 1
		ret

copy_last_match:
		save_machine_state ; Save the flags register
		mov eax, 4          ; syscall: sys_write
		mov ebx, 1          ; file descriptor: STDOUT
		mov ecx, last_match  ; string to write
		mov edx, 0          ; length will be determined dynamically
cl_calculate_length:
		cmp byte [ecx + edx], 0  ; check for null terminator
		je  cl_end_calculate_length
		inc edx
		jmp cl_calculate_length
cl_end_calculate_length:
		int 0x80            ; invoke syscall
		restore_machine_state ; Restore the flags register
		ret

gn1:
		save_machine_state ; Save the flags register
		call vstack_pop ; result will be in eax
		cmp eax, 0xFFFF
		je gn1_generate_new_number

gn1_print_label:
		print "LB"
		print_int eax

		mov bx, ax

		vstack_push bx

		jmp gn1_end

gn1_generate_new_number:
		add word [gn1_number], 1
		mov eax, [gn1_number]
		jmp gn1_print_label

gn1_end:
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

_start:
		call _read_file_argument
		call _read_file
		call PROGRAM
		mov eax, 1
		mov ebx, 1
		int 0x80

PROGRAM:
    test_input_string ".SYNTAX"
    jne A0 
    call test_for_id 
    jne terminate_program 
    label_with_newline "%define MAX_INPUT_LENGTH 65536"
		label_with_newline "%include './lib/asm_macros.asm'"

		label_with_newline "section .text"
		print_with_newline "global _start"
		label_with_newline "_start:"
		print_with_newline "call _read_file_argument"
		print_with_newline "call _read_file"
		print "call "
    call copy_last_match 
		call newline
		print_with_newline "mov eax, 1"
		print_with_newline "mov ebx, 1"
		print_with_newline "int 0x80"
A1: 
		vstack_push 0xFFFF
    call DEFINITION
		call vstack_pop
    jne A2 
A2: 
    je A3 
		vstack_push 0xFFFF
    call COMMENT
		call vstack_pop
    jne A4 
A4: 
A3: 
    je A1 
    call set_true 
    jne terminate_program 
    test_input_string ".END"
    jne terminate_program 
    call newline
A0: 
A5: 
    ret
OUT1:
    test_input_string "*1"
    jne A6 
    print "call gn1"
    call newline
A6: 
    je A7 
    test_input_string "*2"
    jne A8 
    print "call gn2"
    call newline
A8: 
    je A7 
    test_input_string "*"
    jne A9 
    print "call copy_last_match"
    call newline
A9: 
    je A7 
    call test_for_string
    jne A10 
    print "print "
    call copy_last_match 
    call newline
A10: 
A7: 
    ret
OUTPUT:
    test_input_string "->"
    jne A11 
    test_input_string "("
    jne terminate_program 
A12: 
		vstack_push 0xFFFF
    call OUT1
		call vstack_pop
    je A12 
    call set_true 
    jne terminate_program 
    test_input_string ")"
    jne terminate_program 
A11: 
    je A13 
    test_input_string ".LABEL"
    jne A14 
    print "call label"
    call newline
    test_input_string "("
    jne terminate_program 
A15: 
		vstack_push 0xFFFF
    call OUT1
		call vstack_pop
    je A15 
    call set_true 
    jne terminate_program 
    test_input_string ")"
    jne terminate_program 
A14: 
A13: 
    jne B16
    print "call newline"
    call newline
B16: 
A17: 
    ret
EX3:
    call test_for_id 
    jne A18 
		print_with_newline "vstack_push 0xFFFF"
    print "call "
    call copy_last_match 
		call newline
		print_with_newline "call vstack_pop"
A18: 
    je A19 
    call test_for_string
    jne A20 
    print "test_input_string "
    call copy_last_match 
    call newline
A20: 
    je A19 
    test_input_string ".ID"
    jne A21 
    print "call test_for_id"
    call newline
A21: 
    je A19 
    test_input_string ".ROL"
    jne A22 
    print "ROL"
    call newline
A22: 
    je A19 
    test_input_string ".RET"
    jne A23 
    print "ret"
    call newline
A23: 
    je A19 
    test_input_string ".NOT"
    jne A24 
    call test_for_string
    jne terminate_program 
    print "NOT"
    call copy_last_match 
    call newline
A24: 
    je A19 
    test_input_string ".NUMBER"
    jne A25 
    print "call test_for_number"
    call newline
A25: 
    je A19 
    test_input_string ".STRING"
    jne A26 
    print "call test_for_string"
    call newline
A26: 
    je A19 
    test_input_string "("
    jne A27 
		vstack_push 0xFFFF
    call EX1
		call vstack_pop
    jne terminate_program 
    test_input_string ")"
    jne terminate_program 
A27: 
    je A19 
    test_input_string ".EMPTY"
    jne A28 
    print "call set_true"
    call newline
A28: 
    je A19 
    test_input_string "$"
    jne A29 
    call label 
    call gn1
		print ":"
    call newline
		vstack_push 0xFFFF
    call EX3
		call vstack_pop
    jne terminate_program 
    print "je "
    call gn1 
    call newline
    print "call set_true"
    call newline
A29: 
A19: 
    ret
EX2:
		vstack_push 0xFFFF
    call EX3
		call vstack_pop
    jne A30 
    print "jne "
    call gn1 
    call newline
A30: 
    je A31 
		vstack_push 0xFFFF
    call OUTPUT
		call vstack_pop
    jne B32 
B32: 
A31: 
    jne A33 
A34: 
		vstack_push 0xFFFF
    call EX3
		call vstack_pop
    jne A35 
    print "jne terminate_program"
    call newline
A35: 
    je A36 
		vstack_push 0xFFFF
    call OUTPUT
		call vstack_pop
    jne A37 
A37: 
A36: 
    je A34 
    call set_true 
    jne terminate_program 
    call label 
    call gn1 
		print ":"
		call newline
A33: 
A38: 
    ret
EX1:
		vstack_push 0xFFFF
    call EX2
		call vstack_pop
    jne A39 
A40: 
    test_input_string "|"
    jne A41 
    print "je "
    call gn1 
    call newline
		vstack_push 0xFFFF
    call EX2
		call vstack_pop
    jne terminate_program 
A41: 
    je A42 
		vstack_push 0xFFFF
    call COMMENT
		call vstack_pop
    jne A43 
A43: 
A42: 
    je A40 
    call set_true 
    jne terminate_program 
    call label 
    call gn1 
		print ":"
    call newline
A39: 
A44: 
    ret
DEFINITION:
    call test_for_id 
    jne A45 
    call label 
    call copy_last_match
		print ":"
    call newline
    test_input_string "="
    jne terminate_program 
		vstack_push 0xFFFF
    call EX1
		call vstack_pop
    jne terminate_program 
    test_input_string ";"
    jne terminate_program 
    print "ret"
    call newline
A45: 
A46: 
    ret
COMMENT:
    test_input_string "/*"
    jne A47 
    ; NOT "*/"
    jne terminate_program 
    test_input_string "*/"
    jne terminate_program 
A47: 
A48:
    ret