%macro gn1 0
		pop eax; Get gn2
		pop ebx; Get gn1
		cmp ebx, 0
		je %%_generate_new_number

%%_print_label:
		mov ebx, [gn1_number]
		push ebx
		push eax

		mov eax, 0x04
		mov ebx, 0x01
		mov ecx, 'A'
		mov edx, 1
		int 0x80
		mov eax, 0x04
		mov ebx, 0x01
		mov ecx, gn1_number
		mov edx, 1
		int 0x80
		jmp %%_end

%%_generate_new_number:
		add byte [gn1_number], 1
		jmp %%_print_label

%%_end:
%endmacro

section .text

_start:
		push 0 ; Push initial gn2 and gn1 onto stack
		push 0
    ; Test input against string
    gn1
		mov eax, 1
		mov ebx, 0
		int 0x80
section .data
    input_string db '124', 0x00
		input_string_offset db 0
		gn1_number db 0

section .bss
	last_match resb 50
