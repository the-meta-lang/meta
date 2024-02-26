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

section .text
global _start

_start:
    ; Test input against string
		mov eax, 1
    call test_for_number
		call test_for_number
		call test_for_number

		mov eax, 4
		mov ebx, 1
		mov ecx, last_match
		mov edx, 4
		int 0x80

    ; Exit
		mov ebx, eax
		mov eax, 0x01
    int 0x80

section .data
    input_string db '10;', 0x00
		input_string_offset db 0

section .bss
	last_match resb 50
