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

; Macro for testing against input string
; Expects to be given a string to compare the input against
%macro test_input_string 1
section .data
		%%_str db %1, 0x00
section .text
		input_blanks
    mov edi, input_string
		add edi, [input_string_offset]
    mov esi, %%_str

    ; Input:
    ;   edi = address of the first string
    ;   esi = address of the second string
    ; Output:
    ;   Zero flag (ZF) set if strings are equal, cleared otherwise

    ; Manual string comparison loop
    xor eax, eax            ; Clear EAX (result)

%%_compare_loop:
		mov ebx, %%_str
    lodsb                   ; Load the next byte from [esi] into AL, incrementing esi
		cmp al, [edi]           ; Compare the byte with [edi]
    jne %%_strings_not_equal ; Jump if not equal
    test al, al             ; Check if we've reached the null terminator
    jz %%_strings_equal     ; If null terminator is reached, strings are equal
    inc edi                 ; Move to the next byte in the first string
    jmp %%_compare_loop     ; Repeat the loop

%%_strings_equal:
    ; Strings are equal
    mov eax, 1      ; Set EAX to 1 to indicate equality
		cmp eax, eax		; Set the zero flag to true
    mov esi, ebx    ; Reset esi to the original address of %%_str
    mov edi, ebx    ; Reset edi to the original address of %%_str
    mov [last_match], edi ; Store the address in last_match
    jmp %%_end

%%_strings_not_equal:
    ; Strings are not equal
    xor eax, eax    ; Set EAX to 0 to indicate inequality

%%_end:
%endmacro

section .text

_start:
    ; Test input against string
    test_input_string "hello"

		; Print "last_match"
		mov eax, 0x04
		mov ebx, 0x01
		mov ecx, [last_match]
		mov edx, 0x05
		int 0x80

    ; Exit
		mov ebx, eax
		mov eax, 0x01
		xor ecx, ecx
		xor edx, edx
    int 0x80

section .data
    input_string db "hello", 0x00
		input_string_offset db 0x00

section .bss
	last_match resb 10
